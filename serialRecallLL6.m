G.ll=6;
G.retention='immed';

G.lastProb = 0;
tLL = G.ll;

G.vSize = 6;
G.intruderAct = .126; %.126;

G.recTime = 1000; % mimics having no time limit on recall

G.prevLL = [6 6 6 6 6];

G.openSet = 1; % open set--stimuli are different on each trial

durs = repmat(.5, G.nruns, G.ll);
G.endDur = .5;

G.dursScale = .5;

tcount=1;

for task = {'serialUG'}

    % A single group
    G.G = 'tGroupStruct = tLL;'; % this line actually has no effect in model.m
    G.Ge = 'endSize = tLL;';
    
    G.task = char(task);
    model(G.x);
    s = scoringSerial(G.ll, repmat(1:G.ll,G.nruns,1), allRes);
    
    figure(2)
    subplot(1,2,1)
    
    plot(s.inCor,'-ok');
    hold all
    xlabel('Serial Position');
    ylabel('Proportion Responses');
    xlim([0.5 6.5])
    ylim([0 1])

    plot(s.outInt, '--*k');
    hold all
    
    legend('Correct','Intrusions');
    
    figure(2)
    subplot(1,2,2)
    x = s.transmatP;
    plotsymb = 'o*s+dx^';
    for i=1:6
        plot(1:6,x(:,i), ['-' plotsymb(i) 'k']);
        %plot(1:6,x(:,i), ['-o'], 'Color', );
        %text(i,1, num2str(i));
        hold all
    end
%     bar(x, 'k');
    xlabel('Input Position');
    ylabel('Proportion Transpositions');
    xlim([0.5 6.5])
    ylim([0 1.09]);
    
    tcount=tcount+1;
end

%--plot the data
figure(1)
subplot(1,2,1)
x = [    0.9294;
    0.8338;
    0.8132;
    0.6647;
    0.6132;
    0.6912];
plot(1:6,x, '-ok');
hold all
xlabel('Serial Position');
ylabel('Proportion Responses');
xlim([0.5 6.5])
ylim([0 1]);


x = [    0.0206;
    0.0338;
    0.0500;
    0.1044;
    0.1721;
    0.1706];
plot(1:6,x, '--*k');
legend('Correct','Intrusions');

figure(1)
subplot(1,2,2)
x =[    0.9509    0.0261    0.0142    0.0151    0.0247    0.0199;
    0.0246    0.8609    0.0418    0.0227    0.0308    0.0239;
    0.0107    0.0436    0.8552    0.0440    0.0325    0.0220;
    0.0092    0.0445    0.0565    0.7403    0.0993    0.0276;
    0.0015    0.0158    0.0231    0.1219    0.7315    0.0781;
    0.0030    0.0091    0.0093    0.0560    0.0812    0.8286]';
plotsymb = 'o*s+dx^';
for i=1:6
    plot(1:6,x(:,i), ['-' plotsymb(i) 'k']);
    hold all
end
xlabel('Input Position');
ylabel('Proportion Transpositions');
xlim([0.5 6.5])
ylim([0 1.09]);

% figure(1)
% prettySPC('../paper/final/SRLL6data.eps', [800 300])
% delete('../paper/final/SRLL6data*.pdf');
% figure(2)
% prettySPC('../paper/final/SRLL6model.eps', [800 300])
% delete('../paper/final/SRLL6model*.pdf');