function self = calcPLV_(self,config_proc)
if isempty(self.data_EEG)
    return
end

ovrlp = 1-config_proc.ovrlp; %0.1
num_run= numel(self.data_EEG);
PLV_run= cell(num_run,1);
idx_COI= sort(find(ismember(self.para_EEG_proc.COI,config_proc.coi_pair)));

band = config_proc.band_range(1):config_proc.band_range(2);
num_band= numel(band);
samp_win= config_proc.win_sz * self.Fs;

num_win = ceil(((size(self.data_EEG(1).data,1)-samp_win)/self.Fs)/ovrlp);
dt_samp = samp_win*ovrlp;
num_samp_all = round(samp_win+dt_samp*num_win);
for i_run = 1 : num_run
    data= self.data_EEG(i_run).data(:,idx_COI,:);    
    data(end+1:num_samp_all,:,:) = 0; %pad
    num_trl = size(data,3);
    PLV_out = zeros(num_win,num_band,num_trl);    
    for i_band = 1 : num_band
        data_band = self.filtfilt_nrr(data,band(i_band));
        data_band = self.calc_phaselag(data_band);
        data_band = self.calc_PLV__(data_band,samp_win);
        s = round(linspace(1,size(data,1),num_win));
        PLV_out(:,i_band,:) = data_band(s,idx_COI(1),idx_COI(2),:);
    end
    if config_proc.normalize_plv
        range_base = 1:config_proc.base;
        PLV_out = ...
         (PLV_out-mean(PLV_out(range_base,:,:),1))./std(PLV_out(range_base,:,:),[],1);
    end

    PLV_run{i_run} = PLV_out;
end
self.result_EEG.PLV = PLV_run;
end