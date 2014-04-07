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

for task = {'free','free'}
    
    G.task = char(task);
    
    if tcount==1
        G.G = 'tGroupStruct = randsample(6,tLL,true,[10 5 4 3 2 1 ])'';';
        G.Ge = 'endSize = randsample(6,1,true,[10 5 4 3 2 1])'';';
        G.controlPhi = G.controlPhiBase;
    elseif tcount==2
        G.controlPhi = G.controlPhiBase.*1.2;
        G.G = 'tGroupStruct = randsample(6,tLL,true,[25 4 2 1 1 1])'';';
        G.Ge = 'endSize = randsample(6,1,true,[25 4 2 1 1 1])'';';
    end

    model(G.x);
    
    figure(2)
    subplot(2,2,2)
    plot(score.frp, ['-' pch(tcount) 'k']);
    hold all
    xlabel('Serial Position');
    ylabel('First Recall Probability');
    title('First Recall Probability');
    xlim([0.5 12.5]);
    ylim([0 1]);
    %legend('High WM','Low WM','Location','NorthWest');
    
    figure(2)
    subplot(2,2,1)
    plot(score.freeAcc, ['-' pch(tcount) 'k']);
    hold all
    xlabel('Serial Position');
    ylabel('Proportion Correct');
    title('Accuracy');
    xlim([0.5 12.5]);
    ylim([0 1]);
    legend('High WM','Low WM','Location','NorthWest');
    
    disp('Mean PLI (most recent last)')
    disp(score.meanPLI.*15); % multiply by 15 as this is number of trials
                    % in Unsworth and Engle (2007)
    
    figure(2)
    subplot(2,2,3)
    plot(score.meanPLI(end:-1:1), ['-' pch(tcount) 'k']);
    hold all
    xlabel('List Lag');
    ylabel('Number Intrusions Per List');
    title('Prior List Intrusions');
    xlim([0.5 5.5]);
    ylim([0 0.4]);
    %legend('High WM','Low WM','Location','NorthEast');
    
    tcount=tcount+1;
end
%---HERE BE DATA
dataSPC{1} = [    0.5100
    0.4500
    0.3700
    0.3300
    0.2800
    0.4100
    0.4000
    0.5600
    0.5800
    0.7800
    0.9300
    0.9600];

dataSPC{2} = [    0.3700
    0.3000
    0.2800
    0.2000
    0.2300
    0.2200
    0.2800
    0.4200
    0.3800
    0.6600
    0.8500
    0.9700];

dataFRP{1} = [    0.0290
    0.0119
    0.0041
    0.0020
    0.0112
    0.0241
    0.0596
    0.0500
    0.1010
    0.1510
    0.1280
    0.4270];
dataFRP{2} = [    0.0309
    0.0006
    0.0154
    0.0095
    0.0112
    0.0015
    0.0107
    0.0048
    0.0196
    0.0363
    0.0700
    0.7640];



dataPLI{1} = [    2.0220
    0.5730
    0.1920
    0.0863
    0.0808];
dataPLI{2} = [    3.0530
    0.9010
    0.4990
    0.2130
    0.2920];

%-----------------------------------
figure(1)
subplot(2,2,1)
for i=1:2
    plot(dataSPC{i}, ['-' pch(i) 'k']);
    hold all
end
xlabel('Serial Position');
ylabel('Proportion Correct');
title('Accuracy');
xlim([0.5 12.5]);
ylim([0 1]);
legend('High WM','Low WM','Location','NorthWest');

subplot(2,2,2)
for i=1:2
    plot(dataFRP{i}, ['-' pch(i) 'k']);
    hold all
end
xlabel('Serial Position');
ylabel('First Recall Probability');
title('First Recall Probability');
xlim([0.5 12.5]);
ylim([0 1]);
%legend('High WM','Low WM','Location','NorthWest');

subplot(2,2,3)
for i=1:2
    plot(dataPLI{i}./15, ['-' pch(i) 'k']);
    hold all
end
xlabel('List Lag');
ylabel('Number Intrusions Per List');
title('Prior List Intrusions');
xlim([0.5 5.5]);
ylim([0 0.4]);
%legend('High WM','Low WM','Location','NorthEast');

saveas(figure(1),'UnsworthData.fig'); % use saveas as we open these up with freeRecallPI.m
saveas(figure(2),'UnsworthModel.fig');