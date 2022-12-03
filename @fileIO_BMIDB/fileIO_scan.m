function self = fileIO_scan(self,path_parent)
dir_sub = dir(fullfile(path_parent,'sub*'));
[dir_sub,num_sub] = Atom.fullPath(dir_sub);

getSes=@(x)Atom.fullPath(dir(fullfile(x,'ses*')));
dir_ses=cellfun(getSes,dir_sub,'UniformOutput',false);

list_var = who;
list_var(contains(list_var,'self')) = [];
self.para_fileIO = Atom.generateStruct(list_var,2);
end