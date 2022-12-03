function self = findIAF_(self)
num_run= numel(self.data_EEG);
list_IAF=cell(num_run,1);
for i_run = 1 : num_run
    data= self.result_EEG.fft{i_run};    
    num_ch= size(data,3);
    list_IAF_run=zeros(num_ch,2);
    for i_ch = 1 : num_ch
        data_ch = helper_analysis_EEG.flatten(sq(data(:,:,i_ch,:)));                
        IAF = remove1F.findIAFIBF(data_ch);
        list_IAF_run(i_ch,:) = IAF;
    end
    list_IAF{i_run} = list_IAF_run;
end
self.result_EEG.IAF =  list_IAF;
end