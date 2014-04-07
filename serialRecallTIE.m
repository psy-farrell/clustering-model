indDurs = [.1 .3 .5];

G.ll=8;
G.retention='immed';

G.dursScale = .4;

G.endDur = .5;
G.lastProb = 0;

G.vSize = 0;
G.intruderAct = .0;

G.recTime = 1000;
G.prevLL = [8 8 8 8 8];
G.openSet = 0;

G.totOmmT = 1000;

pch = 'so^';

tcount=1;

for task = {'serialG','serialG','serialG'}
    
    G.G = 'tGroupStruct =repmat(4,G.ll,1)'';';
    G.Ge = 'endSize = 4;';
    G.task = char(task);
    
    durs = repmat(.5, G.nruns, G.ll);
    durs(:,5) = indDurs(tcount);

    model(G.x);
    
    s = scoringSerial(G.ll, repmat(1:G.ll,G.nruns,1), allRes)
   
    subplot(1,2,2)
    plot(s.inCor,['-' pch(tcount) 'k']);
    hold all
    xlabel('Serial Position');
    ylabel('Proportion Correct');
    xlim([0.5 8.5]);
    ylim([0 1]);
    title('Model');
    
    tcount=tcount+1;
end

%---Data
data = [    0.9150    0.9217    0.9350
    0.8600    0.8775    0.8867
    0.8358    0.8592    0.8725
    0.8783    0.9092    0.9333
    0.8508    0.8675    0.8717
    0.7392    0.7758    0.7933
    0.7400    0.7792    0.7808
    0.9542    0.9567    0.9517];
subplot(1,2,1)
for tcount=1:3
    plot(data(:,tcount),['-' pch(tcount) 'k']);
    hold all
end
xlabel('Serial Position');
ylabel('Proportion Correct');
xlim([0.5 8.5]);
ylim([0 1])
title('Data');
legend('0.1 s','0.3 s','0.5 s','Location','SouthWest');

% figure(1)
% prettySPC('../paper/final/serialRecallTIE.eps', [500 300])
% delete('../paper/final/serialRecallTIE*.pdf')
