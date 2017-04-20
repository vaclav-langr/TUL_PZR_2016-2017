function [ A, means, vars ] = trainHMM( parameter_files, states, iterations, parameters_selection )
A = zeros(2,states);

params = cell(length(parameter_files),1);
for i = 1:length(parameter_files)
    params{i} = csvread(parameter_files{i});
    params{i} = params{i}(:,parameters_selection);
end

[means, vars, n] = computeMeansVarsInit(params, states, parameters_selection);
A(2,:) = length(params) ./ n;
A(1,:) = 1 - A(2,:);

bounds = cell(length(parameter_files),1);
for i=1:iterations
    for j=1:length(params)
        bounds{j} = computeViterbiTrain(params{j}, A, means, vars, states, parameters_selection);
    end
    [means, vars, n] = computeMeansVars(params, states, parameters_selection, bounds);
    A(2,:) = length(params) ./ n;
    A(1,:) = 1 - A(2,:);
end
end

function [means, vars, n] = computeMeansVarsInit(params, number_states, parameters_selection)
means = zeros(number_states, length(parameters_selection));
vars = zeros(number_states, length(parameters_selection));
n = zeros(1,number_states);
% Prumery
for i = 1:length(params)
    bound = floor(0:size(params{i},1)/8:size(params{i},1));
    for j = 1:number_states
        n(j) = n(j) + bound(j+1) - bound(j);
        means(j,:) = means(j,:) + sum(params{i}(bound(j)+1:bound(j+1), :),1);
    end
end
for i = 1:length(parameters_selection)
    means(:,i) = means(:,i) ./ n';
end
% Rozptyly
for i = 1:length(params)
    bound = floor(0:size(params{i},1)/8:size(params{i},1));
    for j = 1:number_states
        vars(j,:) = vars(j,:) + sum(bsxfun(@minus,params{i}(bound(j)+1:bound(j+1), :),means(j,:)).^2,1);
    end
end
for i = 1:length(parameters_selection)
    vars(:,i) = vars(:,i) ./ n';
end
end

function [means, vars, n] = computeMeansVars(params, number_states, parameters_selection, bounds)
means = zeros(number_states, length(parameters_selection));
vars = zeros(number_states, length(parameters_selection));
n = zeros(1,number_states);

for i = 1:length(params)
    bound = bounds{i};
    for j = 1:number_states
        n(j) = n(j) + bound(j+1) - bound(j);
        means(j,:) = means(j,:) + sum(params{i}(bound(j)+1:bound(j+1), :),1);
    end
end
for i = 1:length(parameters_selection)
    means(:,i) = means(:,i) ./ n';
end
for i = 1:length(params)
    bound = bounds{i};
    for j = 1:number_states
        vars(j,:) = vars(j,:) + sum(bsxfun(@minus,params{i}(bound(j)+1:bound(j+1), :),means(j,:)).^2,1);
    end
end
for i = 1:length(parameters_selection)
    vars(:,i) = vars(:,i) ./ n';
end
end