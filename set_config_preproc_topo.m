function config_preproc = set_config_preproc
% spafil
name_ref = 'CAR_selected';
ch_ref = ch_B4;

% coi
COI = [1:128]; %[C3,C4,Cz]

% fft
frq = 50;
ovrlp= 0.9;
fs_fft= round(1/(1-ovrlp));
% ERSP
time_win = [6 7]; %rest task
time_ref = [0 time_win(1)-1];

% package
config_preproc=Atom.generateStruct(who,2);
end