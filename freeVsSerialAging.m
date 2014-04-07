G.ll=10;

G.nruns = 5000;

G.vSize = 30;
G.intruderAct = .002;
G.openSet = 1;

G.retention='immed';
G.usePos = 1;
        
G.prevLL = [10 10 10 10 10];

G.looseSerial = 1; % loose scoring of serial recall as in Golomb paper

G.totOmmT = 10;

G.recTime = 100;

G.iRT = 1.5;

durs = repmat(.8, G.nruns, G.ll);
G.endDur = .8;

G.dursScale = .3;

plotSym = 'o^oo';

tcount=1;

for task = {'free','serialG','free','serialG'}
    
    G.task = char(task);
        
        G.G = 'tGroupStruct = randsample(5,G.ll,true,[6 4 2 1 1])'';';
        G.Ge = 'endSize = randsample(5,1,true,[6 4 2 1 1])'';';
    
    if mod(tcount,2)%-----------% free recall
        G.lastProb = .7; 
        G.firstCue = 0.25; 
        G.onlyLastProb = .3; 
        condlab = 'Free';
    else %----------------------% serial recall
        G.lastProb = 0;
        G.firstCue = 0;
        G.onlyLastProb = .3;%.3
        condlab = 'Serial';
    end
    
    if tcount<3 %----------young
        G.controlPhi = .35;
        age = 'Younger';
    else %------------------old
        G.controlPhi = .5;
        age = 'Older';
    end
    
    model(G.x);
    
    if strcmp(G.task, 'free')
        figure(7)
        subplot(3,2,1)
        plot(score.freeAcc, ['-' plotSym(1+(tcount>2)) 'k']);
        title([condlab ' SPC']);
        hold all
        xlim([0.5 10.5])
        ylim([0 1])
        xlabel('Serial Position');
        ylabel('Proportion Correct');
        legend('Younger','Older','Location','NorthWest');
    end
    
    figure(7)
    subplot(3,2,3+mod(tcount+1,2));
    plot(score.frp, ['-' plotSym(1+(tcount>2)) 'k']);
    title([condlab ' FRP'])
    hold all
    xlim([0.5 10.5])
    ylim([0 1]);
    xlabel('Serial Position');
    ylabel('Probability First Recall');
    
    
    if strcmp(G.task, 'serialG')
        figure(7)
        subplot(3,2,2)
        plot(score.golomb, ['-' plotSym(1+(tcount>2)) 'k']);
        title([condlab ' SPC']);
        hold all
        xlim([0.5 10.5])
        ylim([0 1])
        xlabel('Serial Position');
        ylabel('Proportion Correct');
    end
    
    figure(7)
    subplot(3,2,5+mod(tcount+1,2));
    alag{tcount} = score.alag;
    plot(score.alag, score.crp,  ['-' plotSym(1+(tcount>2)) 'k']);
    hold all
    xlim([-9.5 9.5])
    xlabel('Lag');
    ylabel('Recall Probability');
    title([condlab ' Lag-CRP']);
    ylim([0 0.75]);
    
    tcount=tcount+1;
end

%% data
% ordering of conditions is young free, young serial, old free, old
% serial
dataFRP{1} = [     0.1214
    0.0153
    0.0099
    0.0218
    0.0381
    0.0441
    0.0621
    0.1283
    0.2231
    0.3360];
dataFRP{2} = [     0.5462
    0.0673
    0.0413
    0.0699
    0.0695
    0.0529
    0.0813
    0.0434
    0.0259
    0.0023];
dataFRP{3} = [    0.0880
    0.0097
    0.0104
    0.0406
    0.0520
    0.0705
    0.0731
    0.1246
    0.2026
    0.3286];
dataFRP{4} = [    0.5044
    0.0458
    0.0337
    0.0333
    0.0516
    0.0625
    0.0641
    0.0580
    0.0537
    0.0931];

dataSPC{1} = [    0.3845
    0.3218
    0.3083
    0.3197
    0.3289
    0.3803
    0.4966
    0.6589
    0.8142
    0.8975];
dataSPC{2} = [    0.5301
    0.4329
    0.3796
    0.3264
    0.3125
    0.3218
    0.4051
    0.4838
    0.5463
    0.6435];
dataSPC{3} = [     0.3426
    0.2546
    0.1829
    0.2454
    0.2407
    0.3287
    0.4097
    0.5440
    0.7731
    0.8657];
dataSPC{4} = [     0.5532
    0.3264
    0.2037
    0.1736
    0.2060
    0.2616
    0.3125
    0.3912
    0.5556
    0.6968];

dataGol{1} = [    0.1111
    0.1620
    0.1204
    0.1343
    0.1366
    0.2016
    0.2479
    0.3822
    0.5284
    0.8510];
dataGol{2} = [    0.4954
    0.3519
    0.2824
    0.2431
    0.2407
    0.2407
    0.3102
    0.3611
    0.4606
    0.5648];
