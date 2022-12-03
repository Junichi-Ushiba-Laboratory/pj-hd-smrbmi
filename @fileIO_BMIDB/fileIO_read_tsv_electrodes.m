function table_electrodes = fileIO_read_tsv_electrodes(filename, dataLines)
%%% Input handling
% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["name", "x", "y", "z", "impedance"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "name", "TrimNonNumeric", true);
opts = setvaropts(opts, "name", "ThousandsSeparator", ",");

% Import the data
table_electrodes = readtable(filename, opts);

end