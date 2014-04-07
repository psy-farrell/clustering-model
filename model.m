function model (parms)

global G
global allRes
global allProbe
global allRTs
global allCumRTs
global durs
global allGroupStruct
global allnG

if G.init
    % this usage of rand/randn is deprecated in recent versions, but we use it here
    % for compatability with older versions of MATLAB
    rand('twister',12413); %#ok<RAND>
    randn('state',12413); %#ok<RAND>
end

if ~strfind(G.G, 'tLL')
    error('tLL needs to be in G.G');
end

% How many items do we probe for?
nProbe = G.ll;

allProbe = zeros(G.nruns,nProbe); % records order in which items were actually probed

%% intialization
rNoise = parms(1); %sigma_v

gPhi = parms(2); %phi_g
iPhi = parms(3); %phi_p

T0 = parms(4); % theta

outIntG = parms(5); % eta^O: output interference

giveUpG = parms(6); % T_G: omission criterion to give up on group

% initialize data matrices
allRes = zeros(G.nruns,nProbe);
allRTs = NaN(G.nruns, nProbe);
allCumRTs = NaN(G.nruns, nProbe);
allnG = zeros(G.nruns,1);
groupRTs = NaN(G.nruns, nProbe);

% we are going to put distractors in where preceding lists would usually
% go, to make dealing with them easier
nodistL = length(G.prevLL)+1;
if strcmp(G.retention, 'immed')
    totL = length(G.prevLL)+1; 
elseif strcmp(G.retention, 'delay')
    totL = 2; 
elseif strcmp(G.retention, 'CD')
    totL = G.ll+1; 
end
% totL contains the total number of lists, including current one

if (strcmp(G.retention, 'delay') || strcmp(G.retention, 'CD'))...
        && ~isempty(G.prevLL)
    error('Prior lists can''t be used for delay or CD simulations, as those bits are used for distractors');
end


