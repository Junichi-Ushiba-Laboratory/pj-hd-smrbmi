classdef Atom
    methods (Static)
        function [in,num_in] = fullPath(in)
            in        = fullfile({in.folder},{in.name})';
            num_in    = numel(in);
        end

        function out = generateStruct(varlist,flag_place)
            place_list = {'base';'caller'};
            if nargin < 2
                flag_place = 1;
            end
            out = struct;
            for i_var = 1 : numel(varlist)
                try
                    out.(varlist{i_var}) = evalin(place_list{flag_place},sprintf('%s',varlist{i_var}));
                catch
                    out.(varlist{i_var}) = [];
                end
            end
        end

         function out = dyncat(n,varargin)
            i  = 0;
            sz = cellfun(@size,varargin,'UniformOutput',false);
            num= max(cellfun(@numel,sz)) + 1;
            sz = cat(num,sz{:});

            szmax = max(sz,[],num);
            num_in = numel(varargin);
            szmax(szmax==1) = [];
            out = NaN([szmax,num_in]);

            for i_var = 1 : num_in
                tmp         = varargin{i_var};
                if numel(size_rmzero(tmp)) == 2
                    out(1:size(tmp,1),1:size(tmp,2),i_var) = tmp;
                elseif numel(size_rmzero(tmp)) == 3
                    out(1:size(tmp,1),1:size(tmp,2),1:size(tmp,3),i_var) = tmp;
                elseif numel(size_rmzero(tmp)) == 4
                    out(1:size(tmp,1),1:size(tmp,2),...
                        1:size(tmp,3),1:size(tmp,4),i_var) = tmp;
                elseif numel(size_rmzero(tmp)) == 5
                    out(1:size(tmp,1),1:size(tmp,2),...
                        1:size(tmp,3),1:size(tmp,4),1:size(tmp,5),...
                        i_var) = tmp;
                elseif numel(size_rmzero(tmp)) == 1
                    sz  = size(tmp);
                    i   = find(sz~=1);
                    out(1:size(tmp,i),i_var) = tmp;
                elseif numel(size_rmzero(tmp)) == 0
                    out(1:numel(tmp),i_var) = tmp;
                else
                    fprintf('this function is not compatible with the form\n');
                    return
                end
            end

            function sz = size_rmzero(in)
                sz = size(in);
                sz(sz ==1) = [];
            end
        end
    end

end