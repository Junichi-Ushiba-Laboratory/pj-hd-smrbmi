%% Demo code for analysis of EEGDB
addpath('local/')
addpath('./subsrc')
global iseeglabdeployed_
if isempty(iseeglabdeployed_)
    eeglab;
    iseeglabdeployed_ = 1;
else
end

is_wholehead = 1;
num_DB = 3;
sub_load = NaN;%[1:2];
fs_ds = 200; %downsample
path_DB_parent='path_2_data';
path_DB = fullfile(path_DB_parent,sprintf('SMRBMI_HDEEG_%d',num_DB));
AB = Analysis_BMIDB;
vb = visualize_BMIDB_gp;
%% loadfiles
AB = AB.fileIO_scan(path_DB);
AB = AB.fileIO_load(sub_load,fs_ds);
%% preproc
config_preproc = set_config_preproc(num_DB,is_wholehead);
AB = AB.analysis_epoching;
AB = AB.analysis_preproc(config_preproc);
AB = AB.analysis_fft(config_preproc);
AB = AB.analysis_findIAF;
AB = AB.analysis_calcERSP(config_preproc);
return;
%% visualization
p02_visualize




