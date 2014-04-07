G.vSize = 30;
G.intruderAct = .002;
G.openSet = 1;

G.nPrevLists = 5;
G.prevLL = repmat(20,1,G.nPrevLists);

G.nruns = 10000; %this needs to be uncommented--commented out to test

G.firstCue= .3; % alpha
G.lastProb = .9; % omega
plotSym = 'o^*';

G.iRT = 1.5;

G.totOmmT = 7;

G.ll=20;
G.recTime = 60;

G.retention='immed';

durs = repmat(.75, G.nruns, G.ll);
G.endDur = .75;

G.dursScale = .3;

tcount=1;

for task = {'free'} % for loop obviously serves no purpose--just here for historical reasons
    
    G.task = char(task);
    
    G.G = 'tGroupStruct = randsample(6,tLL,true,[5 4 6 5 2 1])'';';
    G.Ge = 'endSize = randsample(6,1,true,[5 4 6 5 2 1])'';';
    
    model(G.x);
    
    figure(2)
    subplot(1,3,2);
    plot(score.freeAcc, ['-' plotSym(tcount) 'k']);
    title('Accuracy');
    hold all
    xlim([0.5 20.5])
    ylim([0 1])
    xlabel('Serial Position');
    ylabel('Proportion Correct');
    
    figure(2)
    subplot(1,3,1);
    plot(score.frp, ['-' plotSym(tcount) 'k']);
    title('FRP')
    hold all
    xlim([0.5 20.5])
    ylim([0 0.4]);
    xlabel('Serial Position');
    ylabel('Probability First Recall');
    %legend('LL=10','LL=20','LL=30','LL=40');
    
    figure(2)
    subplot(1,3,3);
    alag{tcount} = score.alag;
    plot(score.alag, score.crp,  ['-' plotSym(tcount) 'k']);
    hold all
    xlim([-19.5 19.5])
    xlabel('Lag');
    ylabel('Recall Probability');
    title('Lag-CRP');
    ylim([0 0.6]);
    
    figure(4)
    subplot(1,2,1);
    OPs = {'-s','-o','-d','-+'};
    OPc = [0 0 0; .2 .2 .2; .4 .4 .4; .6 .6 .6];
    if tcount==1
        %row1 = score.crpOP(:,1);
        row2 = mean(score.crpOP(:,1:4),2);
        %row2 = score.crpOP(:,4);
        for i=1:4
            plot(score.alag, score.crpOP(:,i),OPs{i}, 'Color',OPc(i,:));
            %  plot(score.alag, row1,'-o');
            hold all
        end
        %plot(score.alag, row2,'-o');
        legend('1','2','3','4')
        ylim([0 1]);
        title('Lag-CRP by OP');
    end
    xlabel('Lag');
    ylabel('Conditional recall probability');
    
    eval([G.task ' = score']);
    
    figure(4)
    subplot(1,2,2)
    plot(free.condRec(1:8,end), '-k');
    title('Conditional recency');
    xlabel('Output position');
    ylabel('Conditional recall probability');
    ylim([0 0.5]);
    hold all
    
    sm(tcount)=free.sm4;
    pm(tcount)=free.pm4;
    
    figure(6)
    subplot(2,2,4)
    %plot(-(G.ll-1):(G.ll-1),log(free.crpRT((G.ll-4):(G.ll+4))+1));
    plot(-(G.ll-1):(G.ll-1),log(free.crpRT+1), '-k');
    xlabel('Lag')
    ylabel('Log recall time');
    title('Model (all lags)');
    %xlim([-4 4])
    ylim([0.5 2.5])
    
    subplot(2,2,3)
    %plot(-(G.ll-1):(G.ll-1),log(free.crpRT((G.ll-4):(G.ll+4))+1));
    plot(-(G.ll-1):(G.ll-1),log(free.crpRT+1), '-k');
    xlabel('Lag')
    ylabel('Log recall time');
    xlim([-4 4])
    ylim([0.5 2])
    title('Model');
    
    tcount=tcount+1;
end

%% data
dataFRP= [    0.0684
    0.0029
    0.0014
    0.0014
    0.0043
    0.0014
    0.0064
    0.0043
    0.0071
    0.0148
    0.0085
    0.0162
    0.0310
    0.0350
    0.0578
    0.0904
    0.1346
    0.1860
    0.1532
    0.1749];

dataSPC = [    0.4431
    0.2910
    0.2222
    0.1896
    0.1389
    0.1569
    0.1549
    0.1410
    0.1604
    0.1896
    0.1535
    0.1875
    0.2188
    0.2535
    0.2785
    0.3125
    0.3972
    0.5875
    0.6882
    0.7875];

dataCRP = [     0.1270
    0.0396
    0.0325
    0.0278
    0.0193
    0.0213
    0.0287
    0.0238
    0.0278
    0.0235
    0.0226
    0.0236
    0.0319
    0.0354
    0.0348
    0.0409
    0.0391
    0.0659
    0.1200
    NaN
    0.4257
    0.1199
    0.0708
    0.0491
    0.0531
    0.0475
    0.0419
    0.0461
    0.0392
    0.0407
    0.0388
    0.0420
    0.0284
    0.0321
    0.0401
    0.0282
    0.0348
    0.0861
    0.0231];

