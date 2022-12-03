%% Demo code for analysis of EEGDB
addpath('local/')
eeglab;
num_DB= 1;
sub_load = 1;
fs_ds = 200; %downsample
path_DB_parent='/Volumes/LC48/pj_eegdb/';
path_DB = fullfile(path_DB_parent,sprintf('SMRBMI_HDEEG_%d',num_DB));
AB = Analysis_BMIDB;
vb = visualize_BMIDB;
%% loadfiles
AB = AB.fileIO_scan(path_DB);
AB = AB.fileIO_load(sub_load,fs_ds);
%% preproc
config_preproc = set_config_preproc;
AB = AB.analysis_epoching;
AB = AB.analysis_preproc(config_preproc);
AB = AB.analysis_fft(config_preproc);
AB = AB.analysis_findIAF;
AB = AB.analysis_calcERSP(config_preproc);
%% mainproc
config_mainproc = set_config_mainproc;
AB = AB.analysis_calcPLV(config_mainproc);
AB = AB.analysis_calcPLV_IAF(config_mainproc);
isrj = @(x) isfield(x.para_fileIO,'err');
sub_rj = find(arrayfun(isrj,[AB.data_subjects]));
return;
%% visualization
i_sub = 1;
k = 2;
num_vis = 10;
flag_vis = zeros(num_vis,1);
flag_vis(k) = 1;
close all
for i_vis = 1 : num_vis
if ~flag_vis(i_vis) 
    continue
elseif i_vis == 1
    vb.PSD(AB,36,sub_load(i_sub));
elseif i_vis == 2
    vb.ERSP(AB,36,sub_load(i_sub),config_preproc);
elseif i_vis == 3
    vb.PLV(AB,36,1,config_mainproc);
end
end

if 0==1
%% save PLV
close all
for i_sub = 2 : numel(sub_load)
vb.PLV(AB,36,sub_load(i_sub),config_mainproc);
vi.saveSeq(sprintf('PLV_sub%02d',sub_load(i_sub)))
close all
end
%% save ERSP
close all
for i_sub = 1 : numel(sub_load)
vb.ERSP(AB,36,sub_load(i_sub),config_mainproc);
vi.saveSeq(sprintf('ERSP_sub%02d',sub_load(i_sub)))
close all
end
end