%% LOOP ACROSS SIMULATION RUNS
for trial=1:G.nruns

    
    llStruct = [G.ll G.prevLL]; % a vector containing list lengths of current
        % and preceding lists
    
    % in delayed and CD recall, we put distractors in place of preceding lists
    % purely for convenience: distractors are assumed to be on the same
    % list as the immediately preceding items
    % (though in CD recall the list items and distractors are effectively
    % spread over lists
    if strcmp(G.retention, 'delay')
        llStruct = [llStruct G.lldist];
    elseif strcmp(G.retention, 'CD')
        llStruct = [llStruct repmat(G.lldist, 1, G.ll)];
    end
    
    groupStruct = [];
    nGroups = 0;
    groupPos = [];
    listPos = [];
    groupSize = [];
    groupOcc = [];
    
    
    %list = 1 is the current (target) list
    %list = 2:N is for preceding lists (although for convenience they actually
    % follow it in the vectors and matrices coding position
    
    % We now loop across all the lists and set stuff up as it would be at the
    % end of encoding of the target list
  
    for list=1:totL
        %% set up grouping structure
        
        tLL = llStruct(list);
        
        % tGroupStruct ends up being a vector listing the group size of 
        % all the groups in the list currently being dealt with
        if strcmp(G.task, 'serialUG')
            tGroupStruct = tLL;
            tnGroups = 1;
            tGroupSize = 1;
        else
            
            %--this code sets up a groupStruct such that all groups except
            % last determined by G.G, last determined by G.Ge
            % (G.G and G.Ge are set in calling functions)
            % The group preceding the last is truncated if necessary
            
            if list==1 % is it the target list?
                if strcmp(G.retention, 'CD')
                    tGroupStruct = ones(1,tLL); % we assume that each item is in it's own group
                    endSize= 1;
                else
                    eval(G.G);
                    eval(G.Ge);
                end
            elseif list<=nodistL % is it a preceding list (ie not a "list" containing
                % information about distractors)?
                eval(G.G);
                eval(G.Ge);
            else
                if strcmp(G.retention, 'immed')
                    error('You shouldn''t be able to get here');
                elseif strcmp(G.retention, 'delay') || strcmp(G.retention, 'CD')
                    tGroupStruct = tLL; % a single group containing the distractors
                    endSize= tLL;
                end
            end
            
            % at this point, tGroupStruct often contains too many groups,
            % as to be safe we make as many groups as there are list items
            % (just in case all groups happen by chance to contain a single
            % item--unlikely, but it could happen!)
            
            % the next bit finds the last group, sets it to size endSize,
            % and does some truncation if necessary 
            % to make the number of groups and group sizes
            % fit with the list length
            
            cumG = cumsum(tGroupStruct); %cumG stores terminal serial position of each group
            
            if endSize > 0 %--make the last group of size endSize
                lg = find((cumG>(tLL-endSize)),1, 'first'); % find the last group that will run in
                % to the end group given endSize
                
                if lg>1
                    tGroupStruct(lg)=tLL - endSize - cumG(lg-1);
                else
                    tGroupStruct(lg)=tLL - endSize;
                end
                
                if endSize>tLL
                    endSize = tLL;
                end
                
                tGroupStruct(lg+1) = endSize;
                tGroupStruct = tGroupStruct(1:(lg+1));
                tGroupStruct = tGroupStruct(tGroupStruct>0);
                
                tGroupSize = ones(1, length(tGroupStruct));
                
            else % -- if endsize = 0, signals that we truncate the last group
                % tGroupSize scales within-group markers to reflect the
                % fact that a group may have finished before we expected it
                % to
                lg = find((cumG>=tLL),1, 'first');
                if lg>1
                    tGroupStruct(lg)=tLL -cumG(lg-1);
                else
                    tGroupStruct(lg)=tLL;
                end
                
                tGroupStruct = tGroupStruct(1:lg);
                
                tGroupSize = ones(1, length(tGroupStruct));
                if lg>1
                    tGroupSize(lg) = (tLL - cumG(lg-1))./(cumG(lg)-cumG(lg-1));
                else
                    tGroupSize(lg) = tLL./cumG(1);
                end
            end
            
            % tgroupStruct now specifies an ordered set of group sizes
            tnGroups = length(tGroupStruct);
        end
        
        if list==1
            nG = tnGroups; % number of groups on target list
        end
        
        % collect information from different lists in a single set of
        % vectors
        % Tip to non-experts in MATLAB: building up vectors in this way by
        % sticking stuff on the end is slow and inefficient (since MATLAB
        % can't preallocate memory), but is easier to follow
        
        groupStruct= [groupStruct tGroupStruct]; 
        groupSize = [groupSize tGroupSize]; %#ok<*AGROW>
        nGroups = nGroups + tnGroups;
        groupPos = [groupPos 1:tnGroups]; %#ok<AGROW>
        listPos = [listPos repmat(list,1,tLL)]; %#ok<AGROW>
        groupOcc = [groupOcc repmat(list,1,tnGroups)]; %#ok<AGROW>
    end
    
    % So now we have:
    % groupStruct: a vector listing the number of items in all groups
    %   (including preceding lists and groups of distractors)
    % groupSize: indicates how much of the within-group scale is used up by
    %    each group. Typically =1, but will be less if a group has been
    %    unexpectedly truncated
    % nGroups: the number of groups in total
    % nG: the number of groups on the target list
    % groupPos: a vector indicating the ordinal position of each group in
    %   its list
    % groupOcc: a vector indicating in which list each group is contained
    % listPos: a vector indicating in which list each item is contained

    % we are simply recording in the next two rows--this info isn't used
    % any further
    allGroupStruct{trial} = groupStruct;
    allnG(trial) = nG;
    
    %% ---trial initialization
    nItems = sum(llStruct);
    
    iMark = zeros(1,nItems); % coding of item in position
    gMark = zeros(1,nItems); % position of group in list
    
    GImat = zeros(totL+1,1);% GImat is only temporarily used below
    
    LGocc = zeros(nGroups, G.ll + totL + 2); % records all contexts each group occurred in (columns)
    LGw = zeros(nGroups, G.ll + totL + 2); % and the learning rates for those occurrences
    
    GIocc = zeros(nItems,G.ll + totL + 2); % which items occurred in which groups?
    GIw = zeros(nItems,G.ll + totL + 2 ); % and learning rates for these associations
    
    PIocc = zeros(nItems,G.ll + totL + 2); % which items were presented at which within-group positions?
    % there is no PIw--set this to GIw for simplicity, to reflect the use
    % of eta_j^GV in Equations A9 and A13
    
    % ------------------set up the markers ------------------%
    iPos=1; % this tracks the first item in successive groups
    
    for group=1:nGroups %--cycle through all groups, on current and preceding lists
        
        kk = groupStruct(group); % kk is the group length
        gMark(iPos:(iPos+kk-1))=group; % all items in the group get the same group marker
        
        % work out 0 to 1 scaling representation for within-group markers
        if kk>1
            iMark(iPos:(iPos+kk-1))=(0:(kk-1))/(kk-1).*groupSize(group);
        else
            iMark(iPos)= 0; % just put in 0 for group size 1
        end
        
        GImat(iPos:(iPos+kk-1)) = (1-G.iPrimacy).^((1:kk)-1); % associate items to their group
        % with an exponential primacy gradient within groups
        
        if strcmp(G.retention, 'delay') && groupOcc(group)>nodistL
            LGocc(group,1) = 1; % all "groups" on same list (some are actually distractors)
        else
            LGocc(group,1) = groupOcc(group); % position of list
        end
        % LGocc is now a matrix of all zeros, except for the first column,
        % which records in which list each group was presented
        
        LGw(group,1) = 1; % this will get updated according to Equation A3 further down 
        
        iPos = iPos+kk;
        
    end
    
    % --the next bit works out recycling of within- and between-group position 
    % depending on whether items are re-used from trial to trial
    % (ie open set vs closed set)
    for list=1:totL
        tLL = llStruct(list);
        
        if G.openSet
            % --- open set
            
            PIocc(listPos==list,list) = iMark(listPos==list); % this basically splits
            %   iMark into separate columns, one column per list
            
            GIw(listPos==list,list) = GImat(listPos==list); % this does the same
            % for the eta^GV
            GIocc(listPos==list,list) = gMark(listPos==list); % this does the same
            % for GIocc, which tracks in which group each item occurred
            
        else
            % --- closed set
            
            % this basically aligns previous lists (which contain the same items)
            % with the current list
            % ie for a particular item in a particular position on the current
            % list, was what was the within-group position, group-in-list position,
            % and eta^GV for the current list and all previous lists?
            
            % note that this shouldn't be combined with distractors (ie
            % delay or CD recall)
            if list==1
                prevOrder = 1:tLL;
            else
                prevOrder = randperm(tLL);
            end
            
            temp = iMark(listPos==list);
            PIocc(listPos==1,list) = temp(prevOrder);
            temp = GImat(listPos==list);
            GIw(listPos==1,list) = temp(prevOrder);
            temp = gMark(listPos==list);
            GIocc(listPos==1,list) = temp(prevOrder);
        end
    end
    
    % PIocc, GIw and GIocc are all the same size, so we can apply
    % elementwise multiplication PIocc.*GIw, and GIocc.* GIw
    % This will happen below as part of Equations A11 and A14
    
    % In this next bit, we justify all groups and items with respect to the
    % beginning of the current list
    if totL>1
        if G.openSet
            if nodistL>1 % are there preceding (i.e., non-distractor) lists?
                GIocc(:,2:nodistL)=GIocc(:,2:nodistL)-max(max(GIocc(:,2:nodistL)));
            end
            if strcmp(G.retention, 'CD')
                GIocc(:,2:totL)=GIocc(:,2:totL)-G.ll; %this makes elements that were zero
                % non-zero, but that doesn't matter as the weights for
                % these items is zero
            end
        elseif G.openSet==0
            if length(unique(llStruct))>1
                error('ll must be constant for closed set');
            else
                GIocc(1:G.ll,2:totL)=GIocc(1:G.ll,2:totL)-max(max(GIocc(:,2:totL)));
            end
        end
        if strcmp(G.retention, 'CD')
            GIocc(:,1)=GIocc(:,1)-max(GIocc(:,1)); % in CD recall, each list
            % item is assumed to be in its own list
            % this justifies all list items with respect to the last (such
            % that the last presented item is the closest to the context
            % at retrieval)
        end
    end
    
    LGocc(LGocc>1) = LGocc(LGocc>1) - max(LGocc(LGocc>1));
    
    % Next two lines add on the noise as per Equation A10
    randMat = randn(size(GIw)).*G.wNoise;
    GIw(GIw>0) = GIw(GIw>0) + randMat(GIw>0);
    
    % Now we weight input from within-group position markers by recency for preceding lists
    % A theoretically interesting alternative would be tensor product
    % binding, so that group gates the associations between items and
    % positions
    
    % careful--need to reverse: higher index is more recent list (except
    % for first column, which is most recent list)
    if totL>1
        if strcmp(G.retention, 'CD')
            GIw(1:G.ll,1) = G.controlPhi.^((G.ll:-1:1)-1);
            GIw(:,2:totL) = GIw(:,2:totL).*repmat(G.controlPhi.^(((totL-1):-1:1)-1),nItems,1);
            LGw(:,1) = 1; % all items on same list
        elseif strcmp(G.retention, 'immed')
            GIw(:,2:totL) = GIw(:,2:totL).*repmat(G.controlPhi.^((totL-1):-1:1),nItems,1);
        end % else if delayed recall, leave as is--no weighting is needed as the distractors
            % are on the same list as the list items
    end
    
    % we also modify groupPos at this point
    if strcmp(G.retention, 'delay')
        groupPos(end) = nG+1;
    elseif strcmp(G.retention, 'CD')
        groupPos((G.ll+1):(nGroups)) = (G.ll+1):(nGroups);
    end
    
    % dursBump implements the exponential term in Equations A3 and A8
    % durs is set by the calling function, and specifies timing
    % for each list
    % Rather than setting the timing explicitly for preceding lists,
    % we just use the timings from other target lists from different trials
    % Accordingly, it's important that durs is as wide as the largest possible
    % list length
    dursBump = [];
    if ~isempty(durs)
        trialRange = mod((trial:(trial+length(llStruct)-1))-1,G.nruns)+1;
        groupStarts = cumsum([1 groupStruct]);
        for tempt = 1:length(llStruct)
            gRange = groupStarts((groupOcc==tempt));
            gRange = gRange-min(gRange)+1;
            % next line works out d_j by averaging preceding and following durations
            bump = (durs(trialRange(tempt),gRange) + ...
                [durs(trialRange(tempt),gRange(2:end)) G.endDur])/2;
            dursBump = [dursBump (1-exp(-bump.*G.dursScale))]; %#ok<AGROW>
        end
        LGw(:,1) = LGw(:,1).*dursBump'; % first term in Equation A3
    end
    LGw(:,1) = LGw(:,1)+randn(size(LGw(:,1))).*G.gNoise;% add on noise as per Equation A3
    
    % whichGroup is a data matrix to look at btw vs within transitions
    whichGroup{trial} = GIocc(1:G.ll,1); %#ok<AGROW>
    
    if strcmp(G.retention, 'CD')
        
        % Next two lines modify LGocc to reflect the fact that each list
        % item is encoded on a different list
        % The most recent item has a value of 1
        LGocc(1:G.ll,1) = -(G.ll-1):0;
        LGocc(:,1) = LGocc(:,1)+1;
        
        % shift distractor groups along to account for intervening list items
        for i=1:G.ll
            GIocc(:,nodistL+i) = GIocc(:,nodistL+i) + i;
        end
        
        %...and shift list items around to account for intervening
        %distractor groups
        GIocc(1,1) = 1;
        for i=2:G.ll
            GIocc(i,1) = max(GIocc(:,nodistL+i-1))+1;
        end
        
    end
    
    % make groupToGroupmark, which squashes the group membership
    % information in GIocc into a single vector for CD recall
    groupToGroupMark = [];
    for i=1:totL
        groupToGroupMark = [groupToGroupMark; sort(unique(GIocc(GIocc(:,i)>0,i)))];
    end
    
    %% -----RECALL------------%%
    newGroup = 1; % are we recalling a new group (yes we are)?
    groupCount = 0; % how many groups (including current one) recalled so far?
    recGroups = []; % tracks groups recalled
    
    r = zeros(1, nItems + G.vSize); % initialize response suppression vector 
    
    gSuppress = zeros(1,nGroups); % used to track recall of groups for suppression
    
    if ~G.openSet
        r((G.ll+1):end) = 1; % suppress items outside current list (expt vocab)
    end
    
    if strcmp(G.retention,'delay') || strcmp(G.retention,'CD')
        r((G.ll+1):end) = 1; % suppress distractors--we assume they come from a different set
    end
    
    gOmm = 0; % tracks number of successive omissions within group
    totOmm = 0; % tracks total number of omissions
    
    currContext = 1; % current list context
    
    rt = G.initRT; % add on time to begin recall (see section "Dynamics of recall") 
    cumrt = G.initRT;
    

    litem=1;
    allProbep = 1; % tracks the items that were probed for; mostly relevant for wrapping expt
    givingUp = 0; % if set to 1 later on, we've given up and are just recording omissions in output file
    
    % Sample the recall strategies to be used on this trial
    useLast = rand < G.lastProb; % start with last group
    onlyLast = rand < G.onlyLastProb; % start with last and then stop (see Simulation 8)
    useStart = rand < G.firstCue; % did we nominally encode first group irrespective of preceding factors
    
    %% Output position loop

    while litem <= nProbe && litem <= G.ll
        
        if G.printOut
            disp(['Output position ' num2str(litem)]);
        end
        
        %% ------------retrieve a new group if needed
        if newGroup
            
            cueForEnd = 0; % indicates whether we are recalling last group first
                % (if so, we have intact group context and don't need to
                % retrieve)
            groupCount = groupCount+1;
            
            nullGroup = 0; %#ok<NASGU>
            
            groupActs = sum((feval(G.markers, currContext,LGocc,G.controlPhi)).*LGw,2); %Equation A7
            
            %--determine order of group probing
            % For serial or wrapping, cues are provided by "numbering",
            % as reflected in "groupProbe
            % This is also the case for the Dalezman simulation
            % The first group may also be labelled in free recall
            
            % "currGroup" is the group we actually pull out
            
            if strcmp(G.task, 'free')
                
                % Dalezman simulation: start with cued group
                if groupCount==1 && strcmp(G.retention,'immed') && G.Dalezman && G.dalCue<4
                    % If in Dalezman 76 paradigm, prioritize cued group
                    if G.dalCue == 1 % start cue
                        dCue = 1;
                    elseif G.dalCue ==2 % middle cue
                        if nG>3
                            if rand<0
                                dCue = randsample(2:(nG-1), 1, true, ones(1, nG-2));
                            else
                                dCue = ceil(nG/2);
                            end
                        else
                            dCue = 2;
                        end
                    elseif G.dalCue==3 % end cue
                        dCue = nG;
                    end
                    groupActs(groupPos==dCue) = groupActs(groupPos==dCue)+G.srAct; % adds on c_NC
                    if dCue==nG
                        cueForEnd = 1;
                    end
                    
                    %--cue for last group (intact context)
                elseif groupCount==1 && strcmp(G.retention,'immed') && (useLast || onlyLast)
                    cueForEnd = 1;
                    
                elseif useStart && ~any(recGroups==1)
                    groupActs(groupPos==1) = groupActs(groupPos==1) + G.srAct;
                    
                end
                
            elseif strcmp(G.task, 'serialUG') || strcmp(G.task, 'serialG')
                groupProbe = min(groupCount,nG); %this makes us continue cueing for last group just in case
                % we run beyond end of the list
                
                if strcmp(G.task, 'serialUG') || nG==1 %--ungrouped
                    cueForEnd = 1;
                else
                    if onlyLast % this is primarily for Simulation 8
                        cueForEnd = 1;
                        
                    % we ignore useLast here, though I guess people could use a strategy
                    % of recalling the last item and then going back to start in serial recall
                    
                    else %---use cue for the group we want
                        groupActs(groupPos==groupProbe) = groupActs(groupPos==groupProbe) + G.srAct;
                    end
                end
                
            elseif strcmp(G.task, 'wrap')
                
                groupProbe = mod(G.startG+groupCount+1,nG)+1;
                % work out which item begins target group
                
                if groupCount==1 && groupProbe==nG && useLast
                    cueForEnd= 1; %--intact context for last group when first recalled
                else
                    groupActs(groupPos==groupProbe) = groupActs(groupPos==groupProbe) + G.srAct;
                end
            end
            
            % now we either have last group present, or must retrieve group context
            if cueForEnd == 1
                % if immediately probing for last group, no need to retrieve
                groupAct = 1; % proportion of unit activations carried over to test
                currGroup = nG;
                nullGroup=0;
            else
                
                % winner-takes-all selection of a group
                [temp,currGroup] = max(groupActs); %#ok<ASGLU> % temp left in for backwards compatability
                
                % add on time taken to retrieve group context
                rt = rt + G.gRT;
                cumrt = cumrt + G.gRT;
                
                groupRTs(trial, groupCount) = rt; % this is just tracking time to recall groups
                                                 % across output
                                                 
                if any(find(gSuppress)==currGroup) % we've already recalled the group, so we get
                                                % a null context
                    groupAct = 0;
                    nullGroup = 1;
                else
                    nullGroup=0;
                    groupAct = dursBump(currGroup); % gives us p_j^CG
                end
            end
            

            currProbe = find(gMark==currGroup,1,'first'); % start recalling from start of that group
            allProbep = currProbe; % used to indicate what item we were probing for
            
            if G.printOut
                disp(['Recalled group ' num2str(currGroup)]);
                if currGroup>nG
                    disp('Extra-list group');
                elseif currGroup~=groupProbe
                    disp('Group Transposition');
                end
            end
            
            % group-level output interference for newly recalled groups
            % this just makes groups more accessible
            % a more complete model would probably add new features to
            % group context each time it is retrieved
            if ~nullGroup
                if cueForEnd
                    % there is the potential to have less output interference for the last group
                    % when first recalled (see, e.g., Cowan wrapping data and
                    % negative recency effects in FFR)
                    LGw(currGroup,litem+1) = outIntG.*G.outIntE;
                else
                    LGw(currGroup,litem+1) = outIntG;
                end
            end
            
            gSuppress(currGroup) = 1; % record recall of current group
            % we can't recall this context again
            
            % update our list of recalled groups
            recGroups = [recGroups currGroup];
            
            newGroup = 0;
            inGroupCount = 1; % tracks our progress through a group
            gOmm = 0; % tracks the number of omissions in recalling from this group
            
        else % if not newGroup
            currProbe = currProbe+1;
            inGroupCount = inGroupCount+1;
            
        end %---------- end retrieval of new group or not
        
        %% Item retrieval
        
        % which item were we aiming for?
        if strcmp(G.task, 'serialG') || strcmp(G.task, 'serialUG')
            targItem = litem;
        elseif strcmp(G.task, 'wrap')
            targItem = rem(litem+(G.startG-1)*groupStruct(groupProbe)-1,G.ll)+1;
        else
            targItem = NaN; % weren't aiming for any particular item; just fill in with NaN
        end
        
        allProbe(trial,litem) = targItem;
        
        % Each item is pulled out according to match to recalled group, and weight
        % of association to group marker
        
        % Be careful with difference between groupMark (position of group
        % in matrices such as LGocc)
        % and currGroupMark (ordinal position of group in time)
        if strcmp(G.retention, 'CD')
            currGroupMark = groupToGroupMark(currGroup);
        else
            if currGroup<=nG
                currGroupMark = currGroup;
            elseif currGroup<=nodistL
                currGroupMark = currGroup - nGroups;
            else
                currGroupMark = currGroup;
            end
        end
        
        gMatch = sum(feval(G.markers, currGroupMark,GIocc,gPhi).*GIw,2); % Equation A11
        gMatch = gMatch/sum(gMatch).*(1-nullGroup); % if it's a null group, wipe out this info
        
        iMatch = sum(feval(G.markers, iMark(currProbe),PIocc,iPhi).*GIw,2); % Equation A14
        ieMatch = iMatch./sum(iMatch);
        
        match = (G.gWeight).*gMatch'.*groupAct  + G.pWeight.*(ieMatch)'; % Equation A15
        
        % Equation A16
        match = ([match repmat(G.intruderAct,1,G.vSize)] + normrnd(0, rNoise, 1, nItems+G.vSize)).*(1-r);
        
        % thresholded winner takes all
        diffs = sort(match);
        match2 = diffs(end) - diffs(end-1); % criterion for omission is relative "activation" of item
        
        updateLitem = 1; % indicates whether we record response, don't, or give up
        
        if match2>T0
            [temp,itptr] = max(match); %#ok<ASGLU>
            if G.printOut
                disp(['Recalled item ' num2str(itptr)]);
            end
            
        elseif ~givingUp
            itptr = -1;
            if strcmp(G.task, 'free') || G.looseSerial
                updateLitem = 0; % output position won't be updated as model didn't report anything:
                               % in many paradimgs omissions are covert
            end
            if G.printOut
                disp('Omitted an item');
            end
        end
        
        %% item rt
        trt = exprnd(G.iRT); % sample item retrieval time from an exponential
        rt = rt + trt; 
        cumrt = cumrt + trt;
        
        if givingUp
            updateLitem = 1;
            % don't do anything
        elseif cumrt > G.recTime % out of time
            allRes(trial,litem:end) = -1;
            allRTs(trial,litem:end) = NaN;
            allCumRTs(trial, litem:end) = NaN;
            givingUp = 1; % don't do any more scoring
            if strcmp(G.task, 'free')
                updateLitem = 100000; % forces exit from trial
            end
            if G.printOut
                disp('Trial timed out');
            end
        elseif itptr>0 && ~givingUp % record the response

            r(itptr) = 1; % suppress the item
            
            if itptr>(nItems) % extra-experiment recall
                allRes(trial,litem) = 9999; % arbitrary numerical code
                allRTs(trial,litem) = rt;
                allCumRTs(trial,litem) = cumrt;
            else % recall from list, or possibly preceding list
                % itptr <= list length is recall from current list
                allRes(trial,litem) = itptr;
                allRTs(trial,litem) = rt;
                allCumRTs(trial,litem) = cumrt;
            end
            
            rt = 0; % we made a response, so now start IRT from scratch
            
        else
            % failed to recall any item
            % if not free recall or "loose" serial recall, make an omit response
            totOmm = totOmm + 1;
            gOmm = gOmm+1;
            if (~strcmp(G.task, 'free')) && G.looseSerial==0
                allRes(trial,litem) = -1;
                allRTs(trial,litem) = NaN; % omissions actually have an associated latency, but
                                        % not modelling it here (a NaN instead 
                                        % is useful for later analyses)
                allCumRTs(trial,litem) = NaN;
                rt = 0;
            end
            if totOmm >= G.totOmmT
                % give up
                allRes(trial,litem:end) = -1;
                allRTs(trial,litem:end) = NaN;
                allCumRTs(trial,litem) = NaN;
                givingUp=1; % don't do any more scoring
                if ~strcmp(G.task, 'free')
                    updateLitem = 1; %keep ticking through to record probed positions for remaining omissions
                                % as these are needed for serial recall scoring
                else
                    updateLitem = 10000; %force exit from trial
                end
                if G.printOut
                    disp('Gave up');
                end
            elseif gOmm >= giveUpG
                
                if G.printOut && gOmm >= giveUpG
                    disp('Too many item omissions--recalling a new group');
                end
                newGroup=1; % on next recall, pull a new group out
            end
        end
        
        % Start new group if reached length of current group (assumed to be known)
        if inGroupCount==groupStruct(currGroup)
            if G.printOut
                disp('Reached end of group--recalling a new group');
            end
            newGroup=1;
        end
        
        if (newGroup==1 && groupCount==1 && G.aboveTheLine) || ...
                (newGroup==1 && onlyLast)
            
            allRes(trial,(litem+1):end) = -1;
            allRTs(trial,(litem+1):end) = NaN;
            allCumRTs(trial,(litem+1):end) = NaN;
            updateLitem = 10000;
        end
        
        litem = litem + updateLitem;
        allProbep = allProbep + updateLitem;
        
    end % end of output pos loop
    
end % end of trials loop

scoringFree(allRes,allRTs,allCumRTs,G,whichGroup);