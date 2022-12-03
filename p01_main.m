%% Demo code for analysis of EEGDB
addpath('local/')
global iseeglabdeployed_
if isempty(iseeglabdeployed_)
    eeglab;
    iseeglabdeployed_ = 1;
else
end

num_DB= 1;
sub_load = [1:2];
fs_ds = 200; %downsample
path_DB_parent='/Volumes/LC48/pj_eegdb/';
path_DB = fullfile(path_DB_parent,sprintf('SMRBMI_HDEEG_%d',num_DB));
AB = Analysis_BMIDB;
vb = visualize_BMIDB_gp;
%% loadfiles
AB = AB.fileIO_scan(path_DB);
AB = AB.fileIO_load(sub_load,fs_ds);
%% preproc
%config_preproc = set_config_preproc;
config_preproc = set_config_preproc_topo;
AB = AB.analysis_epoching;
AB = AB.analysis_preproc(config_preproc);
AB = AB.analysis_fft(config_preproc);
AB = AB.analysis_findIAF;
AB = AB.analysis_calcERSP(config_preproc);
return;
%% visualization
i_sub = 1;
k = 3;
num_vis = 10;
flag_vis = zeros(num_vis,1);
flag_vis(k) = 1;
close all
for i_vis = 1 : num_vis
if ~flag_vis(i_vis) 
    continue
elseif i_vis == 1
    vb.PSD(AB,36);
elseif i_vis == 2
    vb.ERSP(AB,36,config_preproc);
elseif i_vis == 3
    vb.Topo(AB,config_preproc);
end
end




