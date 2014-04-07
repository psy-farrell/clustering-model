G.vSize = 30;
G.intruderAct = .002;

G.openSet = 1;
G.prevLL = [];
G.lldist = 3; % effective number of distractors per period of distraction
G.nRuns = 5000;

G.firstCue=.1;

G.ll=12;
G.recTime = 60;

durs = repmat(.75, G.nruns, G.ll);
G.endDur = .75;

G.dursScale = .3;

G.totOmmT = 7;

plotSym = 'os*';

tcount=1;
for task = {'free','free','free'}
    
    G.task = char(task);
    
    G.G = 'tGroupStruct = randsample(6,tLL,true,[10 4 2 1 1 1])'';';
    G.Ge = 'endSize = randsample(6,1,true,[10 4 2 1 1 1])'';';
    
    if tcount==1
        G.retention='immed';
        G.lastProb = .9;
    elseif tcount==2
        G.retention='delay';
        G.lastProb = 0;
    elseif tcount==3
        G.retention='CD';
        G.lastProb = 0;
        G.controlPhi=.97;
    end
    
    model(G.x);
    
    figure(1)
    subplot(1,3,2);
    plot(score.frp, ['-' plotSym(tcount) 'k']);
    title('FRP')
    hold all
    xlim([0.5 12.5])
    xlabel('Serial Position');
    ylabel('Probability First Recall');
    title('FRP');
    
    subplot(1,3,1);
    
    plot(score.freeAcc, ['-' plotSym(tcount) 'k']);
    title('Accuracy Free');
    hold all
    xlim([0.5 12.5])
    ylim([0 1])
    xlabel('Serial Position');
    ylabel('Proportion Correct');
    title('SPC');
    legend('Immed','Delay','CD','Location','NorthWest');
    
    
    subplot(1,3,3);
    plot(score.alag, score.crp, ['-' plotSym(tcount) 'k']);
    hold all
    %ylim([0 1]);
    xlabel('Lag');
    ylabel('Recall Probability');
    title('lag-CRP');
    xlim([-6.5 6.5])
    ylim([0 .6])
    
    tcount=tcount+1;
end

%% Data
dataFRP{1} = [ 0.0499
    0.0073
    0.0044
    0.0142
    0.0056
    0.0209
    0.0167
    0.0221
    0.0462
    0.1231
    0.2049
    0.4849];
dataFRP{2} = [     0.1632
    0.0489
    0.0350
    0.0208
    0.0266
    0.0443
    0.0338
    0.0636
    0.0851
    0.1356
    0.1615
    0.1817];
dataFRP{3} = [0.0853
    0.0659
    0.0610
    0.0445
    0.0345
    0.0624
    0.0477
    0.0592
    0.0641
    0.1085
    0.1644
    0.2025];
dataFRP{4} = [0.0911
    0.0196
    0.0180
    0.0175
    0.0334
    0.0218
    0.0330
    0.0455
    0.0545
    0.1031
    0.1377
    0.4249];

dataSPC{1} = [     0.2529
    0.1936
    0.1804
    0.1880
    0.1759
    0.2255
    0.1834
    0.2560
    0.3637
    0.5990
    0.8223
    0.9243];
dataSPC{2} = [0.2759
    0.2173
    0.1732
    0.1257
    0.1545
    0.1807
    0.1700
    0.1868
    0.2458
    0.3192
    0.3833
    0.4217];
dataSPC{3} = [    0.3983
    0.4163
    0.3759
    0.3582
    0.3351
    0.3646
    0.3792
    0.3754
    0.4280
    0.4641
    0.5688
    0.5994];
dataSPC{4} = [0.2262
    0.2404
    0.2241
    0.2270
    0.2372
    0.2347
    0.2633
    0.2974
    0.3273
    0.3728
    0.4724
    0.6990];

dataCRP{1} = [     0.0686
    0.0442
    0.0355
    0.0309
    0.0296
    0.0376
    0.0451
    0.0529
    0.0780
    0.1239
    0.2757
    NaN
    0.4934
    0.1558
    0.1161
    0.1078
    0.0751
    0.0317
    0.0936
    0.1593
    0.1153
    0.1387
    0.1562];
dataCRP{2} = [    0.0670
    0.0905
    0.0779
    0.0765
    0.0422
    0.0500
    0.0637
    0.0504
    0.0831
    0.0841
    0.1207
    NaN
    0.3411
    0.1299
    0.1242
    0.0963
    0.0639
    0.0786
    0.0621
    0.0897
    0.0759
    0.0719
    0.0917];
dataCRP{3} = [0.0934
    0.0911
    0.1004
    0.0904
    0.0769
    0.0875
    0.0822
    0.0779
    0.0988
    0.1021
    0.1285
    NaN
    0.2029
    0.1341
    0.1023
    0.0981
    0.1074
    0.0922
    0.1186
    0.1164
    0.0915
    0.1519
    0.1625];
dataCRP{4} = [    0.0615
    0.0417
    0.0628
    0.0595
    0.0591
    0.0626
    0.0702
    0.1047
    0.0879
    0.1082
    0.1657
    NaN
    0.2401
    0.1310
    0.0976
    0.1166
    0.1078
    0.1225
    0.0776
    0.0736
    0.1518
    0.1584
    0.2914];

%% plot the data
plotSym = 'osd*';
alag{1} = -11:11;
alag{2} = alag{1};
alag{3} = alag{1};
alag{4} = alag{1};

figure(5)
subplot(2,3,1)
for i=1:2
    plot(dataSPC{i},['-' plotSym(i) 'k']);
    hold all
end
xlim([0.5 12.5])
ylim([0 1])
xlabel('Serial Position');
ylabel('Proportion Correct');
title('SPC');
legend('immed','delay','Location','NorthWest');

subplot(2,3,4)
for i=3:4
    plot(dataSPC{i},['-' plotSym(i) 'k']);
    hold all
end
xlim([0.5 12.5])
ylim([0 1])
xlabel('Serial Position');
ylabel('Proportion Correct');
legend('noIPI','long IPI','Location','NorthWest');


subplot(2,3,2)
for i=1:2
    plot(dataFRP{i},['-' plotSym(i) 'k']);
    hold all
end
xlim([0.5 12.5])
xlabel('Serial Position');
ylabel('Probability First Recall');
title('FRP');

subplot(2,3,5)
for i=3:4
    plot(dataFRP{i},['-' plotSym(i) 'k']);
    hold all
end
xlim([0.5 12.5])
xlabel('Serial Position');
ylabel('Probability First Recall');


subplot(2,3,3)
for i=1:2
    size(alag{i})
    size(dataCRP{i})
    plot(alag{i},dataCRP{i},['-' plotSym(i) 'k']);
    hold all
end
xlim([-12.5 12.5])
xlabel('Lag');
ylabel('Recall Probability');
title('lag-CRP');
xlim([-6.5 6.5])
ylim([0 .6])

subplot(2,3,6)
for i=3:4
    plot(alag{i},dataCRP{i},['-' plotSym(i) 'k']);
    hold all
end
xlim([-12.5 12.5])
xlabel('Lag');
ylabel('Recall Probability');
xlim([-6.5 6.5])
ylim([0 .6])


% figure(5)
% prettySPC('../paper/final/delayData.eps', [900 500])
% delete('../paper/final/delayData*.pdf')
% 
% figure(1)
% prettySPC('../paper/final/delayModel.eps', [900 250])
% delete('../paper/final/delayModel*.pdf')

