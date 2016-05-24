clear all

load('Results.mat');
run('signal2/signal2.m');
Results.Signal2.SNR = out_snr;
save('Results.mat', 'Results');

clear all
load('Results.mat');
run('signal3/signal3.m');
Results.Signal3.SNR = out_snr;
Results.Signal3.MagChannelTransferFunction = [0 0 0 0 out_H_abs(1:32)' 0 out_H_abs(33:end)' 0 0 0];
save('Results.mat', 'Results');

clear all
load('Results.mat');
run('signal4/signal4.m');
Results.Signal4.SNR = out_snr;
Results.Signal4.MagChannelTransferFunction = [0 0 0 0 out_H_abs(1:32)' 0 out_H_abs(33:end)' 0 0 0];
Results.NormalizedCarrierFrequencyOffset_fa = out_freq;
save('Results.mat', 'Results');
