function data_fil = filtEEG(data,fs,flag_spa,flag_fil)
%%% bandpass,spa
% data = filtEEG(data[time,ch,trl],fs,flag_spa{1,2})
if nargin < 4
    flag_fil = 1;
end
if ~exist('fs','var')
    fs = 200;
end

num_trl = size(data,3);

if exist('flag_spa','var')
    try
        switch flag_spa
            case 1
                spafil = [13 34 54 46]; flag_spa = 1;
            case 2
                spafil = ch_B4; flag_spa = 2;
        end
    catch
        spafil = flag_spa;
        flag_spa = 3;
    end
else
    spafil = ch_B4; flag_spa = 2; %car
end

try
    [bpb,bpa] = butter(3,[3 70]/(fs/2));
catch
    [bpb,bpa] = butter(3,[5 35]/(fs/2));
end

[ncb,nca] = butter(3,[49 51]/(fs/2),'stop');

data_fil = zeros(size(data));
if flag_fil == 0
    %%nc
    data_fil= detrend(filtfilt(ncb,nca,data));
elseif flag_fil == 1 
    %%nc +bpf
    data_fil = filtfilt(ncb,nca,filtfilt(bpb,bpa,data));
elseif isnan(flag_fil)
    %%skip filtering
    data_fil= data; 
end

switch flag_spa
    case 1
        %%%lap
        data_fil= data_fil - mean(data_fil(:,spafil,:),2);
    case 2
        %%%car
        data_fil = data_fil - mean(data_fil(:,ch_B4,:),2);
    case 3
        %%% taylor-made spafil
        if size(spafil,1) == num_trl
            %%% trl by trl
            for i_trl = 1 : num_trl
                tmp_spafil = spafil{i_trl,1};
                data_fil = data_fil- mean(data_fil(:,tmp_spafil,:),2);
            end
        else
            data_fil = data_fil- mean(data_fil(:,spafil,:),2);
        end
    case 4
        %%%skip spa 
end
end