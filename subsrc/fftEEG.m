
%% tbl_fft = fftEEG(data_fil[time ch trl,num_run],fs,frq,sz_win,ovrlp)
function tbl_fft = fftEEG(data_fil,fs,frq,sz_win,ovrlp)
num_run = size(data_fil,4);
num_trl = size(data_fil,3);
num_ch = size(data_fil,2);
if ~exist('fs','var')
    fs = 200;
end

if ~exist('frq','var')
    frq = 50;
end
if ~exist('sz_win','var')
    sz_win = fs;
end

if ~exist('ovrlp','var')
    ovrlp = 0.9;
end

num_win = floor(((size(data_fil,1) - sz_win)/fs) / (1-ovrlp) + 1);
h = repmat(hanning(sz_win),[1,num_ch]);
tbl_fft = zeros(num_win,frq,num_ch,num_trl,num_run);%[time frq ch trl,run]
for i_run = 1 : num_run
for i_trl = 1 : num_trl
    for i_wn = 1 : num_win
        s   = floor(1 + fs * (1-ovrlp) * (i_wn-1) : sz_win + fs * (1-ovrlp) * (i_wn-1));
        s(s> size(data_fil,1)) =size(data_fil,1);
        sig = data_fil(s,:,i_trl,i_run);
        tmp = abs(fft(sig.* h)).^2;
        tmp = tmp./fs;
        tbl_fft(i_wn,:,:,i_trl,i_run) = tmp(2:frq+1,:);
    end
end
end
end
