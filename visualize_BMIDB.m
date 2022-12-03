classdef visualize_BMIDB
    methods (Static, Access = public)

        function PSD(self,coi,list_sub)
            vi = visualize_BMIDB;
            if nargin < 2
                coi = NaN;
            end
            
            if nargin < 3
                list_sub = 1;
            end
            
            num_sub = numel(list_sub);
            for i_sub = 1 : num_sub
                idx_sub=find(self.para_subjects.list_sub==list_sub(i_sub));
                data_sub=self.data_subjects(idx_sub);
                idx_COI=find(data_sub.para_EEG_proc.COI==coi);
                idx_COI(isempty(idx_COI))=1;
                vi.PSD_(data_sub,idx_COI);
            end
        end

        function ERSP(self,coi,list_sub,config_preproc)
            vi = visualize_BMIDB;
            if nargin < 2
                coi = NaN;
            end
            
            if nargin < 3
                list_sub = 1;
            end
            
            num_sub = numel(list_sub);
            for i_sub = 1 : num_sub
                idx_sub=find(self.para_subjects.list_sub==list_sub(i_sub));
                data_sub=self.data_subjects(idx_sub);
                idx_COI=find(data_sub.para_EEG_proc.COI==coi);
                idx_COI(isempty(idx_COI))=1;
                vi.ERSP_(data_sub,idx_COI,config_preproc);
            end
        end

        function PLV(self,COI_seed,list_sub,config_proc)
            vi = visualize_BMIDB;
            if nargin < 2
                COI_seed = NaN;
            end
            
            if nargin < 3
                list_sub = 1;
            end
            
            num_sub = numel(list_sub);
            for i_sub = 1 : num_sub
                idx_sub=find(self.para_subjects.list_sub==list_sub(i_sub));
                data_sub=self.data_subjects(idx_sub);
                idx_COI=find(data_sub.para_EEG_proc.COI==COI_seed);
                idx_COI(isempty(idx_COI))=1;

                vi.PLV_(data_sub,idx_COI,config_proc);
            end

        end

    end
    
    methods (Static, Access = protected)
        function PSD_(self,coi)
            vb = visualize_BMIDB;
            vi = visualize_data;
            data_psd= self.result_EEG.fft;
            num_ses = numel(data_psd);
            [num_column,num_row] = vb.get_num_column(num_ses);
            vi.figure;
            for i_ses = 1 : num_ses
                data_ses = sq(data_psd{i_ses}(:,:,coi,:));
                data_ses = helper_analysis_EEG.flatten(data_ses);
                data_ses = helper_analysis_EEG.clean(data_ses);
                
                vi.sp(num_column,num_row,i_ses);
                plotMat(data_ses)
                vi.setFig(-6,8);
                vi.setLabel('','')
            end
            vi.setFig(-6,8);
        end

        function ERSP_(self,coi,config_preproc)
            vb = visualize_BMIDB;
            vi = visualize_data;
            data_ersp= self.result_EEG.ERSP;
            num_ses = numel(data_ersp);           
            for i_ses = 1 : num_ses            
                data_ses = sq(data_ersp{i_ses}(:,:,coi,:));                
                data_ses = nanmean(data_ses,3);
                vi.drawTF(data_ses,1,config_preproc.ovrlp,1,1);               
                vi.setCB(1,10,100);
                ylim([5 35])
                vi.setTitle(sprintf('Session %02d',i_ses));
            end            
        end
        
        function PLV_(self,coi,config_proc)

            
            vb = visualize_BMIDB;
            vi = visualize_data;
            data_plv= self.result_EEG.PLV;
            num_ses = numel(data_plv);
            for i_ses = 1 : num_ses
                if numel(size(data_plv{i_ses})) == 3
                    data_ses = sq(data_plv{i_ses});
                    data_ses_pad = zeros(size(data_ses,1),config_proc.band_range(end),size(data_ses,3));
                    data_ses_pad(:,config_proc.band_range(1):config_proc.band_range(end),:) = data_ses;
                else
                    data_ses = sq(data_plv{i_ses}(:,:,coi,:));
                end
                data_ses = nanmean(data_ses_pad,3);
                vi.drawTF(data_ses,1,config_proc.ovrlp,1,1);
                if ~config_proc.normalize_plv
                    vi.setCB('PLV',10,-1);
                else
                    vi.setCB('PLV',10,1);
                end
                ylim([config_proc.band_range])
                colormap(hot)
                vi.setTitle(sprintf('Session %02d',i_ses));
            end

        end
    end

    methods (Static)
        function [num_column,num_row] = get_num_column(num_in)
            if num_in > 10
                num_row = 4;                
            else 
                num_row = 2;
            end
            num_column = ceil(num_in/num_row);
        end
    end
end