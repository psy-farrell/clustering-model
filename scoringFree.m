function scoringFree(allRes,allRTs,allCumRTs,parms, groupPos) %::::Function for scoring::::

%allCumRTs isn't analysed here--kept in for consistency with other code
%not included in this package

global score

%::::Accspc for ordered recall::::
score.acctmp = allRes == repmat(1:parms.ll, parms.nruns,1);
score.accspc = sum(score.acctmp)./parms.nruns;

score.meanInt = mean(mean(allRes>parms.ll));
score.meanIntPerList=sum(sum(allRes>parms.ll))./parms.nruns;
score.meanExtraIntPerList=sum(sum(allRes==9999))./parms.nruns;
score.meanPLIPerList= score.meanIntPerList - score.meanExtraIntPerList;

for i=1:5
    score.meanPLI(i) = sum(sum(floor((allRes-1)./parms.ll)==i))./parms.nruns;
end

% we mostly focus on recall of list items
allRes(allRes<=0) = NaN;
allRes(allRes>parms.ll) = NaN;

if isempty(allRTs)
    doRT = 0;
else
    doRT = 1;
end

% Tulving and Colotla PM-SM scoring
pm = (parms.ll - allRes + repmat(1:parms.ll, parms.nruns,1)-1)<=7;
score.pmTC = mean(sum(pm,2));
sm = (parms.ll - allRes + repmat(1:parms.ll, parms.nruns,1)-1)>7;
score.smTC = mean(sum(sm,2));

% Simpler last 4 or not PM-SM scoring
pm = allRes>=(parms.ll-3) & allRes<=parms.ll;
score.pm4 = mean(sum(pm,2));
sm = allRes<(parms.ll-3) & allRes>0;
score.sm4 = mean(sum(sm,2));

% Asch-Ebenholtz IO measure
goesFwd = (allRes(:,1:(end-1))<allRes(:,2:end)).* (allRes(:,2:end)>0).* (allRes(:,1:(end-1))>0);
goesBwd = (allRes(:,1:(end-1))>allRes(:,2:end)).*(allRes(:,2:end)>0).* (allRes(:,1:(end-1))>0); % use this to count up non-NaNs;

% Asch-Ebenholtz IO measure for immediate transitions
goesFwd1 = (allRes(:,1:(end-1))==(allRes(:,2:end)-1)).* (allRes(:,2:end)>0).* (allRes(:,1:(end-1))>0);
goesBwd1 = (allRes(:,1:(end-1))==(allRes(:,2:end)+1)).*(allRes(:,2:end)>0).* (allRes(:,1:(end-1))>0);

goesFwd = nansum(goesFwd,2);
goesBwd = nansum(goesBwd,2);
goesFwd1 = nansum(goesFwd1,2);
goesBwd1 = nansum(goesBwd1,2);

% Calculate it for each trial...
trialIO = goesFwd./(goesFwd + goesBwd);
trialIO1 = goesFwd1./(goesFwd1 + goesBwd1);
trialAcc = nansum(allRes>0 & allRes<=parms.ll,2)./parms.ll;

...and then look at correlations
score.IO = nanmean(trialIO);
score.IO1 = nanmean(trialIO1);
score.IOFRcor = corr([trialAcc trialIO], 'rows','complete');
score.IOFRcor1 = corr([trialAcc trialIO1], 'rows','complete');

% free recall stuff
% initialize
nrpData = zeros(parms.ll,parms.ll);
golomb = zeros(1,parms.ll);

nrpdenom = zeros(parms.ll,parms.ll);
alag = (-(parms.ll-1)):(parms.ll-1);
score.alag=alag;
nl = length(alag);

crpData = NaN([parms.ll nl]);
crpRT = NaN([parms.ll nl]);

for i=1:parms.ll
    j=(parms.ll-i)+(1:parms.ll);
    crpData(i,j) = 0;
    crpRT(i,j) = 0;
end
crpOPdata = repmat(crpData, [1 1 parms.ll]);

crpdenom = crpData;
crpOPdenom = crpOPdata;

winRT = 0;
winD = 0;
betRT = 0;
betD = 0;

for i=1:size(allRes,1)

    rSeq = allRes(i,1:end);
    recalled = [];
    possRecall = 1:parms.ll;

    if exist('groupPos') %#ok<EXIST>
        groupP = groupPos{i};
    end

    for k=1:parms.ll

        if rSeq(k)>0 && rSeq(k)<=parms.ll && ~any(rSeq(k)==recalled)

            % Golomb order scoring
            if k==1 || (rSeq(k)<=parms.ll && rSeq(k)>rSeq(k-1))
                golomb(rSeq(k)) = golomb(rSeq(k))+1;
            end
            
            % NRP
            nrpData(k,rSeq(k)) = nrpData(k,rSeq(k))+1;
            nrpdenom(k,possRecall) = nrpdenom(k,possRecall)+1;

            % CRP & timing
            if k>1 && rSeq(k-1)>0
                lag = rSeq(k) - rSeq(k-1);
                crpData(rSeq(k-1), lag+parms.ll) = crpData(rSeq(k-1), lag+parms.ll)+1;
                if doRT
                    crpRT(rSeq(k-1), lag+parms.ll) = crpRT(rSeq(k-1), lag+parms.ll) + allRTs(i,k);
                end
                crpOPdata(rSeq(k-1), lag+parms.ll, k-1) = crpOPdata(rSeq(k-1), lag+parms.ll, k-1)+1;
                possI = possRecall-rSeq(k-1)+parms.ll;
                
                crpdenom(rSeq(k-1), possI) = crpdenom(rSeq(k-1), possI)+1;
                crpOPdenom(rSeq(k-1), possI, k-1) = crpOPdenom(rSeq(k-1), possI, k-1)+1;
                
                if exist('groupPos','var') && ~isempty(allRTs) && rSeq(k)>0 && rSeq(k)<=parms.ll
                    if groupP(rSeq(k))==groupP(rSeq(k-1))
                        winRT = winRT+allRTs(i,k);
                        winD = winD+1;
                    else
                        betRT = betRT+allRTs(i,k);
                        betD = betD+1;
                    end
                end
            end
        end

        % get ready for next item
        if k<=parms.ll
            recalled = [recalled rSeq(k)]; %#ok<AGROW>
            possRecall = setdiff(possRecall,recalled);
        else
            break;
        end

    end
end

crpRT(crpRT<eps) = NaN; % not sure this is necessary or for historical reasons; leave it in

score.nrp = nrpData;
score.nrpdenom = nrpdenom;
score.frp = nrpData(1,:)./nrpdenom(1,:);
score.freeAcc = sum(nrpData)./parms.nruns;
score.crp = nansum(crpData)./nansum(crpdenom);
if doRT
    score.crpRT = nansum(crpRT)./nansum(crpData);
        score.winRT = winRT/winD;
    score.betRT = betRT/betD;
else
    score.crpRT = score.crp.*NaN;
end
score.crpOP = squeeze(nansum(crpOPdata,1)./nansum(crpOPdenom,1));

score.condRec = nrpData./nrpdenom;
score.golomb = golomb./parms.nruns;

