global durs
global score
global allRes
global allCumRTs

plotSym = 's*';

G.nruns = 10000;

G.vSize = 30;
G.intruderAct = .002;
G.openSet = 1;
G.prevLL = [18 18 18 18 18];

G.recTime = 60;
G.ll=18;

G.firstCue = .2;
G.lastProb = .9;

G.retention = 'immed';

G.iRT = 1.5;

G.totOmmT = 5;

G.dursScale = .3;

tcount=1;

for task = {'free','free'}
    
    
    G.task = char(task);
   
    if tcount==1

        G.G = 'tGroupStruct = randsample(6,tLL,true,[5 4 6 5 2 1])'';';
        G.Ge = 'endSize = randsample(6,1,true,[5 4 6 5 2 1])'';';
        tt = 14.5/18;
        durs = repmat(tt, G.nruns, G.ll);
        G.endDur = tt;
    else
        G.G = 'tGroupStruct =repmat(3,1,G.ll);';
        G.Ge = 'endSize = 3;';
        tt = 14.5/(18+6);
        durs = repmat(tt, G.nruns, G.ll);
        durs(:,[4 7 10 13 16])=tt*2;
        G.endDur = tt*2;
    end
    
    model(G.x);
    
    figure(1)
    subplot(1,3,2);
    plot(score.frp, ['-' plotSym(tcount) 'k']);
    title('FRP')
    xlabel('Serial Position');
    ylabel('Proportion Responses');
    hold all
    %ylim([0 1]);
    
    subplot(1,3,1);
    plot(score.freeAcc, ['-' plotSym(tcount) 'k']);
    title('Accuracy');
    xlabel('Serial Position');
    ylabel('Proportion Recalled');
    hold all
    ylim([0 1]);
    
    subplot(1,3,3)
    plot(score.condRec(1:8,end), ['-' plotSym(tcount) 'k']);
    title('Conditional Recency');
    xlabel('Output Position');
    ylabel('Conditional Recall Probability');
    hold all
    
    if tcount==2
        
        legitCumRT = allCumRTs(allRes>0 & allRes<=G.ll);
        
        for i=1:60 % look at first 60 s, as this is enough for most experiments
            cumRT(i) = sum(legitCumRT<i)*sum(score.freeAcc)/length(legitCumRT);
        end
        
        try
            expFitRes = expfit(legitCumRT); % this uses the stats toolbox
        catch
            expFitRes = NaN;
        end
        
        figure(26)
        xind = cumsum([1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2]);
        xes = 1:60;
        plot(xes(xind), cumRT(xind), '^k')
        hold all
        plot(expcdf(1:60,expFitRes).*sum(score.freeAcc), 'Color', [.7 .7 .7], 'LineWidth', 3);
        ylim([0 6]);
        xlim([0 40]);
        %legend('Model','Exp fit');
        xlabel('Time into recall (s)');
        ylabel('Mean cumulative recall');
    end
    
    tcount=tcount+1;
end

% figure(1)
% prettySPC('../paper/final/freeRecallGrouping.eps', [900 300])
% delete('../paper/final/freeRecallGrouping*.pdf')
% 
% figure(26)
% prettySPC('../paper/final/outRTgrouping.eps', [300 300])
% delete('../paper/final/outRTgrouping*.pdf')