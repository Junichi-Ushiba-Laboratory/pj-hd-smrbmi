classdef fileIO_BMIDB

    properties
        Fs_origin=1000;
        Fs=1000;
        para_fileIO=struct;
        para_EEG
        para_EEG_proc
        data_EEG
        result_EEG=struct;
        para_subjects=struct;
        data_subjects
    end

    methods (Access = public) % fileIO
        self = fileIO_load(self,list_sub,fs_ds)
        para_struct = fileIO_load_tsv(self,in)
        self = fileIO_scan(self,path_parent)
    end

    methods (Static, Access = protected) % fileIO(Static)
        table_channels= fileIO_read_tsv_channels(filename, dataLines)
        table_electrodes= fileIO_read_tsv_electrodes(filename, dataLines)
        table_events= fileIO_read_tsv_events(filename, dataLines)

        function para_struct= fileIO_cat_tsv(in)
            para_struct = struct;
            num_in = numel(in);
            for i_in = 1 : num_in
                fname  = fieldnames(in{i_in});
                para_struct.(fname{end})=in{i_in}.(fname{end});
            end
        end

        function file_out= fileIO_load_edf(in)
            file_out = pop_biosig(in);
        end
    end


end