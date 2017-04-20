clear *
close all
clc

person = '0001_ZJD/';
path = strcat('records/', person);
pathParam = strcat('parameters/', person);

ref = struct();

e_only = 0;
euclid = 0;
mahal = 0;
tic
for i = 0:4
    files = dir(strcat(pathParam, '*_s0', int2str(i), '.csv'));
    files = {files.name};
    for j = 1:10
        ref(j).data = csvread(strcat(pathParam, cell2mat(files(j))));
    end
    
    for j = 1:10
        for k = 0:4
            if (k ~= i)
                params_x = parameterSpec(strcat(path, 'c', int2str(j-1), '_p', person(1:4), '_s0', int2str(k), '.wav'));
                minimum_e = Inf;
                index_e = -1;
                
                minimum_z = Inf;
                index_z = -1;
                
                minimum_eu = Inf;
                index_eu = -1;
                
                minimum_m = Inf;
                index_m = -1;
                for l = 1:10
                    [vzd] = computeDTWopt(params_x,ref(l).data, 1, @computeEuclidDist);
                    if(minimum_e > vzd)
                        minimum_e = vzd;
                        index_e = l;
                    end

                    [vzd] = computeDTWopt(params_x,ref(l).data, 1:size(params_x,2), @computeEuclidDist);
                    if(minimum_eu > vzd)
                        minimum_eu = vzd;
                        index_eu = l;
                    end

                    [vzd] = computeDTWopt(params_x,ref(l).data, 1:size(params_x,2), @computeMahalDist);
                    if(minimum_m > vzd)
                        minimum_m = vzd;
                        index_m = l;
                    end
                end
                if (index_e == j) 
                    e_only = e_only + 1;
                end
                if (index_eu == j) 
                    euclid = euclid + 1;
                end
                if (index_m == j) 
                    mahal = mahal + 1;
                end
            end
        end
    end
end
toc
output = strcat('Energy only: ', num2str(e_only*0.5), '%');
disp(output)
output = strcat('Euclid: ', num2str(euclid*0.5), '%');
disp(output)
output = strcat('Mahal: ', num2str(mahal*0.5), '%');
disp(output)

clear *