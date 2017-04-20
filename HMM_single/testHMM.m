clear *
close all
clc

models = struct([]);
people = dir('parameters/*_*/');
people = {people.name;};
for i = 0:9
    files = {};
    for j = 1:length(people)
        temp_files = dir(strcat('parameters/', people{j}, '/c*'));
        temp_files = {temp_files.name;};
        filtered = ~cellfun('isempty',regexp(temp_files, strcat('c',int2str(i),'_.*_s0[^4].csv')));
        temp_files = temp_files(filtered);
        temp_files = strcat('parameters/', people{j}, '/', temp_files);
        files = {files{:} temp_files{:}};
    end
    [A, means, vars] = trainHMM(files,8,6,1);
    models(i+1).A = A;
    models(i+1).means = means;
    models(i+1).vars = vars;
end
clear  i j files temp_files filtered people A means vars

test = csvread('parameters/0001_ZJD/c6_p0001_s00.csv');
test = test(:,1);
pstc = -Inf;
index = -1;
for i = 1:length(models)
    [~, pst] = computeViterbi(test, models(i).A, models(i).means, models(i).vars, 8, 1);
    if pstc < pst
        pstc = pst;
        index = i - 1;
    end
end