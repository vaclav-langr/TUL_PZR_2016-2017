function [ p ] = parameter( record_name )
[sig, fs] = audioread(record_name, 'native');

frame_length_ms = 25;
next_frame_ms = 10;
frame_length_sample = frame_length_ms * fs * 0.001;
next_frame_sample = next_frame_ms * fs * 0.001;

noise = rand(size(sig));
noise(noise <= 0.5) = -1;
noise(noise > 0.5) = 1;
sig = double(sig) + noise;

sig = filter([1 -0.97], 1, sig);

mat = zeros(ceil(length(sig)/next_frame_sample), frame_length_sample);
for i = 1:ceil(length(sig)/next_frame_sample)
    if((i-1)*next_frame_sample+frame_length_sample < length(sig))
        mat(i,1:end) = sig((i-1)*next_frame_sample+1:(i-1)*next_frame_sample+frame_length_sample);
    else
        samples = length(sig) - (i-1)*next_frame_sample;
        mat(i,1:samples) = sig((i-1)*next_frame_sample+1:(i-1)*next_frame_sample+samples);
    end
end

p = zeros(size(mat,1), 2);
p(:, 1) = log(sum(mat.*mat,2));
p(:, 2) = 0.5 * sum(abs(sign(mat(:,2:end)) - sign(mat(:,1:end-1))),2);

params_sort = sort(p(:,1));
minimal = sum(params_sort(1:10))/10;
maximal = sum(params_sort(end:-1:end-10))/10;
threshold = minimal + (maximal - minimal) * 0.25;

word_start = find(p(:,1) > threshold,1);
word_end = size(p,1) - find(p(end:-1:1,1) > threshold,1);

p = p(word_start:word_end, :);
end