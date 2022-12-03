function self = preproc_(self,config_preproc)
num_run= numel(self.data_EEG);
for i_run = 1 : num_run
    sig = self.data_EEG(i_run).data;
    %%% spafil
    %sig = sig - mean(sig(:,config_preproc.ch_ref,:),2);
    %%% fileter
    sig = filtEEG(sig,self.Fs,4,1);
    %%% selectCh
    sig = sig(:,config_preproc.COI,:);
    %%% save
    self.data_EEG(i_run).data = sig;
end
self.para_EEG_proc = config_preproc;
end