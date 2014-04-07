G.ll = 15;

G.prevLL = [15 15 15 15 15];

G.retention = 'immed';


G.vSize = 30;
G.intruderAct = .002;
G.openSet = 1; % are prev lists permutations of items from current list?

G.firstCue=1;
G.lastProb = .9;

G.iRT = 1.5;

G.recTime = 90;

G.totOmmT = 7;

durs = repmat(1, G.nruns, G.ll); %#ok<RPMT1>
G.endDur = 1;

G.dursScale = .3;

plotSym = 'so^';
plotCol = [0 0 0; .3 .3 .3; .6 .6 .6];
tcount=1;

G.aboveTheLine = 1; % set this to one to examine performance "above the line"

for task = {'free','free','free','free'}
    G.task = char(task);
    
    G.G = 'tGroupStruct = randsample(6,G.ll,true,[5 4 6 5 2 1])'';';
    G.Ge = 'endSize = randsample(6,1,true,[5 4 6 5 2 1])'';';
        
    G.dalCue = tcount;
    if tcount<4
        G.Dalezman = 1;
    else
        G.Dalezman = 0;
    end
     
    model(G.x);


    eval([G.task ' = score']);
    
    pred = filter(ones(1,3)/3,1,score.freeAcc); % averaging a la Dalezman
    pred = [score.freeAcc(1) pred(3:end) score.freeAcc(end)];
    
    figure(3);
    subplot(1,2,2)
    if tcount<4
        plot(pred,['-' plotSym(tcount)],'Color', plotCol(tcount,:));
        hold all
    elseif ~G.aboveTheLine
            plot(pred, '--k');
    end
    modelAcc(tcount) = mean(pred);
    xlim([0.1 15.9])
    ylim([0 1]);
    xlabel('Serial position');
    ylabel('Proportion recalled');
    title('Model');
    tcount=tcount+1;

end

if G.aboveTheLine
    dataSPC = [0.78	0.09	0.04
        0.59	0.08	0.03
        0.45	0.12	0.03
        0.32	0.17	0.04
        0.25	0.23	0.05
        0.16	0.24	0.06
        0.12	0.26	0.08
        0.07	0.3	0.1
        0.07	0.34	0.16
        0.04	0.34	0.2
        0.06	0.32	0.26
        0.05	0.28	0.34
        0.05	0.28	0.45
        0.04	0.22	0.61
        0.05	0.16	0.82];
    
    figure(3)
    subplot(1,2,1)
    for i=1:3
        plot(dataSPC(:,i),['-' plotSym(i)],'Color', plotCol(i,:));
        hold all
    end
    xlim([0.1 15.9])
    ylim([0 1]);
    legend('begin','middle','end','Location','North');
    xlabel('Serial position');
    ylabel('Proportion recalled');
    title('Data');
    
%     figure(3)
%     prettySPC('../paper/final/DalezmanATL.eps', [500 300])
%     delete('../paper/final/DalezmanATL*.pdf')
else
    dataSPC = [0.81	0.72	0.7	0.75
        0.65	0.59	0.56	0.57
        0.49	0.5	0.44	0.44
        0.4	0.4	0.37	0.38
        0.34	0.37	0.34	0.36
        0.31	0.33	0.31	0.32
        0.3	0.36	0.28	0.32
        0.28	0.39	0.31	0.32
        0.3	0.46	0.35	0.34
        0.3	0.46	0.39	0.36
        0.31	0.44	0.42	0.37
        0.33	0.38	0.46	0.41
        0.36	0.37	0.55	0.46
        0.37	0.33	0.67	0.6
        0.36	0.28	0.83	0.79];
    
    figure(3)
    subplot(1,2,1)
    for i=1:3
        plot(dataSPC(:,i),['-' plotSym(i)],'Color', plotCol(i,:));
        hold all
    end
    xlim([0.1 15.9])
    ylim([0 1]);
    plot(dataSPC(:,4), '--k');
    legend('begin','middle','end','free','Location','North');
    xlabel('Serial position');
    ylabel('Proportion recalled');
    title('Data');
    
%     figure(3)
%     prettySPC('../paper/final/Dalezman.eps', [500 300])
%     delete('../paper/final/Dalezman*.pdf')
end


