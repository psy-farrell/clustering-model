clear all; close all

global G
global durs
global score
global allRes

G.seed=15437;

G.nruns = 1000;

G.printOut = 0; % if set to 1, the model prints out what it is doing as the simulation is run
G.init = 1; % should rand be initialized inside model.m? If ==1, makes sure
    % running the model twice with the same parameters gives the same
    % results

%% settings
G.markers = @expscale; % this tells the model to use an exponential gradient
    % across markers (see Equations A1 and A12)

G.gNoise = 0.02; %sigma_L in paper
G.wNoise = .02; %sigma_GP in paper

G.pWeight = 0.3; % weighting of positional (vs group) information
    % labelled rho in the paper
G.gWeight = 1-G.pWeight;

G.iPrimacy = 0.03; % reduction in encoding across items within groups
    % equals 1 - gamma

G.vSize = 0; % default value for N_EL

G.outIntE = .9; % eta^O_end in paper (output interference for end group if recalled first)               
G.firstCue = .0; % alpha in paper (set to a default value just in case)
G.onlyLastProb = .0; % probability of cueing with last item and then giving up
    % set to non-zero values in specific simulation scripts

G.looseSerial = 0; % do P's record omissions (=1) or are omissions silent (=0)

G.srAct = .15; % eta^NC

G.intruderAct = 0; % initialising value for a_EL; is set to different values elsewhere

G.totOmmT = 5; %threshold for total omissions--set to default value just in case

% Stuff about previous experience--default values
%   Other values are set in files called below
G.openSet = 0; % are prev lists diff items (1), or permutations of items from current list (0)?
G.controlPhi = .35; % phi_g--can be modified in specific simulation scripts below

% timing parameters
G.initRT = .5; 
G.gRT = .25;
G.iRT = .4;

G.Dalezman = 0; % Are we doing Dalezman cueing? Set to 0 by default; set to 1 in Dalezman.m
G.aboveTheLine = 0; % Dalezman's above the line scoring?

%% Here are all the different simulations
% Comment out the one you want to run

% The parameters used to call model.m are:
% [rnoise gPhi iPhi T0 
% outintG giveUpG]
%
% In the paper they are labelled:
% [sigma_v phi_g phi_p theta
% eta^O T_G]
%
% In cases where T_G doesn't apply, we effect this by setting it
% to a very large value (1000).
% Similarly, where there is no threshold on item recall, we set it to
% a very negative value.

% --------Serial LL6 (Simulation 1)
% G.x = [.005 .3 .5 -1000 ...
%     .6 1000]; 
% serialRecallLL6;

% --------SR Grouping (Simulation 2)
% G.x = [.005 .3 .6 .003 ...
%     .65 1000];
% serialRecallHenson; % grouped serial recall with Henson-type analyses

% --------wrapping (Simulation 3)
% G.x = [.005 .3 .5 .003 ...
%      .45 1000]; %.45
% wrapping; % wrapping recall as per Cowan et al. 02

%--------free recall MO70 (Simulation 4)
% G.x = [.005 .3 .5 .003 ...
%       .45 6];
% freeRecallMO70;

%-------Ward LL (Simulation 5)
% G.x = [.005 .3 .5 NaN ...
%     .45 6]; % free
% WardFreeSerial10;

% ---------free recall grouping (Simulation 6)
G.x = [.005 .3 .5 .003 ...
     .45 6];
freeRecallGrouping;

%---------Dalezman (Simulation 7)
% G.x = [.005 .3 .5 .003 ...
%      .4 6]; % free
% freeRecallDalezman;
 
%---------Free vs serial aging (Simulation 8)
% G.x = [.005 .3 .6 .005 ...
%     .45 6];
% freeVsSerialAging;

%---------Serial recall TIE (Simulation 9)
% G.x = [.005 .3 .5 -1000 ...
%       .65 1000]; % serial
% serialRecallTIE;

%---------Free recall TIE (Simulation 10)
% G.x = [.005 .3 .5 .003 ...
%      .45 6];
% freeRecallTIE;

% %---------Free recall Unsworth & Engle (Simulation 11)
% G.x = [.005 .3 .5 .0025 ...
%      .65 6]; % lat number here should be 5
% freeRecallDiffGroups; % comparing different group distributions
% freeRecallPI

%---------Free recall Unsworth & Engle Correlations (part of Simulation 11)
% G.x = [.005 .3 .5 .0015 ...
%      .65 6];
% freeRecallDiffGroupsCorr; % as above, looking at correlations
 
%----------Free recall immediate/delayed/CD (Simulation 12)
% G.x = [.005 0.3 .5 .005 ...
%     0.65 6];
% freeRecallDelay; % immediate vs delayed recall vs CD



