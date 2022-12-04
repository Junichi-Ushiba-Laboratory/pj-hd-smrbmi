classdef helper_analysis_EEG
    
    methods (Static)
        function time_win = get_time_win(num_DB)
            if num_DB == 1
                time_win = [6 7]; %rest task
            elseif num_DB == 2
                time_win = [8 7]; %rest task
            elseif num_DB == 3
                time_win = [7 6]; %rest task
            end
        end
        
        function idx_ses = get_idx_ses(num_DB)
            if num_DB == 1
                idx_ses = 'all';
            elseif num_DB == 2
                idx_ses = 'all';
            elseif num_DB == 3
                idx_ses = 1:6:20;
            end
        end
        
        function ERSP_ses = get_ERSP_ses(ERSP_ses,config_preproc,type)
            if nargin < 3
                type = 1;
            end
            if ischar(config_preproc.idx_ses)
                ERSP_ses = ERSP_ses;
            elseif isempty(ERSP_ses)
                ERSP_ses = [];
            else
               if type == 1 
                   ERSP_ses = ERSP_ses(:,:,config_preproc.idx_ses);
               elseif type == 2
                   ERSP_ses = ERSP_ses(:,config_preproc.idx_ses);
               end
            end
        end
    end

    methods (Static)
        function [eeg,sz_pad] = padEEG(eeg,Fs,sz_win)
            if numel(size(eeg))==2
                [time,num_ch] = size(eeg);
                sz_pad = sz_win/2;
                zeropad = zeros(sz_pad,num_ch);
                eeg = [zeropad;eeg;zeropad];
            elseif numel(size(eeg))==3
                [time,num_ch,num_trl] = size(eeg);
                sz_pad = sz_win/2;
                zeropad = zeros(sz_pad,num_ch,num_trl);
                eeg = [zeropad;eeg;zeropad];
            elseif numel(size(eeg))==4
                [time,num_ch,num_trl,num_run] = size(eeg);
                sz_pad = sz_win/2;
                zeropad = zeros(sz_pad,num_ch,num_trl,num_run);
                eeg = [zeropad;eeg;zeropad];
            end
        end

        function in = flatten(in) % data_ses [time frq trl]
            in = permute(in,[2,1,3]);
            in = reshape(in,size(in,1),[]);
        end

        function in = clean(in,dims)
            if nargin < 2
                dims = 2;
            end
            in(isoutlier(in,"median",dims,"ThresholdFactor",1)) = NaN;
        end

        function in = cleanmean(in,dims)
            in = in([2:7,10:15],:);
            %in = helper_analysis_EEG.clean(in,dims);
            in = nanmedian(in,dims);
        end
    end
end