                           %% ST
                        
% Proyect: Keyboard sounds recognition.

%% This script is aiming to split in different wav. files
%  a larger one.
clear all; close all; clc;

%%
[audio,fm] = audioread('A.wav');
figure
plot(audio)
audio_list = {};
keypress_duration = 0.25*fm; % Duration in number of samples (250ms)
push_peak = 0.04*fm; % Duration in number of samples (40ms)
i = 1;
j = 1;
while i<length(audio)
    if audio(i)>0.01
        audio_list{j} = audio(i-150:i+push_peak,1);
        j = j+1;
        i = i+keypress_duration;
    else
        i=i+1;
    end
end

for i = 1:numel(audio_list)
    filename=['A' num2str(i) '.wav'];
    audiowrite(filename, audio_list{i}, fm);
end

%% Generate plots
%
plot(audio_list{1});
for i = 1:numel(audio_list)
plot(audio_list{i})
sound(audio_list{i},fm);
pause(1)
end
%}
