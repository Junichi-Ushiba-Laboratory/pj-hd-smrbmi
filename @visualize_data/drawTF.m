function tmp = drawTF(vi,tbl_ERSP,coi,ovrlp,num_run,flag_mm)
%drawTF(tbl_ERSP[time,frq,ch,trl],coi,ovrlp,num_run,flag_mm)
frq = size(tbl_ERSP,2);
if ~exist('coi','var')
    coi = 36;
end
if ~exist('num_run','var') || num_run == 1
    flag_multi = 0;
else
    flag_multi = 1;
    num_trl_run = ceil(size(tbl_ERSP,4)/num_run);
end
if ~exist('flag_mm','var')
    flag_mm = 1;
end

ERSP_coi = squeeze(tbl_ERSP(:,:,coi,:));

switch flag_multi
    case 0
        vi.figure(vi.invs);
        switch flag_mm
            case 1
                tmp = nanmean(ERSP_coi,3)';
            case 2
                tmp = nanmedian(ERSP_coi,3)';
        end
        imagesc([0 size(tmp,2)*(1-ovrlp)],[1 frq],tmp);
        hold on;
        vi.setFig(-2,10)
    case 1
        vi.figure(vi.invs);
        for i_run = 1 : num_run
            subplot(ceil((num_run+1)/2),2,i_run);
            s = num_trl_run * (i_run-1) + 1 : num_trl_run*i_run;
            
            switch flag_mm
                case 1
                    tmp = nanmean(ERSP_coi(:,:,s),3)';
                case 2
                    tmp = nanmedian(ERSP_coi(:,:,s),3)';
            end
            
            imagesc([0 size(tmp,2)*(1-ovrlp)],[1 frq],tmp);
            hold on;
            vi.setFig(-2,10)
            caxis([-100 100])
        end
        subplot(ceil((num_run+1)/2),2,i_run+1);
        switch flag_mm
            case 1
                tmp = nanmean(ERSP_coi,3)';
            case 2
                tmp = nanmedian(ERSP_coi,3)';
        end
        imagesc([0 size(tmp,2)*(1-ovrlp)],[1 frq],tmp);
        hold on;
        vi.setFig(-2,10)
        set(gcf,'position',[4 86 1321 1259]);
        caxis([-100 100])
end
end