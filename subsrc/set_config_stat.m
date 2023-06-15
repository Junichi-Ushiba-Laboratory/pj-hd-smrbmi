function config_stat = set_config_stat
% ERSP-PLV
config_preproc = set_config_preproc;
config_mainproc= set_config_mainproc;
COI = [104];
FOI = NaN;
ref = config_mainproc.base;
win = ref+10: ref+config_preproc.time_win(end)*config_preproc.fs_fft;

% package
list_var = who;
list_var(contains(list_var,'config')) = [];
config_stat=Atom.generateStruct(list_var,2);
end