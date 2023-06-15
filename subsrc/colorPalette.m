teal    = [0,150,136]/255;
orange  = [255,87,34]/255;
blue    = [0 0.447058826684952 0.74117648601532];
magenta = [1 0 1];
cyan    = [ 0 1 1];
col     = [teal;orange;blue]';
col2    = [magenta;cyan]';
mb      = [49 100 154]/255;
mr      = [193 61 58]/255;
col3    = [mr;mb]';
col4    = [0	190	170;...
            64	0	130	;...
            236	156	4	;...
            15	76	129	;...
            237	102	99	;...
            255	163	114 ;...
            254	52	110	;...
            ]/255;
col4    = col4';
col5    = ([255 121 0;0 109 168]/255)';
col6    = [155	50	255;246	94	94; 21	88	18; 92	201	244;79	255	0]'/255;
clear teal orange blue magenta cyan mb mr
col3_b  = col3/2;
col_tr1  = [col3(:,1),col3_b(:,1)];
col_tr2  = [col3(:,2),col3_b(:,2)];
col_tr   = {col_tr1;col_tr2};
%% palette_gradation

col_grad=[216	242	238	
169	220	211	
45	139	125	
215	180	255	
175	103	255	
135	29	255	
255	237	199	
251	219	142	
255	201	85	
199	217	241	
84	143	217]'/255;	

col_br = [176	140	119]'/255/2;

%figure
%imagesc(1:10); colormap(col_grad')
%%
col_orange_mild = [240 169 134]/255;
