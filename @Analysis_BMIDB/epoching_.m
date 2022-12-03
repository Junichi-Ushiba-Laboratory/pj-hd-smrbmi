function self = epoching_(self)
num_run= numel(self.data_EEG);
for i_run = 1 : num_run
    data= self.data_EEG(i_run).data;
    num_ch= size(data,1);
    [list_trl,num_trl] = self.get_list_trl(i_run);
    task_onset = self.get_task_onset(i_run);
    time_trl= self.get_max_trialtime(list_trl,task_onset);

    data_out= zeros(num_ch,time_trl,num_trl);
    for i_trl = 1 : num_trl
        s = task_onset(find(list_trl==i_trl,1,'first'));
        s = s+1:s+time_trl;
        data_tmp = data(:,s);
        data_out(:,:,i_trl) = data_tmp;
    end
    data_out = permute(data_out,[2,1,3]);
    self.data_EEG(i_run).data = double(data_out);
end
end