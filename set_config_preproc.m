function config_preproc = set_config_preproc(num_DB,is_wholechannel)
if nargin < 2
    is_wholechannel = 0;
end
% spafil
name_ref = 'CAR_selected';
ch_ref = ch_B4;

% coi
if is_wholechannel
    COI = [1:128]; %[C3,C4,Cz]
else
    COI = [36,104,128]; %[C3,C4,Cz]
end

% fft
frq = 50;
ovrlp= 0.9;
fs_fft= round(1/(1-ovrlp));
% ERSP
time_win = helper_analysis_EEG.get_time_win(num_DB);
idx_ses = helper_analysis_EEG.get_idx_ses(num_DB);
time_ref = [0 time_win(1)-1];

% package
config_preproc=Atom.generateStruct(who,2);
end