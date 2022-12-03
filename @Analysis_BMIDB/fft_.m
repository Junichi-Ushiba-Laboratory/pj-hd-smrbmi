function self = fft_(self,config_proc)
frq = config_proc.frq;
ovrlp = config_proc.ovrlp;
num_run= numel(self.data_EEG);
out_fft= cell(num_run,1);
for i_run = 1 : num_run
    data= self.data_EEG(i_run).data;
    data= helper_analysis_EEG.padEEG(data,self.Fs,self.Fs);
    data_fft = fftEEG(data,self.Fs,frq,self.Fs,ovrlp);
    out_fft{i_run} = data_fft;
end
self.result_EEG.fft = out_fft;
end