classdef remove1F
    methods (Static)
        function IF = findIAFIBF(out_PSD,FOI_search)
            num_ch = size(out_PSD,3);
            if nargin < 2
                FOI_search = [8 13; 14 30];
            end
            num_FOI    = size(FOI_search,1);
            IF         = zeros(num_FOI,num_ch);
            for i_ch = 1 : num_ch
                data     = nanmean(out_PSD(:,:,i_ch),2);
                [data_rmP,FOI] = remove1F.removeF(data);
                for i_band = 1 : num_FOI
                    frange  = FOI_search(i_band,1):FOI_search(i_band,2);
                    tmp     = data_rmP(frange);
                    tmp     = movmean(tmp,[1 1]);
                    [~,I] = max(tmp);
                    IF(i_band,i_ch) = frange(I);
                    fprintf('ch %d band%d: %d Hz\n',i_ch,i_band,IF(i_band,i_ch));
                end
            end
        end

        function [out,frange] = removeF(in)
            fmax               = 65;
            power              = in;
            frequency          = [1 : numel(power)]';
            frange             = [3 45];
            bins_selected      = find(frequency>=frange(1),1):find(frequency>=frange(2),1);

            frequency     = frequency(bins_selected)';
            power         = power(bins_selected,:);

            log_freq      = log10(frequency);
            log_power     = 10*log10(power);

            % define frequence bands
            idx1 = find(frequency>=0.5 & frequency <= 7);
            idx2 = find(frequency>=35 & frequency <= fmax);

            idx_freq        = [idx1 idx2];
            log_freq_roi    = [ones(1,numel(idx_freq)); log_freq(idx_freq)];
            log_power_roi   = [log_power(idx1)' log_power(idx2)'];

            % fit linear slope in log-log space

            fit         = log_freq_roi'\log_power_roi';
            slope       = fit(2);
            intercept   = fit(1);
            fit_1f      = slope*log10(frequency') + intercept;
            out         = in;
            out(bins_selected) = log_power - fit_1f;
        end
    end
end