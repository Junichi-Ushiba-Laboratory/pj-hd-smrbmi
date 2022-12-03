function self = fileIO_load(self,list_sub,fs_ds)
if isnan(list_sub)
    list_sub = 1: self.para_fileIO.num_sub;
end
if nargin == 3
    fcn_resamp = @(x) pop_resample(x,fs_ds);
else
    fcn_resamp = @(x) x;
    fs_ds = self.Fs_origin;
end
num_sub = numel(list_sub);
%%% set onelinears
get_file_sess_tsv = @(x)Atom.fullPath(dir(fullfile(x,'eeg','*.tsv')));
get_file_sess_edf = @(x)Atom.fullPath(dir(fullfile(x,'eeg','*.edf')));
cellfun_load_tsv = @(x) cellfun(@self.fileIO_load_tsv,x,'Uniformoutput',false);
cellfun_load_edf = @(x) cellfun(@self.fileIO_load_edf,x,'Uniformoutput',false);

sub_out = [];

for i_sub = 1 : num_sub    
    class_sub = Analysis_BMIDB;
    try
    dir_ses = self.para_fileIO.dir_ses{list_sub(i_sub)};

    %%% load_tsv
    dir_ses_tsv = cellfun(get_file_sess_tsv,dir_ses,'UniformOutput',false);
    data_tsv = cellfun(cellfun_load_tsv,dir_ses_tsv,'UniformOutput',false);
    data_tsv = cellfun(@self.fileIO_cat_tsv, data_tsv,'UniformOutput',false);
    data_tsv = [data_tsv{:}]';
    class_sub.para_EEG = data_tsv;

    %%% load_edf
    dir_ses_edf = cellfun(get_file_sess_edf,dir_ses,'UniformOutput',false);
    data_edf = cellfun(cellfun_load_edf,dir_ses_edf,'UniformOutput',false);
    data_edf = [data_edf{:}]';
    data_edf = [data_edf{:}]';

    %%% downsample
    data_edf = arrayfun(fcn_resamp,data_edf,'UniformOutput',false);
    data_edf = [data_edf{:}]';
    class_sub.data_EEG = data_edf;
    class_sub.Fs = fs_ds;
    catch err
        class_sub.para_fileIO.err = err;
    end
    sub_out = [sub_out;class_sub];
end
self.Fs = fs_ds;
self.data_subjects= sub_out;
self.para_subjects.list_sub= list_sub;
end