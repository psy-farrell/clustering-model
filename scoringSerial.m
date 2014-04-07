function s = scoringSerial(ll, probe, resp)


% accuracy SPCs
correct= probe==resp;
%this converts to logical so we can set some to NaN
correct = correct*1;
correct(isnan(resp))=NaN;

s.outCor = nanmean(correct);

for i=1:ll
    s.inCor(i) = nanmean(correct(probe==i));
end

% intrusion SPC
resp(resp>ll) = -9;
isIntrusion = (resp==-9);
s.outInt = nanmean(isIntrusion);

% transposition gradients
% reorder recalls by input position
kk = size(probe);
rind = repmat((1:kk(1))',1,kk(2))';
pp =probe';
po = repmat(1:kk(2),kk(1),1)';
sind = sub2ind([kk(1) ll], rind(:), pp(:));
oind = sub2ind([kk(1) ll], rind(:), po(:));
respByIn = NaN(kk(1),ll);
respByIn(sind) = resp(oind);

%respByIn = reshape(respByIn,kk(1),ll);

% calculate transmat
for i=1:ll
    s.rmat(i,:) = hist(respByIn(~isnan(respByIn(:,i)),i), [-9, -1, 1:ll])';
end
s.rmat = s.rmat(:,[3:end 1 2]);
s.transmat = s.rmat(:,1:ll);

s.transmatP = s.transmat./repmat(sum(s.transmat,2),1,ll);

tdist = zeros(ll);
for rrow = 1:ll
    tdist(rrow,:) = rrow-(1:ll);
end

tmat = s.transmat;
tmat(tdist==0)=NaN;

chancemat = nansum(tmat,2);
chancemat = repmat(chancemat,1,ll)./(ll-1);
chancemat(tdist==0) = NaN;

s.transgrad = NaN(1,ll-1);
s.transchance = NaN(1,ll-1);

for i=1:(ll-1)
    s.transgrad(i) = sum(sum(s.transmat(abs(tdist)==i)));
    s.transchance(i) = sum(sum(chancemat(abs(tdist)==i)));
end

for i=(-ll+1):(ll-1)
    s.transgradFull(i+ll) = sum(sum(s.transmat(tdist==i)));
    s.transgradC(i+ll) = i;
end

s.transgradP = s.transgrad./sum(s.transgrad);
s.transgradR = s.transgrad./s.transchance;
s.transgradFull = s.transgradFull./sum(s.transgradFull);

% the statistics only look at incorrect responses (transposition errors)
s.transChi2 = chisq(s.transgrad,s.transchance);
s.transChi2df = ll-2;
s.transChi2p = 1 - chi2cdf(s.transChi2, s.transChi2df);
s.transChi2N = sum(s.transgrad);