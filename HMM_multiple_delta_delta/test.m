clear *
close all
clc

tic
success = 0;
total = 0;
for i = 0:4
    [s, t] = testHMM(i, true);
    success = success + s;
    total = total + t;
end
toc

disp(strcat('Pocet testu: ', num2str(total)))
disp(strcat('Celkova uspesnost: ', num2str(100*success/total), '%'))