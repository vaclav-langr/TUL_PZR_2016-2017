clear *
close all
clc

dirs = dir('parameters');
if(size(dirs,1) == 0)
    mkdir('parameters');
end

dirs = dir('records/*_*');
for i = 1:size(dirs,1)
    mkdir(strcat('parameters/', dirs(i).name))
    files = dir(strcat('records/', dirs(i).name, '/', '*.wav'));
    for j = 1:size(files,1)
        file_name = files(j).name;
        params = parameterSpec(strcat('records/', dirs(i).name, '/', file_name));
        file_name = strrep(file_name, '.wav', '.csv');
        csvwrite(strcat('parameters/', dirs(i).name, '/', file_name), params);
    end
end