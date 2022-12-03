%%
classdef Analysis_BMIDB < fileIO_BMIDB

    properties        
    end

    methods (Access = public)

        function self = Analysis_BMIDB

        end
    end

    methods (Access = public) % analysis
        
        function self = analysis_epoching(self)
            name = 'epoching';
            self = self.analysis(name);
        end

        function self = analysis_preproc(self,config_preproc)
            name = 'preproc';
            self = self.analysis(name,config_preproc);
        end

        function self = analysis_fft(self,config_preproc)
            name = 'fft';
            self = self.analysis(name,config_preproc);           
        end
    
        function self = analysis_findIAF(self)
            name ='findIAF';            
            self = self.analysis(name);           
        end

        function self = analysis_calcERSP(self,config_preproc)
            name = 'calcERSP';
            self = self.analysis(name,config_preproc);            
        end

        function self = analysis_calcPLV(self,config_proc)
            name = 'calcPLV';
            self = self.analysis(name,config_proc);            
        end

        function self = analysis_calcPLV_IAF(self,config_proc)
            name = 'calcPLV_IAF';
            self = self.analysis(name,config_proc);           
        end

    end

    methods (Access = protected) %analysis_ (internal)
        self = analysis(self,name,config_proc)
        self = epoching_(self)
        self = preproc_(self,config_preproc)
        self = fft_(self,config_proc)
        self = findIAF_(self)
        self = calcERSP_(self,config_proc)
        self = calcPLV_(self,config_proc)
        self = calcPLV_IAF_(self,config_proc)

        function data_band = filtfilt_nrr(self,data,band)
            Fs = self.Fs;
            [nrb,nra] = butter(3,[band-1 band+1]/(Fs/2));
            data_band = filtfilt(nrb,nra,data);
        end

    end

    methods (Static, Access = protected) % analysis_static

        function data_angle = calc_phaselag(data_band)
            data_band = angle(hilbert(data_band));
            [time,num_ch,num_trl] = size(data_band);
            data_angle = zeros(time,num_ch,num_ch,num_trl);
            for i_ch = 1 : num_ch
                for j_ch = i_ch : num_ch
                    data_angle(:,i_ch,j_ch,:) = data_band(:,i_ch,:)-data_band(:,j_ch,:);
                end
            end
        end

        function data_PLV = calc_PLV__(data_angle,samp_win)
            data_PLV = movmean(exp(i*data_angle), samp_win);
            data_PLV = abs(data_PLV);
        end

    end


    methods (Access = protected) %getter

        function task_onset = get_task_onset(self,i_run)
            task_onset = floor(table2array(self.para_EEG(i_run).events(:,1))/(self.Fs_origin/self.Fs));
        end

        function [list_trl,num_trl] = get_list_trl(self,i_run)
            list_trl = table2array(self.para_EEG(i_run).events(:,3));
            num_trl= max(list_trl);
        end

    end

    methods (Static, Access = protected)

        function time_trl = get_max_trialtime(list_trl,task_onset)
            num_trl =max(list_trl);
            time_trl= zeros(num_trl,1);
            getTime_trl=@(x,y,n) (x(min(find(y==n,1,'last'),numel(x)))-x(find(y==n,1,'first'))+1);
            %getTime_trl=@(x,y,n) (x(min(find(y==n,1,'last')+1,numel(x)))-x(find(y==n,1,'first'))+1);
            for i_trl = 1 : num_trl
                time_trl(i_trl)=getTime_trl(task_onset,list_trl,i_trl);
            end
            time_trl = max(time_trl);
        end
    end
    
    
end
