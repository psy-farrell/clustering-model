G.ll=17;

G.prevLL = [17 17 17 17 17];

G.vSize = 30;
G.intruderAct = .002;
G.openSet = 1; % are prev lists permutations of items from current list?

G.recTime = 30;

G.nruns = 5000; %run many sims to get reliable slopes on time function

G.lastProb = .9;
G.firstCue = .2;

G.totOmmT = 4; 

tcount=1;

G.retention = 'immed';

G.dursScale = .3;

for task = {'free'} %this "loop" is here for historical reasons
    
    G.task = char(task);
    
    G.G = 'tGroupStruct = randsample(5,G.ll,true,[6 4 2 1 1])'';';
    G.Ge = 'endSize = randsample(5,1,true,[6 4 2 1 1])'';';

    rand('twister',12413); %#ok<RAND>
    randn('state',12413); %#ok<RAND>
    
    durs = zeros(G.nruns, G.ll);
    for i=1:G.nruns
        kk = [0:7 0:7]/2;
        durs(i,:) = [2 kk(randperm(G.ll-1))];
    end
    G.endDur = 1;
    

    
    model(G.x);
    
    figure(11)
    subplot(1,3,1);
    plot(score.freeAcc, '-ok');
    xlabel('Serial Position');
    ylabel('Proportion Correct');
    ylim([0 1]);
    
    for i=1:G.ll
        acc(:,i) = any(allRes==i,2);
    end
    
    %--pre
    %drange = [5 9];
    drange = [4 6 8 10 12];
    tdurs = durs(:,drange);
    tacc = acc(:,drange);
    
    figure(11)
    dspace = (0:7)./2;
    for i=1:length(dspace);
        accPre(i) = mean(mean(tacc(tdurs==dspace(i))));
    end
    subplot(1,3,2)
    plot(dspace,accPre, '-ok');
    xlim([-0.5 4]);
    ylim([0 .35]);
    xlabel('Preceding Duration (s)');
    ylabel('Proportion Correct');
    
    %--post
    drange = [4 6 8 10 12];
    tdurs = durs(:,drange);
    tacc = acc(:,drange-1);
    
    figure(11)
    dspace = (0:7)./2;
    for i=1:(length(dspace));
        accPost(i) = mean(mean(tacc(tdurs==dspace(i))));
    end
    subplot(1,3,3)
    plot(dspace,accPost, '-ok'); 
    ylim([0 .35]);
    xlim([-0.5 4]);
    xlabel('Following Duration (s)');
    ylabel('Proportion Correct');
    
    tcount=tcount+1;
end

%% data
dataSPC = [0.44
0.33
0.31
0.2867
0.2367
0.2867
0.3267
0.26
0.2567
0.2867
0.2567
0.3
0.3233
0.3367
0.5567
0.85
0.98];

dataPre = [0.1741
0.1908
0.2126
0.287
0.1976
0.2311
0.2559
0.2811];

dataPost = [0.1562
0.191
0.2269
0.2723
0.2302
0.2417
0.2455
0.2644];

dataGaps = [0
0.5
1
1.5
2
2.5
3
3.5];

figure(1)
subplot(1,3,1)
plot(dataSPC, '-ok');
xlabel('Serial Position');
ylabel('Proportion Correct');
ylim([0 1]);

figure(1)
subplot(1,3,2)
plot(dataGaps,dataPre, '-ok')
xlabel('Preceding Duration (s)');
ylabel('Proportion Correct');
xlim([-0.5 3.99]);
ylim([0 .35]);

figure(1)
subplot(1,3,3)
plot(dataGaps,dataPost, '-ok')
xlabel('Following Duration (s)');
ylabel('Proportion Correct');
xlim([-0.5 3.99]);
ylim([0 .35]);


% figure(1)
% prettySPC('../paper/final/freeRecallTIEData.eps', [900 300])
% figure(11)
% prettySPC('../paper/final/freeRecallTIEModel.eps', [900 300])
% 
% delete('../paper/final/freeRecallTIEData*.pdf')
% delete('../paper/final/freeRecallTIEModel*.pdf')