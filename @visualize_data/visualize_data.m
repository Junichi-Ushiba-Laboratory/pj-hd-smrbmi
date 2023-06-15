%%% Author: Seitaro Iwama
%%% 2021.3
%#ok<*PROP>
%#ok<*PROPLC>
classdef visualize_data
    properties
        Font_def
        flag_box
        para_col
        invs
    end

    methods (Static)
        %% FigUtils
        function f = fig(invs)
            if nargin < 1
                invs = 0;
            end
            if invs
                f = figure('visible','off');
            else
                f = figure;
            end
            hold on;
            set(f,'color',[1 1 1])
            visualize_data.setCorner;
            drawnow;pause(0.1);
        end
        function f = fig_square(invs)
            if nargin < 1
                invs = 0;
            end
            f = visualize_data.fig(invs);
            pbaspect([1 1 1]);
            visualize_data.setPos([1,1,560 420]);
            drawnow;pause(0.1);
        end
        function f = figure(invs)
            if nargin < 1
                invs = 0;
            end
            if invs
                f = figure('visible','off');
            else
                f = figure;
            end
            set(f,'color',[1 1 1])
            visualize_data.setCorner;
            drawnow;pause(0.1);
        end
        function f = figure_square(invs)
            if nargin < 1
                invs = 0;
            end
            if invs
                f = figure('visible','off');
            else
                f = figure;
            end
            pbaspect([1 1 1]);
            visualize_data.setCorner;
            drawnow;pause(0.1);
        end
        function setFigName(str)
            f = gcf;
            set(f,'Name',str);
        end
        function t = setTitle(str)
            f = gcf;
            t = title(str,'Interpreter','none');
        end
        function setSquare
            pbaspect([1 1 1]);
        end

        function setLabel(x,y,z)
            num_label = nargin;

            for i_label = 1 : num_label
                if i_label == 1
                    xlabel(x,'Interpreter','none')
                elseif i_label == 2
                    ylabel(y,'Interpreter','none')
                elseif i_label == 3
                    zlabel(z,'Interpreter','none')
                end
            end

        end

        function offLegend(h)
            hAnnotation = get(h,'Annotation');
            hLegendEntry = get(hAnnotation,'LegendInformation');
            set(hLegendEntry,'IconDisplayStyle','off')
        end

        function spout = sp(l,m,n,o)
            l = ceil(l);
            if nargin < 4
                o = 0;
            end
            spout=subplot(l,m,n);
            if o==0
                hold on;
            end
        end

        function setCorner
            poslist = [560 420;560 725;2560 725];
            pl = get(groot,'MonitorPositions');
            global isteamviewer
            if isteamviewer
                pl = pl(1,:);
            else
                pl = pl(end,:);
            end
            visualize_data.setPos([pl(1),pl(2),poslist(1,1) poslist(1,2)]);
        end

        function pos = getCurrPos
            pos = get(gcf,'position');
            fprintf('%d %d %d %d\n',pos)
        end

        function setPos(num_case,varargin)
            if ~exist('num_case','var')
                num_case = 2;
            elseif isempty(num_case)
                num_case = 2;
            end
            szmax = get(0,'ScreenSize');
            try
                switch num_case
                    case 1
                        %%% large
                        set(gcf,'Position',szmax*0.95);
                    case 2
                        %%% TF,Topo
                        set(gcf,'Position',[680   296   898   682]);
                    case 3
                        %%% middle
                        set(gcf,'Position',[8 172 953 747]);
                    case 4
                        %%% for Presentation
                        set(gcf,'Position',[680 467 1112 461]);
                    case 5 %for stat vis
                        set(gcf,'Position',[680 467 350 350]);
                    case 'tile'
                        poslist_tile = varargin{1};
                        set(gcf,'Position',poslist_tile(varargin{2},:));
                end
            catch
                set(gcf,'Position',num_case);
            end
            drawnow limitrate
        end
    end

    methods (Access = public)
        setFig(visualize_data,num_case,size_font)

        function f = fcn_drawTF(visualize_data,in,x,y,flag_nonfig)
            if nargin == 5
                f = [];
            else
                f = figure;
            end
            imagesc(x,y,in);
            hold on;
            visualize_data.setFig(2,10);
            visualize_data.setCB(1,10,100);
        end

    end

    methods (Static)
        %% colorbar
        cb = setCB(num_case,size_font,N)
    end

    methods (Access = public)
        function out = loadColor(out)
            colorPalette;
            list_var = who;
            list_var(contains(list_var,'out')) = [];
            out.para_col = Atom.generateStruct(list_var);
        end
        %% initilaize
        function out = visualize_data(invs,Font_def)
            if nargin < 1
                invs = 0;
            end
            if nargin < 2
                Font_def = 'Arial';
            end
            set(groot,'defaultAxesFontName',Font_def);
            set(groot,'defaultTextFontName',    Font_def);
            set(groot,'defaultLegendFontName',  Font_def);
            set(groot,'defaultColorbarFontName',Font_def);
            out.Font_def = Font_def;

            out      = out.loadColor;
            out.invs = invs;
            out.flag_box = 0;
        end
    end

    %% EEG
    methods (Access=public)
        tmp = drawTF(vi,tbl_ERSP,coi,ovrlp,num_run,flag_mm)
    end

    methods(Static)
        [cls chs,hs]=drawTopo(Z,ch_rep,coi_rep,i)
    end
end

