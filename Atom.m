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
    end

end