function table_channels = fileIO_read_tsv_channels(filename, dataLines)
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
opts.VariableNames = ["name", "type", "units", "status", "status_description"];
opts.VariableTypes = ["double", "categorical", "categorical", "categorical", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["type", "units", "status", "status_description"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "name", "TrimNonNumeric", true);
opts = setvaropts(opts, "name", "ThousandsSeparator", ",");

% Import the data
table_channels = readtable(filename, opts);
end