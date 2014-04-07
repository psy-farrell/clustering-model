G.vSize = 30;
G.intruderAct = .002;
G.openSet = 1;
G.prevLL = [12 12 12 12 12];

G.nRuns = 2000;

G.firstCue=.3;
G.lastProb = .9;

G.ll=12;
G.recTime = 30;

G.iRT = 1.5;

G.totOmmT = 3;

durs = repmat(1, G.nruns, G.ll); %#ok<RPMT1>
G.endDur = 1;

G.dursScale = .3;
G.controlPhiBase = .5;

G.retention='immed';

pch = '^o';

tcount=1;

for wmGroup = {'hi','lo'}
    tcount = 1;
    for task = {'free','free','free','free'}
        
        G.task = char(task);
        
        %% for simulations of Unsworth
        if strcmp(wmGroup, 'hi')
            G.G = 'tGroupStruct = randsample(6,tLL,true,[10 5 4 3 2 1 ])'';';
            G.Ge = 'endSize = randsample(6,1,true,[10 5 4 3 2 1])'';';
            G.controlPhi = G.controlPhiBase;
        elseif strcmp(wmGroup, 'lo')
            %G.controlPhi = .55;
            G.controlPhi = G.controlPhiBase*1.2;
            G.G = 'tGroupStruct = randsample(6,tLL,true,[25 4 2 1 1 1])'';';
            G.Ge = 'endSize = randsample(6,1,true,[25 4 2 1 1 1])'';';
        end
        
        G.prevLL = repmat(G.ll,1,tcount-1);
        
        model(G.x);
        
        allPM(tcount) = score.pmTC;
        allSM(tcount) = score.smTC;
        
        tcount=tcount+1;
    end
    
    if strcmp(wmGroup, 'hi')
        hiResults = [allPM; allSM];
    elseif strcmp(wmGroup, 'lo')
        loResults = [allPM; allSM];
    end
    
end

modelPMSM{1} = mean([hiResults(1,:); loResults(1,:)]);
modelPMSM{2} = mean([hiResults(2,:); loResults(2,:)]);

dataPMSM{1} = [    3.0420
    3.4390
    3.6590
    3.4330];
dataPMSM{2} = [    3.0360
    2.1690
    2.2920
    1.9900];

open UnsworthData.fig
open UnsworthModel.fig

figure(1)
subplot(2,2,4)
for i=1:2
    plot(0:3, dataPMSM{i}, ['-' pch(i) 'k']);
    hold all
end
xlabel('Number Preceding Lists');
ylabel('Memory Estimate');
title('Buildup of PI');
xlim([-0.5 3.5]);
ylim([0 4]);
legend('PM','SM','Location','SouthWest');

figure(2)
subplot(2,2,4)
for i=1:2
    plot(0:3, modelPMSM{i}, ['-' pch(i) 'k']);
    hold all
end
xlabel('Number Preceding Lists');
ylabel('Memory Estimate');
title('Buildup of PI');
xlim([-0.5 3.5]);
ylim([0 4]);
legend('PM','SM','Location','SouthWest');



% figure(1)
% prettySPC('../paper/final/UnsworthData.eps', [600 600])
% figure(2)
% prettySPC('../paper/final/UnsworthModel.eps', [600 600])
% 
% delete('../paper/final/UnsworthData*.pdf')
% delete('../paper/final/UnsworthModel*.pdf')