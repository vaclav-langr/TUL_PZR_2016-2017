function [success, total] = testHMM(exclude, show_info)
models = struct([]);
people = dir('parameters/*_*/');
people = {people.name;};
for i = 0:9
    files = {};
    for j = 1:length(people)
        temp_files = dir(strcat('parameters/', people{j}, '/c*'));
        temp_files = {temp_files.name;};
        filtered = ~cellfun('isempty',regexp(temp_files, strcat('c',int2str(i),'_.*_s0[^',int2str(exclude),'].csv')));
        temp_files = temp_files(filtered);
        temp_files = strcat('parameters/', people{j}, '/', temp_files);
        files = {files{:} temp_files{:}};
    end
    [A, means, vars] = trainHMM(files,8,6,1:34);
    models(i+1).A = A;
    models(i+1).means = means;
    models(i+1).vars = vars;
end

success = 0;
total = 0;
for i = 0:9
    files = {};
    for j = 1:length(people)
        temp_files = dir(strcat('records/', people{j}, '/c*'));
        temp_files = {temp_files.name;};
        filtered = ~cellfun('isempty',regexp(temp_files, strcat('c',int2str(i),'_.*_s0',int2str(exclude),'.wav')));
        temp_files = temp_files(filtered);
        temp_files = strcat('records/', people{j}, '/', temp_files);
        files = {files{:} temp_files{:}};
    end
    for j = 1:length(files)
        pstc = -Inf;
        index = -1;
        total = total + 1;
        test = parameterSpec(files{j});
        for k = 1:length(models)
            pst = computeViterbiTest(test, models(k).A, models(k).means, models(k).vars, 8, 1:34);
            if pstc < pst
                pstc = pst;
                index = k - 1;
            end
        end
        if index == i
            success = success + 1;
        elseif show_info
            disp(strcat('Skutecne hodnota: ', int2str(i), ', zjistena hodnota: ', int2str(index), ', clovek: ', files{j}))
        end
    end
end
if show_info
disp(strcat('Testovanych souboru: ', int2str(total), ', celkova uspesnost: ', num2str(100 * success / total), '%'));
disp('');
end
end