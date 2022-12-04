function self = calcERSP_(self,config_proc)
num_run= numel(self.data_EEG);
ERSP_run=cell(num_run,1);
for i_run = 1 : num_run
    data= self.result_EEG.fft{i_run};    
    range_ref = config_proc.time_ref(1)*config_proc.fs_fft+1:config_proc.time_ref(2)*config_proc.fs_fft;
    if range_ref(end) > size(data,1)
        continue
    end
    ref = data(range_ref,:,:,:);
    ref = nanmedian(ref,1);
    ERSP_run{i_run} = 100*(data-ref)./ref;    
end
self.result_EEG.ERSP = ERSP_run;
end