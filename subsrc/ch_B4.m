%% 
function ch_rep = ch_B4(cl_rj,cl_adpt);
if nargin < 1
    cl_rj = 0;
end
flag_adpt = 0;
if nargin == 2
    flag_adpt = 1;
end
    
ch          = 1:129;
num_ch      = numel(ch);
%% chList
c1 = [23 24 26 27 28 33];
c2 = [15 10 16 18 19 11 4 5 12 118];
c3 = [2 3 122 123 124 117];
c4 = [109 108 102 101 96 ];
c5 = [111 110 103 104 98 93]; % Rt Parietal
c6 = [6 13 7 112 106 105 87 80 30 31 37]; %Parietal
c7 = [35 29 36 41 42 47]; % Lt parietal
c8 = [40 46 45 50 58];
c9 = [51 52 53 60 59 64];
c10= [55 79 54 78 77 62 72 61 67];
c11= [86 92 97 85 91 95];
c12= [65 66 71 70 74 69];
c13= [76 84 90 83 82 89];
num_region = 13;
if flag_adpt == 0
%% Reject Chs 20180701
suf_i = 1;
name_c = who(char(strcat('c',string(1))));
ch_cluster = cell(2,num_region);
c = eval(name_c{1,1});
ch_cluster{1} = c;
for region_i = 2 : num_region
    name_c = who(char(strcat('c',string(region_i))));
    t = eval(name_c{1,1});
    ch_cluster{1,region_i} = t;
    c = cat(2,c,t);
end

for ch_i =1 : num_ch
    if ismember(ch_i,c) == 0
        c14(suf_i) = ch_i;
        suf_i = suf_i + 1;
    end
end
ch_reject = sort(cat(2,c8,c4,c14));
if cl_rj == 0
    %pass
else    
    str = repmat('c%d,',[1,numel(cl_rj)-1]);
    ch_reject_add = eval(...
        sprintf(['cat(2,',str,'c%d);'],[cl_rj(:)]));
    ch_reject = sort(cat(2,ch_reject,ch_reject_add));
end
% ch_reject = sort(cat(2,c1,c2,c3,c8,c4,c14));
% ch_reject = c14;
% ch_reject = 49;
% ch_reject = cat(2,1:35,37:129); %% C3 Only
num_reject= length(ch_reject);

%% Reject temp,front
num_ch_r = num_ch - num_reject;
ch_rep = zeros(num_ch_r,1);
ch_tmp =1;
switch_cl(1:num_region) = 0;
for ch_i = 1 : num_ch
    if ismember(ch_i,ch_reject) == 1
    else
        ch_rep(ch_tmp,1) = ch_i;
        for cl_i = 1 : num_region
            tmp_cl = ch_cluster{1,cl_i};
            if ismember(ch_i,tmp_cl) == 1 && switch_cl(cl_i)==0
                ch_cluster{2,cl_i} = ch_tmp;
                switch_cl(cl_i) = 1;
                break
            elseif ismember(ch_i,tmp_cl) == 1 && switch_cl(cl_i)==1
                ch_cluster{2,cl_i} = cat(2,ch_cluster{2,cl_i},ch_tmp);
                break
            end
        end
        ch_tmp = ch_tmp+1;
    end
end
num_ch    = num_ch-num_reject;
ch_filter = 1 : num_ch;

elseif flag_adpt
    ch_rep = [];
    for i_adpt = 1 : numel(cl_adpt)
        ch_rep = [ch_rep,eval(sprintf('c%d',cl_adpt(i_adpt)))];
    end
    ch_rep = sort(ch_rep);
end
    
end