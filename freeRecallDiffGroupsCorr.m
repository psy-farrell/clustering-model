G.vSize = 30;
G.intruderAct = .002;
G.openSet = 1; % are prev lists new ites, or permutations of items from current list?

G.firstCue=0.3;

G.ll=10;
G.prevLL = [G.ll G.ll G.ll G.ll G.ll];

G.recTime = 30;

G.iRT = 1.5;

G.totOmmT = 3;

G.lastProb = .5;

durs = repmat(1, G.nruns, G.ll); %#ok<RPMT1>
G.endDur = 1;

G.dursScale = .3;

controlPhiMean = .5;
controlPhiSD = .05;
gMixMean = .5;
gMixSD = .2;

G1 = [10 5 4 3 2 1];
G2 = [25 4 2 1 1 1];

pch = '^o';

G.retention='immed';

G.nruns = 10; % this is the number of trials per participant
G.nParp = 135; % number of participants
G.nReps = 10; % number of replications

rand('twister',12413); %#ok<RAND>
randn('state',12413); %#ok<RAND>

G.init=0; % we want different results each time, as these are like independent reps of an experiment

controlPhiBase = G.controlPhi;
G.task = 'free';

for rep=1:G.nReps
    
    pind = 1;

    for parp = 1:G.nParp
        zPhi = randn(1);
        zGroup = randn(1);
        
        G.controlPhi = controlPhiMean - controlPhiSD.*zPhi;
        Gweight = gMixMean + gMixSD.*zGroup;
        if Gweight > 1
            Gweight = 1;
        elseif Gweight< 0
            Gweight = 0;
        end
        
        Gcomb = Gweight.* G1 + (1-Gweight).*G2;
        
        G.G = ['tGroupStruct = randsample(6,tLL,true,[' ...
            num2str(Gcomb) '])'';'];
        G.Ge = ['endSize = randsample(6,1,true,[' ...
            num2str(Gcomb) '])'';'];
        
        model(G.x);
        allPM(pind) = score.pmTC;
        allSM(pind) = score.smTC;
        allFreeAcc(pind,:) = score.freeAcc;
        allIFR(pind) = mean(score.freeAcc);
        allWMC(pind) = zPhi + zGroup;
        pind = pind+1;
    end
    
    mean(allPM)
    mean(allSM)
    std(allPM)
    std(allSM)
    
    modelAcc(rep,:) = mean(allFreeAcc);
    
    kk = [allPM' allSM' allIFR' allWMC'];
    
    modelMeans(rep,:) = mean(kk);
    
    [modelCorrs(:,:,rep), modelCorrPs(:,:,rep)] = corr(kk);
    
    p1 = partialcorr(kk(:,[1 4]), kk(:,2));
    p2 = partialcorr(kk(:,[2 4]), kk(:,1));
    
    modelPartial(rep,:) = [p1(1,2) p2(1,2)];
    
    [Lambda,Psi,T] = factoran(allFreeAcc,2,'rotate','promax')
    modelFacs(:,:,rep) = Lambda;
end

disp('allPM allSM allIFR allWMC');
disp(mean(modelCorrs,3));

disp('Partial corrs')
disp(mean(modelPartial,1));
% save USBmodelling.mat modelAcc modelMeans modelCorrs modelCorrPs modelPartial modelFacs
