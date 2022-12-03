function para_struct = fileIO_load_tsv(self,in)
[~,filename] = fileparts(in);
para_struct = struct;
if contains(in,'channels')
    file_out = self.fileIO_read_tsv_channels(in);
    para_struct.channels = file_out;
elseif contains(in,'electrodes')
    file_out = self.fileIO_read_tsv_electrodes(in);
    para_struct.electrodes = file_out;
elseif contains(in,'events')
    file_out = self.fileIO_read_tsv_events(in);
    para_struct.events = file_out;
else
    fprintf('Debug: fileIO_load_tsv\n');
end
end