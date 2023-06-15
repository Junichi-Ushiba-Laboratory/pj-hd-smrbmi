%% load
run('ChannnelLocation.m'); 
if exist('ch_rep','var')
    loc = loc(ch_rep,:);
else
    ch = 1 : numel(Z);
    loc = loc(1:numel(Z),:);
end

%% parameters
CONTOURNUM  =3;
BACKCOLOR   =[1 1 1];  % [.93 .96 1];  % EEGLAB standard
HEADCOLOR   =[0 0 0];  % default head color (black)
GRID_NUM    =100;       % Resolution
XMIN        =0;
XMAX        =1;
YMIN        =0;
YMAX        =1;
RMAX        =0.5;

HEADRAD         =   0.5;   % ó÷äsÇÃëÂÇ´Ç≥
shiftv          =   0.5;
VIEW_MARGIN     =   0.15;
HEADRINGWIDTH   =   .007;                   % width of the cartoon head ring
HLINEWIDTH      =   3;     % default linewidth for head, nose, ears
q = .04; % ear lengthening

% Make mesh grid data
xi              = linspace(0,1,GRID_NUM);
yi              = linspace(0,1,GRID_NUM);

mname='v4';

CIRCGRID    =   201;
l           =   linspace(0,2*pi,CIRCGRID);
rx          =   sin(l);
ry          =   cos(l);

vm=(1+VIEW_MARGIN)/2;

%â∫é¸ÇË
Lx=[vm vm -vm -vm vm vm];
Ly=[0 -vm -vm  vm vm  0];

fillx=[[rx(:)' rx(1)]*HEADRAD Lx]+shiftv;
filly=[[ry(:)' ry(1)]*HEADRAD Ly]+shiftv;

% ó÷äs/ï@ÅEé®
hin     = HEADRAD*(1- HEADRINGWIDTH/2);     % inner head ring radius
headx   = [[rx(:)' rx(1) ]*(hin+HEADRINGWIDTH)  [rx(:)' rx(1)]*hin]+shiftv;
heady   = [[ry(:)' ry(1) ]*(hin+HEADRINGWIDTH)  [ry(:)' ry(1)]*hin]+shiftv;

% RMAX = 0.5
base  = RMAX-.0046;
basex = 0.18*RMAX;                   % nose width
tip   = 1.15*RMAX; 
tiphw = .04*RMAX;                    % nose tip half width
tipr  = .01*RMAX;                    % nose tip rounding

EarX = [.489 .503 .518 .5299 .5419 .548 .547 .532 .510 .485]+shiftv;
EarY = [.0965 .1125 .1083 .0976 .0655 -.0055 -.0932 -.1313 -.1384 -.1199]+shiftv;


NoseX=[basex;tiphw;0;-tiphw;-basex]    +shiftv;
NoseY=[base;tip-tipr;tip;tip-tipr;base]+shiftv;