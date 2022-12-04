k = [1,2,3];%[1,2,3];
num_vis = 10;
flag_vis = zeros(num_vis,1);
flag_vis(k) = 1;
vi = visualize_data;
close all
for i_vis = 1 : num_vis
if ~flag_vis(i_vis) 
    continue
elseif i_vis == 1
    vb.PSD(AB,36);
    xlim([0 35])
    ylim([0 80])
    vi.setPos([1 283 253 313]);
elseif i_vis == 2
    vb.ERSP(AB,36,config_preproc);
    xlim([0 sum(config_preproc.time_win)]);    
elseif i_vis == 3
    vb.Topo(AB,config_preproc);
end
end