global allProbe

G.ll = 9;

plotSym = 'so^';
plotCol = [0 0 0; .3 .3 .3; .6 .6 .6];

G.prevLL = [9 9 9 9 9];


G.ll=9;
G.retention='immed';

G.recTime = 1000;
G.openSet = 0; % closed set

G.lastProb = 1; % if we are cueing for last group, always carry over context

G.totOmmT = 5;

inrange{1} = 1:3;
inrange{2} = 4:6;
inrange{3} = 7:9;

durs = repmat(.45, G.nruns, G.ll);
durs(:,1) = .9;
durs(:,4) = .9;
durs(:,7) = .9;
G.endDur = .9;

G.dursScale = .15;

tcount=1;

for task = {'wrap','wrap','wrap'}
    
    G.task = char(task);
    G.G = 'tGroupStruct =repmat(3,3,1)'';';
    G.Ge = 'endSize = 3;';
    G.startG = tcount;
    
    model(G.x);

    if strcmp(task, 'wrap')
        s = scoringSerial(G.ll, allProbe, allRes);
    end
    
    figure(2)
    subplot(1,2,2)
    plot(s.outCor,['-' plotSym(tcount)],'Color', plotCol(tcount,:));
    hold all
    xlabel('Output Position');
    ylabel('Proportion Correct');
    ylim([0 1])

    tcount=tcount+1;
end
title('Model')

xlim([0.1 9.9])

%--
figure(2)
subplot(1,2,1);
x = [0.7492	0.7423	0.8883
0.6945	0.6876	0.8655
0.7287	0.7423	0.8883
0.5675	0.6129	0.6915
0.5535	0.5383	0.6416
0.609	0.595	0.6421
0.4017	0.5491	0.5177
0.3199	0.5056	0.482
0.4578	0.5624	0.5873];
for i=1:3
        plot(x(:,i),['-' plotSym(i)],'Color', plotCol(i,:));
        hold all
end
xlabel('Output Position');
ylabel('Proportion Correct');
ylim([0 1]);
title('Data')
legend('Begin','Middle','End','Location','SouthWest');
xlim([0.1 9.9])

% figure(2);
% prettySPC('../paper/final/wrapping.eps', [600 300])
% delete('../paper/final/wrapping*.pdf')