dataGol{3} = [    0.0787
    0.1042
    0.0625
    0.0926
    0.1157
    0.1551
    0.2083
    0.3241
    0.4838
    0.8125];
dataGol{4} = [     0.4537
    0.2546
    0.1343
    0.0972
    0.1343
    0.1481
    0.1736
    0.2569
    0.3681
    0.6134];

dataGolno1{1} = [         NaN
    0.4448
    0.2784
    0.3830
    0.3688
    0.4305
    0.4255
    0.4954
    0.5408
    0.9100];
dataGolno1{2} = [       NaN
    0.7421
    0.6431
    0.5846
    0.6870
    0.7184
    0.7538
    0.7355
    0.8253
    0.8547];
dataGolno1{3} = [        NaN
    0.3479
    0.3194
    0.2586
    0.3451
    0.3385
    0.4086
    0.4867
    0.4996
    0.9281];
dataGolno1{4} = [         NaN
    0.6444
    0.5089
    0.4552
    0.5126
    0.4282
    0.4700
    0.5773
    0.6492
    0.8590];


dataCRP{1} = [     0.1010
    0.0572
    0.0615
    0.0457
    0.0472
    0.0557
    0.0802
    0.1199
    0.2524
       NaN
    0.5728
    0.1614
    0.1130
    0.0526
    0.1666
    0.1209
    0.1209
    0.1050
    0.1259];
dataCRP{2} = [     0.1000
    0.0224
    0.0397
    0.0300
    0.0355
    0.0367
    0.0380
    0.0598
    0.1328
       NaN
    0.5384
    0.1737
    0.0996
    0.0891
    0.0845
    0.0890
    0.0878
    0.0303
    0.0255];
dataCRP{3} = [     0.1483
    0.0461
    0.0544
    0.0409
    0.0579
    0.0496
    0.0832
    0.1002
    0.2181
       NaN
    0.5254
    0.1993
    0.1135
    0.1100
    0.1605
    0.0830
    0.0445
    0.0833
    0.2426];
dataCRP{4} = [     0.1635
    0.0699
    0.0406
    0.0466
    0.0393
    0.0531
    0.0719
    0.0671
    0.1414
       NaN
    0.4304
    0.1814
    0.1098
    0.1154
    0.1142
    0.1092
    0.1316
    0.1152
    0.0799];
 
figure(6) %-------PLOT ALL DATA
subplot(3,2,1)
plot(dataSPC{1}, ['-' plotSym(1) 'k']);
title(['Free SPC']);
hold all
plot(dataSPC{3}, ['-' plotSym(2) 'k']);
xlim([0.5 10.5])
ylim([0 1])
xlabel('Serial Position');
ylabel('Proportion Correct');
legend('Younger','Older','Location','NorthWest');

subplot(3,2,2)
plot(dataGol{2}, ['-' plotSym(1) 'k']);
title(['Serial SPC']);
hold all
plot(dataGol{4}, ['-' plotSym(2) 'k']);
xlim([0.5 10.5])
ylim([0 1])
xlabel('Serial Position');
ylabel('Proportion Correct');

subplot(3,2,3)
plot(dataFRP{1}, ['-' plotSym(1) 'k']);
title(['Free FRP']);
hold all
plot(dataFRP{3}, ['-' plotSym(2) 'k']);
xlim([0.5 10.5])
ylim([0 1])
xlabel('Serial Position');
ylabel('Probability First Recall');
%legend('Younger','Older','Location','NorthWest');


subplot(3,2,4)
plot(dataFRP{2}, ['-' plotSym(1) 'k']);
title('Serial FRP');
hold all
plot(dataFRP{4}, ['-' plotSym(2) 'k']);
xlim([0.5 10.5])
ylim([0 1])
xlabel('Serial Position');
ylabel('Probability First Recall');

subplot(3,2,5)
alag{tcount} = score.alag;
plot(score.alag, dataCRP{1},  ['-' plotSym(1) 'k']);
hold all
plot(score.alag, dataCRP{3},  ['-' plotSym(2) 'k']);
xlim([-9.5 9.5])
xlabel('Lag');
ylabel('Recall Probability');
title(['Free Lag-CRP']);
ylim([0 0.75]);

subplot(3,2,6)
alag{tcount} = score.alag;
plot(score.alag, dataCRP{2},  ['-' plotSym(1) 'k']);
hold all
plot(score.alag, dataCRP{4},  ['-' plotSym(2) 'k']);
xlim([-9.5 9.5])
xlabel('Lag');
ylabel('Recall Probability');
title(['Serial Lag-CRP']);
ylim([0 0.75]);

% --USE THESE ONES
% figure(6)
% prettySPC('../paper/final/GolombData.eps', [500 1000])
% figure(7)
% prettySPC('../paper/final/GolombModel.eps', [500 1000])
% 
% delete('../paper/final/GolombData*.pdf')
% delete('../paper/final/GolombModel*.pdf')