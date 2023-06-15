function setFig(visualize_data,num_case,size_font)
fd = visualize_data(1).Font_def;
if isempty(fd), fd = 'Arial';, end
if nargin < 3
    size_font = 10;
end
if nargin < 2
    num_case = 4;
end
if isempty(visualize_data(1).flag_box) || visualize_data(1).flag_box == 1
    box('on');
else
    box('off');
end
if size_font < 0
    size_font = abs(size_font);
else
    size_font = ceil(size_font*35/19);
end
if num_case > 0
    set(gca,'FontWeight','bold');
else
    set(gca,'FontWeight','normal');
end
num_case = abs(num_case);
set(gca,'Fontsize',size_font,'FontName',fd);
if num_case < 0
    num_case = abs(num_case);
    set(gca,'linewidth',1)
else
    set(gca,'linewidth',2)
end
set(gcf,'color',[1 1 1]);
if num_case == 1
    %%% Amplitude-Time (2D)
    xlabel('Time [s]');
    ylabel('Amplitude [µV]')
elseif num_case == 2
    %%% imagesc_TF
    colormap('jet')
    xlabel('Time [s]')
    ylabel('Frequency [Hz]');
    axis xy
elseif num_case == 3 % imagesc_topo
    colormap('jet')
    axis xy
elseif num_case == 4
    % skip
elseif num_case == 5
    %%% remove ticks
    xticklabels(cell(numel(xticklabels),1));
    yticklabels(cell(numel(xticklabels),1));
elseif num_case == 6
    %%% PSD
    xlabel('Frequency [Hz]');
    ylabel('Power [µV^2]')
    yl = ylim;
    ylim([0 yl(2)]);
end
end