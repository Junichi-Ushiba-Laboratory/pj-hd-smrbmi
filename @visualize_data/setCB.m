function cb = setCB(num_case,size_font,N)
FW        = 'normal';
%FW       = 'bold';
labelName= {'ERSP, %';'t-value';'ERSP [dB]'};
getN = [50,15,5,NaN];
if ~exist('num_case','var')
    num_case = 3;
elseif isempty(num_case)
    num_case = 3;
elseif ischar(num_case)
    label_cb = num_case;
    num_case = 4;
end

if ~exist('N','var')
    N = getN(num_case);
elseif isempty(N)
    N = getN(num_case);
end

if ~exist('size_font','var')
    size_font = 24;
elseif isempty(size_font)
    size_font = 24;
end
size_font = ceil(size_font*35/19);
cb = colorbar;
set(cb,'FontSize',size_font);
if num_case == 1 || num_case ==2
    try
        if numel(N) == 1
            N2 = max(-N,-100);
            caxis([N2, N])
            set(cb,'Fontweight',FW,...
                'Ticks',linspace(-N2,N,5));
        elseif numel(N) == 2
            caxis([N(1), N(2)])
            set(cb,'Fontweight',FW,...
                'Ticks',linspace(N(1),N(2),5));
        end
    catch
        N = caxis;
        caxis([N(1) N(2)])
        set(cb,'Fontweight',FW,...
            'Ticks',linspace(N(1),N(2),5));
    end
    
    ylabel(cb,labelName{num_case,1},'FontWeight',FW,'Fontsize',size_font)
elseif num_case ~= 4
    if sign(N) == 1
        caxis([-N N])
    else
        N = -N;
        caxis([0 N])
    end
    set(cb,'Fontweight',FW,...
        'Ticks',linspace(-N,N,5));
    ylabel(cb,labelName{num_case,1},'FontWeight',FW,'Fontsize',size_font)
else
    if numel(N) == 2
        caxis(N)
        tickval = linspace(N(1),N(end),5);
    else
    try
        if sign(N) == 1
            caxis([-N N])
        else
            N = -N;
            caxis([0 N])
        end
    catch
        N = caxis;
        caxis([N(1) N(2)])
    end
    tickval = linspace(-N,N,5);
    end
    ylabel(cb,label_cb,'FontWeight',FW,'Fontsize',size_font)
    set(cb,'Fontweight',FW,...
        'Ticks',tickval);
end
end