classdef visualize_BMIDB_gp < visualize_BMIDB
    methods (Static, Access = public)

        function PSD(self,coi)
            vi = visualize_BMIDB_gp;
            if nargin < 2
                coi = NaN;
            end           
            med2 = @(x)vi.med_2(x);
            num_sub = numel(self.data_subjects);
            PSD_all = cell(num_sub,1);
            for i_sub = 1 : num_sub                
                data_sub = self.data_subjects(i_sub);                
                idx_COI = find(ismember(data_sub.para_EEG_proc.COI,coi));
                idx_COI(isempty(idx_COI)) = 1;
                PSD_sub = vi.gp_PSD_(data_sub,idx_COI);
                PSD_sub = cellfun(med2,PSD_sub,'UniformOutput',false);
                PSD_sub = cat(2,PSD_sub{:});

                PSD_all{i_sub} = PSD_sub;
            end
            vi.PSD_(PSD_all);
        end
        
        function ERSP(self,coi,config_preproc)
            vi = visualize_BMIDB_gp;
            if nargin < 2
                coi = NaN;
            end            
            num_sub = numel(self.data_subjects);
            ERSP_all = cell(num_sub,1);            
            for i_sub = 1 : num_sub                
                data_sub = self.data_subjects(i_sub);
                idx_COI = find(ismember(data_sub.para_EEG_proc.COI,coi));
                idx_COI(isempty(idx_COI))=1;
                ERSP_sub = vi.gp_ERSP_(data_sub,idx_COI);                
                try
                    ERSP_sub = Atom.dyncat(3,ERSP_sub{:});
                catch
                    ERSP_sub = [];
                end
                ERSP_all{i_sub} = ERSP_sub;                
            end
            vi.ERSP_(ERSP_all,config_preproc);
        end

        function Topo(self,config_preproc)
            taskwin = 1+[1+config_preproc.time_win(1)]*config_preproc.fs_fft : 1+[sum(config_preproc.time_win(1:2))-1]*config_preproc.fs_fft;
            vi = visualize_BMIDB_gp;
            med1 = @(x)vi.med_1(x,taskwin);
            
            coi = config_preproc.COI;
            num_sub = numel(self.data_subjects);
            ERSP_all = cell(num_sub,1);            
            for i_sub = 1 : num_sub 
                try
                    data_sub = self.data_subjects(i_sub);
                    idx_COI = find(ismember(data_sub.para_EEG_proc.COI,coi));
                    ERSP_sub = vi.gp_ERSP_(data_sub,idx_COI);
                    ERSP_sub = cellfun(med1,ERSP_sub,'UniformOutput',false);
                    FOI = data_sub.get_IAF;
                    %FOI = FOI-2:FOI+2;
                    FOI = 11:13;
                    med2 = @(x)vi.mean_2_r(x,FOI);
                    ERSP_sub = cellfun(med2,ERSP_sub,'UniformOutput',false);
                    ERSP_sub = squeeze(cat(1,ERSP_sub{:}))';                    
                    ERSP_sub = helper_analysis_EEG.get_ERSP_ses(ERSP_sub,config_preproc,2);
                catch
                    ERSP_sub = [];
                end
                ERSP_all{i_sub} = ERSP_sub;                
            end
            vi.Topo_(ERSP_all,config_preproc)
        end
    end

    methods (Static, Access = protected)
        function ERSP = gp_ERSP_(self,coi)
            data_ersp = self.result_EEG.ERSP;
            num_ses = numel(data_ersp);           
            ERSP = cell(num_ses,1);
            for i_ses = 1 : num_ses
                if ~isempty(data_ersp{i_ses})
                    data_ses = sq(data_ersp{i_ses}(:,:,coi,:));                
                else
                    continue
                end
                data_ses = nanmedian(data_ses,numel(size(data_ses)));
                ERSP{i_ses} = data_ses;
            end
        end

        function PSD = gp_PSD_(self,coi)
            vb = visualize_BMIDB_gp;
            data_psd = self.result_EEG.fft;
            num_ses = numel(data_psd);
            PSD = cell(num_ses,1);
            for i_ses = 1 : num_ses
                data_ses = sq(data_psd{i_ses}(:,:,coi,:));
                data_ses = helper_analysis_EEG.flatten(data_ses);
                data_ses = helper_analysis_EEG.clean(data_ses);
                PSD{i_ses} = data_ses;
            end
        end

        function PSD = PSD_(PSD_all)
            k = 0.5;
            vi = visualize_data;
            vi.fig;
            num_sub = numel(PSD_all);
            PSD = [];
            for i_sub = 1 : num_sub
                mean_sub = nanmedian(PSD_all{i_sub},2);
                plot(mean_sub,'LineWidth',1.5,'Color',ones(1,3)*k);
                PSD = [PSD,mean_sub];
            end
            plot(nanmedian(PSD,2),'LineWidth',2,'Color','k');
            vi.setFig(-6,10)
        end

        function ERSP = ERSP_(ERSP_all,config_preproc)            
            vi = visualize_data;            
            num_sub = numel(ERSP_all);
            ERSP = [];
            for i_sub = 1 : num_sub
                mean_sub = helper_analysis_EEG.get_ERSP_ses(ERSP_all{i_sub},config_preproc);
                if isempty(mean_sub)
                    continue
                else
                    mean_sub = nanmedian(mean_sub,3);
                end
               
                if i_sub == 1 
                    ERSP = mean_sub;
                else
                    ERSP1 = Atom.dyncat(3,ERSP(:,:,end),mean_sub);
                    ERSP(1:size(ERSP1,1),:,end:end+1) = ERSP1;
                end                
            end            
            vi.drawTF(nanmedian(ERSP,3),1,config_preproc.ovrlp,1,1);
            vi.setCB(1,10,30);
            ylim([5 35])            
        end

        function Topo_(Topo_all,config_preproc)
            num_sub = numel(Topo_all);
            vi = visualize_data;
            vi.figure;
            ERSP = [];
            for i_sub = 1 : num_sub
                mean_sub = Topo_all{i_sub};     
                if isempty(mean_sub)
                    continue
                end
                if i_sub == 1 
                    ERSP = mean_sub;
                else
                    ERSP1 = Atom.dyncat(2,ERSP(:,end),mean_sub);
                    ERSP1 = reshape(ERSP1,size(ERSP1,1),[]);
                    ERSP(1:size(ERSP1,1),end:end+size(ERSP1,2)-1) = ERSP1;
                end  
            end
            drawTopo(nanmean(ERSP,2),config_preproc.COI,36);
            vi.setCB(1,10,30);
        end

    end

    methods (Static, Access = private)
        function out = med_2(in)
            out = nanmedian(in,2);
        end
        function out = med_2_r(in,win)
            out = nanmedian(in(:,win,:,:,:),2);
        end
         function out = mean_2_r(in,win)
            out = nanmean(in(:,win,:,:,:),2);
        end
        function out = med_1(in,taskwin)
            taskwin(taskwin>size(in,1)) = [];
            data = in(taskwin,:,:,:);
            %data = helper_analysis_EEG.clean(data,1);
            out = nanmedian(data,1);
        end
    end
end