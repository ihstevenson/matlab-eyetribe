% Reads an eyetribe file saved as a result of a tcpip recording...
%
% * Author:  Ian Stevenson
% * This work is licensed under a Creative Commons Attribution 4.0
%   International License (https://creativecommons.org/licenses/by/4.0/).

function F = readTETfile(fname)

fid = fopen(fname);
tline = fgetl(fid);
F=[];
while ischar(tline)
    if strncmp(tline,'     ',5) % ignore comment lines (just keep the data)
        F = [F tline];
        disp(tline)
    end
    tline = fgetl(fid);
end
fclose(fid);
F = strrep(F,'       ','');
F = strrep(F,'}}}',['}}}' char(10)]);
F = strrep(F,'beat"}',['beat"}' char(10)]);
F = strrep(F,':200}',[':200}' char(10)]);
