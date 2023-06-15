function config_mainproc = set_config_mainproc
% PLV
config_preproc = set_config_preproc;

coi_pair = [36,104];
band_range=[5 35];
win_sz = 1;
band_width = 1; %bw, [FOI-bw FOI+bw];
ovrlp = 0.9;
base = round(config_preproc.time_ref(end)/(1-ovrlp));
normalize_plv = 1;
% package
list_var = who;
list_var(contains(list_var,'config_preproc')) = [];
config_mainproc=Atom.generateStruct(list_var,2);
end