global allRTs

G.ll=9;

tLL = G.ll;
G.retention='immed';

G.prevLL = [9 9 9 9 9];
G.lastProb = 0;

G.recTime = 1000; % mimics having no time limit on recall

G.openSet = 0; % closed set (digits)

G.totOmmT = 5;

durs = repmat(.5, G.nruns, G.ll);
G.endDur = .5;

G.dursScale = .5;

tcount=1;

for task = {'serialUG','serialG','serialG'}
    
    %serialUG automatically just makes a single group
    if tcount==1 || tcount==2
        durs = repmat(.6, G.nruns, G.ll);
        G.endDur = .6;
    else
        durs = repmat(.45, G.nruns, G.ll);
        durs(:,4) = .9;
        durs(:,7) = .9;
        G.endDur = .9;
    end
    if tcount==2
        G.G = 'tGroupStruct = randsample(9,tLL,true,[0 1 1 1 1 0 0 0 1])'';';
        G.Ge = 'endSize = randsample(9,1,true,[0 1 1 1 1 0 0 0 1])'';';
    else
        G.G = 'tGroupStruct =repmat(3,tLL,1)'';';
        G.Ge = 'endSize = 3;';
    end
    G.task = char(task);
    model(G.x);
    
    s = scoringSerial(G.ll, repmat(1:G.ll,G.nruns,1), allRes);
    
    if tcount==2
        transBW(1:3) = s.transgradP(1:3);
    elseif tcount==3
        transBW(4:6) = s.transgradP(1:3);
        transBW(7:9) = transBW(4:6)./transBW(1:3);
    end
    
    figure(1)
    %subplot(1,2,1)
    
    if tcount==3
        eval(G.G);
        i=1;
        oldc = 1;
        counter = 0;
        while oldc<G.ll
            counter = counter+tGroupStruct(i);
            xrange = oldc:counter;
            plot(xrange, s.inCor(xrange),'-o','Color',[.5 .5 .5]);
            hold all
            oldc = counter+1;
            i=i+1;
        end
    else
        if tcount==1
            plot(s.inCor,'-ok');
        else
            plot(s.inCor,'-.ok');
        end
    end
    hold all
    xlabel('Serial Position');
    ylabel('Proportion Correct');
    xlim([0.5 9.5])
    ylim([0 1])
    legend('Ungrouped','Spontaneous','Grouped','Location','Best');
    legend('boxoff');
    set(gca,'XTick',1:9)
    
    %calculate proportion of interpositions followed by another one
    tempRes = allRes;
    tempRes(tempRes<1) = NaN;
    kk = tempRes - repmat(1:G.ll,G.nruns,1);
    interpos = (mod(kk,3)==0) & kk~=0; % times interposition was made
    interpos2 = (kk(:,1:(end-1))==kk(:,2:end)) & interpos(:,1:(end-1));
    
    interpos = interpos(:,1:(end-1));
    disp('interposition association ratio')
    disp(sum(interpos2(:))./sum(interpos(:)));
    
    latmatNA = allRTs;
    latmatNA((repmat(1:G.ll,G.nruns,1)==allRes)==0) = NaN;
    
    inLatCor = nanmean(latmatNA);
    
    figure(10)
    if tcount==2
        plot(inLatCor','-.ok')
    elseif tcount==3
        plot(inLatCor,'-o','Color',[.5 .5 .5]);
    end
    xlabel('Serial Position');
    ylabel('Proportion Correct');
    xlim([0.5 9.5])
    %ylim([0 5])
    hold all
    
    tcount=tcount+1;
end

%--plot the data
figure(2)

subplot(1,3,1)
x = [0.773	0.869
0.588	0.779
0.577	0.800
0.477	0.608
0.386	0.542
0.374	0.615
0.202	0.298
0.186	0.261
0.325	0.360];
plot(1:9,x(:,1), '-.ok');
hold all
plot(1:3,x(1:3,2), '-o','Color',[.5 .5 .5]);
plot(4:6,x(4:6,2), '-o','Color',[.5 .5 .5]);
plot(7:9,x(7:9,2), '-o','Color',[.5 .5 .5]);
xlabel('Serial Position');
ylabel('Proportion Correct');
xlim([0.5 9.5])
ylim([0 1]);
legend('Ungrouped','Grouped');
set(gca,'XTick',1:9)

figure(2);
subplot(1,3,2);
x = [0.384	0.227	0.130;
0.394	0.183	0.203;
0.610	0.230	0.110;
0.610	0.230	0.110;
0.610	0.230	0.110;
0.610	0.230	0.110;
0.615	0.307	0.179;
0.621	0.316	0.210];
plot(x','-', 'Color',[.7 .7 .7]);
hold all
plot(transBW(1:3), '-k');
title('Ungrouped');
xlim([.5 3.5])
ylim([0 0.7]);
    xlabel('Transposition Distance');
    ylabel('Proportion Transpositions');
set(gca,'XTick',1:3)

subplot(1,3,3);
x = [0.343	0.169	0.166;
0.288	0.138	0.318;
0.577	0.183	0.204;
0.515	0.195	0.223;
0.532	0.208	0.201;
0.558	0.088	0.319;
0.258	0.138	0.245;
0.236	0.147	0.261];
plot(x','-', 'Color',[.7 .7 .7]);
hold all
plot(transBW(4:6), '-k');
title('Grouped');
xlim([.5 3.5])
ylim([0 0.7]);
    xlabel('Transposition Distance');
    ylabel('Proportion Transpositions');
set(gca,'XTick',1:3)


% figure(1)
% prettySPC('../paper/final/SRmodel.eps', [300 300])
% figure(2)
% prettySPC('../paper/final/SRdata.eps', [900 300])
% figure(10)
% prettySPC('../paper/final/SRlat.eps', [400 300])
% 
% delete('../paper/final/SRmodel*.pdf')
% delete('../paper/final/SRdata*.pdf')
% delete('../paper/final/SRlat*.pdf')