dataCRPop = [    0.0477    0.0755    0.1430    0.1674
    0.0029    0.0263    0.0442    0.1274
    0.0008    0.0213    0.0560    0.0507
    0.0033    0.0089    0.0446    0.0778
    0.0026    0.0060    0.0348    0.0504
    0.0059    0.0104    0.0276    0.0752
    0.0017    0.0199    0.0316    0.0770
    0.0022    0.0142    0.0281    0.0459
    0    0.0091    0.0317    0.0494
    0.0016    0.0207    0.0244    0.0352
    0.0036    0.0222    0.0189    0.0331
    0.0056    0.0148    0.0244    0.0414
    0.0031    0.0137    0.0502    0.0553
    0.0108    0.0288    0.0449    0.0545
    0.0123    0.0258    0.0331    0.0444
    0.0185    0.0389    0.0295    0.0536
    0.0170    0.0369    0.0375    0.0457
    0.0486    0.0553    0.0729    0.0817
    0.0974    0.1352    0.1352    0.1064
    NaN       NaN       NaN       NaN
    0.6936    0.5595    0.4144    0.2429
    0.1272    0.1765    0.1241    0.1122
    0.0715    0.1094    0.1248    0.0571
    0.0829    0.0570    0.0513    0.0363
    0.0565    0.1037    0.0717    0.0311
    0.0646    0.0252    0.0453    0.0334
    0.0419    0.0359    0.0305    0.0378
    0.0720    0.0502    0.0335    0.0413
    0.0686    0.0217    0.0587    0.0517
    0.0481    0.0886    0.0362    0.0458
    0.0250    0.0333    0.0218    0.0091
    0.0811    0.0256    0.1118    0.0390
    0.0098    0.0315         0    0.0651
    0.0379    0.0487    0.0284    0.0111
    0.0061    0.0519    0.0667    0.0471
    0.0298    0.0662    0.0233    0.0654
    0.0611    0.0693         0    0.0147
    0.0333    0.1262    0.1111    0.1522
    0.0230         0    0.1818         0];

dataCRPrt = [    3.2037
    5.2016
    2.8527
    4.8656
    4.5298
    3.6228
    5.5745
    5.4175
    5.2857
    6.2778
    4.3142
    5.6564
    4.3232
    4.2047
    4.1338
    4.6385
    4.2453
    2.7521
    2.3640
    NaN
    1.1465
    1.9360
    2.6830
    4.3670
    4.1262
    4.1469
    8.4804
    6.3237
    5.6364
    3.8816
    6.2172
    4.0031
    7.9408
    5.5363
    4.5571
    2.2562
    1.8693
    2.7581
    1.9325];

%% plot data
figure(1)
subplot(1,3,2)
plot(dataSPC,['-' plotSym(1) 'k']);
xlim([0.5 20.5])
ylim([0 1])
xlabel('Serial Position');
ylabel('Proportion Correct');
title('Accuracy');

figure(1)
subplot(1,3,1)
plot(dataFRP,['-' plotSym(1) 'k']);
hold all
xlim([0.5 20.5])
xlabel('Serial Position');
ylabel('Probability First Recall');
title('FRP');
ylim([0 0.4]);

figure(1)
subplot(1,3,3)
plot(alag{1},dataCRP,['-' plotSym(1) 'k']);
xlim([-19.5 19.5])
ylim([0 .6]);
xlabel('Lag');
ylabel('Recall Probability');
title('Lag-CRP');

figure(6)
subplot(2,2,2)
plot(-(G.ll-1):(G.ll-1),log(dataCRPrt+1),'-k');
xlabel('Lag')
ylabel('Log recall time');
title('Data (all lags)');
ylim([0.5 2.5])

subplot(2,2,1)
plot(-(G.ll-1):(G.ll-1),log(dataCRPrt+1),'-k');
xlabel('Lag')
ylabel('Log recall time');
title('Data');
xlim([-4 4]);
ylim([0.5 2])

figure(3)
subplot(1,2,1)

for i=1:4
    plot(score.alag, dataCRPop(:,i),OPs{i}, 'Color',OPc(i,:));
    %  plot(score.alag, row1,'-o');
    hold all
end
legend('1','2','3','4')
ylim([0 1]);
title('Lag-CRP by OP');
xlabel('Lag');
ylabel('Conditional recall probability');

subplot(1,2,2)
x = [0.1749    0.2451    0.3592    0.3856    0.1820    0.0949    0.0184    0.0513];
plot(x, '-k');
xlabel('Output position');
ylabel('Conditional recall probability');
title('Conditional recency');
ylim([0 0.5]);

figure(1)
prettySPC('../paper/final/mo70data.eps', [900 300])
figure(2)
prettySPC('../paper/final/mo70model.eps', [900 300])
figure(3)
prettySPC('../paper/final/acrossOPdata.eps', [600 300])
figure(4)
prettySPC('../paper/final/acrossOPmodel.eps', [600 300])
figure(6)
prettySPC('../paper/final/lagCRPrt.eps', [600 600])

% delete('../paper/final/mo70data*.pdf')
% delete('../paper/final/mo70model*.pdf')
% delete('../paper/final/acrossOPdata*.pdf')
% delete('../paper/final/acrossOPmodel*.pdf')
% delete('../paper/final/lagCRPrt*.pdf')