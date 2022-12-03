function self = calcPLV_IAF_(self,config_proc)
if isempty(self.data_EEG)
    return
end

ovrlp = 0; 
num_run= numel(self.data_EEG);
PLV_run= cell(num_run,1);
idx_COI= sort(find(ismember(self.para_EEG_proc.COI,config_proc.coi_pair)));

band = self.result_EEG.IAF{1};
band = median(band(:,1),1);
num_band= numel(band);
samp_win= config_proc.win_sz * self.Fs;

num_win = ceil(((size(self.data_EEG(1).data,1)-samp_win)/self.Fs)/ovrlp);
num_win(num_win==Inf) = size(self.data_EEG(1).data,1);
dt_samp = samp_win*ovrlp;
num_samp_all = round(samp_win+dt_samp*num_win);

for i_run = 1 : num_run
    data= self.data_EEG(i_run).data(:,idx_COI,:);    
    num_trl = size(data,3);
    PLV_out = zeros(num_win,num_band,num_trl);    
    for i_band = 1 : num_band
        data_band = self.filtfilt_nrr(data,band(i_band));
        data_band = self.calc_phaselag(data_band);
        data_band = self.calc_PLV__(data_band,samp_win);        
        PLV_out(1:size(data_band,1),i_band,:) = data_band(:,idx_COI(1),idx_COI(2),:);
    end
    if config_proc.normalize_plv
        range_base = 1:config_proc.base/self.para_EEG_proc.fs_fft*self.Fs;
        PLV_out = ...
         (PLV_out-mean(PLV_out(range_base,:,:),1))./std(PLV_out(range_base,:,:),[],1);
    end
    PLV_run{i_run} = PLV_out;
end
self.result_EEG.PLV_IAF = PLV_run;
end