%% setParameter_topo_3

run('ChannnelLocation.m');
%% Reject Ch
ch_tmp =1;
tmp_loc = zeros(numel(ch_rep),2);
for ch_i =1 : numel(loc(:,1))
    if ismember(ch_i,ch_rep) == 0
    else
        tmp_loc(ch_tmp,:) = loc(ch_i,:);
        ch_tmp = ch_tmp+1;
    end
end
loc = tmp_loc;
loc(:,2) = loc(:,2) + 0.05;
%% parameters
% changed for 78ch(smaller head)
CONTOURNUM  =2'; %10
BACKCOLOR   =[1 1 1];  % [.93 .96 1];  % EEGLAB standard
HEADCOLOR   =[0 0 0];  % default head color (black)
GRID_NUM    =100;       % Resolution
XMIN        =0;
XMAX        =1;
YMIN        =0;
YMAX        =1;
RMAX=0.5;

HEADRAD         =   0.5;   % 輪郭の大きさ
shiftv          =   0.5;
VIEW_MARGIN     =   0.15;
HEADRINGWIDTH   =   0.007;                   % width of the cartoon head ring
HLINEWIDTH      =   3;     % default linewidth for head, nose, ears
q = .04; % ear lengthening

% Make mesh grid data
xi              = linspace(0,1,GRID_NUM);
yi              = linspace(0,1,GRID_NUM);

mname='v4';

a = 0.85;
shiftv_y =0.45;

CIRCGRID    =   201;
l           =   linspace(0,2*pi,CIRCGRID);
rx          =   sin(l)*a;
ry          =   cos(l)*a;

vm=(1+VIEW_MARGIN)/2;

%下周り
Lx=[vm vm -vm -vm vm vm];
Ly=[0 -vm -vm  vm vm  0];


fillx=[[rx(:)' rx(1)]*HEADRAD Lx]+shiftv-0.05;
filly=[[ry(:)' ry(1)]*HEADRAD Ly]+shiftv_y+0.05;

% 輪郭/鼻・耳
hin     = HEADRAD*(1- HEADRINGWIDTH/2);     % inner head ring radius
headx   = [[rx(:)' rx(1) ]*(hin+HEADRINGWIDTH)  [rx(:)' rx(1)]*hin]+shiftv;
heady   = [[ry(:)' ry(1) ]*(hin+HEADRINGWIDTH)  [ry(:)' ry(1)]*hin]+shiftv_y;

% RMAX = 0.5
base  = RMAX-.0046;
basex = 0.18*RMAX;                   % nose width
tip   = 1.15*RMAX; 
tiphw = .04*RMAX;                    % nose tip half width
tipr  = .01*RMAX;                    % nose tip rounding

EarX = [.489 .503 .518 .5299 .5419 .548 .547 .532 .510 .485]+shiftv-0.07;
EarY = [.0965 .1125 .1083 .0976 .0655 -.0055 -.0932 -.1313 -.1384 -.1199]+shiftv-0.05;


NoseX=[basex;tiphw;0;-tiphw;-basex]    +shiftv;
NoseY=[base;tip-tipr;tip;tip-tipr;base]+shiftv-0.12;