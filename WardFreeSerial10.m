G.vSize = 30;
G.intruderAct = .002;
G.openSet = 1;
G.prevLL = [8 8 8 8 8]; % roughly average list length for prior lists

G.delay = 0;
G.firstCue=.2;

G.recTime = 60;

G.retention = 'immed';
G.task = 'free';

G.iRT = 1.5;

G.totOmmT = 8;

durs = repmat(1, G.nruns, 15); %#ok<RPMT1>
G.endDur = 1;

G.dursScale = .5;

tRange = 1:15;

allIO = NaN(1, max(tRange));
allIOFRcor = NaN(1, max(tRange));
allIO1 = NaN(1, max(tRange));
allIOFRcor1 = NaN(1, max(tRange));

for tcount=tRange

    G.G = 'tGroupStruct = randsample(6,tLL,true,[5 4 6 5 2 1])'';';
    G.Ge = 'endSize = 0'';'; %this indicates that last group is truncated

    G.x(4) = .015/log(tcount+1);%.017;
    
    G.ll = tcount;
    
    G.lastProb = G.ll/15;
    
    model(G.x);

    figure(1)
    subplot(2,2,1);
    plot(score.freeAcc, '-o', 'Color', [1 1 1].*tcount./30);
    xlim([0 16]);
    ylim([0 1]);
    xlabel('Serial Position');
    ylabel('Proportion Recalled');

    hold all
    ylim([0 1]);

    firstProb(tcount) = score.frp(1);
    lastInd = max(2, G.ll-4+1):G.ll;
    lastProb(tcount) = sum(score.frp(lastInd));
    midProb(tcount) = sum(score.frp(setdiff(1:G.ll, [1 lastInd])));
    pmTC(tcount) = score.pmTC;
    smTC(tcount) = score.smTC;
    
    
    freeAcc(tcount) = mean(score.freeAcc);
    
    if tcount>1
        plus1(tcount) = score.crp(G.ll+1);
        allIO(tcount) = score.IO;
        allIOFRcor(tcount) = score.IOFRcor(1,2);
        allIO1(tcount) = score.IO1;
        allIOFRcor1(tcount) = score.IOFRcor1(1,2);
        crp1(tcount) = score.crp(tcount+1);
    end
    
end

dataIO = [       NaN
    0.9329
    0.9331
    0.8032
    0.7511
    0.6342
    0.5601
    0.5786
    0.5332
    0.5010
    0.5135
    0.4859
    0.5070
    0.4654
    0.4992];

dataIO1 = [       NaN
    0.9329
    0.9172
    0.7797
    0.7686
    0.7114
    0.6596
    0.7559
    0.6705
    0.6837
    0.6474
    0.6416
    0.6897
    0.6868
    0.6908];

dataIOFRcor = [       NaN
       NaN
    0.0822
    0.1579
    0.0457
    0.1312
   -0.0029
   -0.0099
   -0.0792
    0.0823
   -0.0780
    0.0533
   -0.0333
    0.1581
    0.0976];

dataIOFRcor1 = [       NaN
       NaN
    0.0461
    0.1647
   -0.0452
    0.0772
   -0.0009
    0.0948
   -0.0074
   -0.0088
   -0.0505
    0.0663
    0.0241
   -0.0150
    0.0902];

figure(1)
subplot(2,2,2);
plot(tRange, firstProb(tRange), '-sk');
hold all
plot(tRange, lastProb(tRange), '-*k');
hold all
plot(tRange, midProb(tRange), '-^k');
xlabel('List Length');
ylabel('First Recall Probability');
legend('First','Last 4','Medial','Location','East');

subplot(2,2,3)
plot(2:15, crp1(2:end),'-ok');
xlabel('List Length');
ylabel('Lag-CRP(1)');
xlim([0 16]);
ylim([0 1]);

subplot(2,2,4)
plot(pmTC, '-sk')
hold all
plot(smTC, '-*k')
xlabel('List Length');
ylabel('Memory Estimate');
xlim([0 16]);
ylim([0 4.5]);
legend('PM', 'SM');

figure(22)
subplot(1,3,1)%----------------
plot(dataIO, '-ok');
xlabel('List length');
ylabel('Mean correlation');

hold all
plot(dataIOFRcor, '-sk');
zerocorr = zeros(size(allIO));
plot(zerocorr, '--k');
corr5 = repmat(.5, size(zerocorr));
plot(corr5, ':k');

xlim([1.1 15.9])
ylim([-0.25 1]);

legend('IO','IO-FR corr');

subplot(1,3,2)%--------------
plot(dataIO1, '-ok');
xlabel('List length');
ylabel('Mean correlation');

hold all
plot(dataIOFRcor1, '-sk');
zerocorr = zeros(size(allIO));
plot(zerocorr, '--k');
corr5 = repmat(.5, size(zerocorr));
plot(corr5, ':k');
xlim([1.1 15.9])
ylim([-0.25 1]);

legend('IO1','IO1-FR corr');


subplot(1,3,3)%--------------
plot(allIO1, '-ok');
xlabel('List length');
ylabel('Mean correlation');

hold all
plot(allIOFRcor1, '-sk');
zerocorr = zeros(size(allIO));
plot(zerocorr, '--k');
corr5 = repmat(.5, size(zerocorr));
plot(corr5, ':k');
xlim([1.1 15.9])
ylim([-0.25 1]);

legend('IO1','IO1-FR corr');

% figure(1)
% prettySPC('../paper/final/Ward10Model.eps', [900 500])
% delete('../paper/final/Ward10Model*.pdf')
% 
% figure(22)
% prettySPC('../paper/final/IOFRcor.eps', [900 300])
% delete('../paper/final/IOFRcor*.pdf')
