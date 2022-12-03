function self = analysis(self,name,config_proc)
num_sub = numel(self.data_subjects);
for i_sub = 1 : num_sub
    data_sub = self.data_subjects(i_sub);
    if contains(name,'epoching')
        data_sub = data_sub.epoching_;
    elseif contains(name,'preproc')
        data_sub = data_sub.preproc_(config_proc);
    elseif contains(name,'fft')
        if nargin < 3
            config_proc = struct;
            config_proc.frq = 50;
            config_proc.ovrlp = 0.9;        
        end
        data_sub = data_sub.fft_(config_proc);
    elseif contains(name,'findIAF')
        data_sub = data_sub.findIAF_;        
    elseif contains(name,'calcERSP')
        data_sub = data_sub.calcERSP_(config_proc);
    elseif contains(name, 'calcPLV_IAF')
        data_sub = data_sub.calcPLV_IAF_(config_proc);
    elseif contains(name,'calcPLV')
        data_sub = data_sub.calcPLV_(config_proc);
    end
    self.data_subjects(i_sub) = data_sub;
end

end
