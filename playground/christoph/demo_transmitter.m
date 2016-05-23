%% Parameters
addpath('../../toolbox');
data = 'test test test test test test test34';
%   const_points: number of psk points (2, 4 or 8)
psk_points = 4;
%   pilot_method: 'A' or 'B'
pilot_method = 'A';
%   fft_len 32, 64, 128
fft_len = 64;

%% TX/RX signal

tx = signal_generator(data, psk_points, fft_len, pilot_method);

% no channel
rx = tx;

%% Demodulation

%do ofdm operations
fft_sig = shape_ofdm(rx, fft_len, fft_len/4);

%compensate resulting phase drift from offset
%drehvector = 2j*pi*offset/fft_len*(0:fft_len-1).';
%fft_sig = fft_sig .* repmat(exp(drehvector),1,size(fft_sig,2));

%channel estimation
%H = channel_estimation_methB_2DInterpolation(fft_sig, symbol_len,'linear');
%H = 1;

%channel correction with H
%fft_sig = fft_sig./H;

%delete unused carriers and pilots
fft_sig = remove_unused(fft_sig, fft_len);
fft_sig = remove_pilot(fft_sig, pilot_method, fft_len);

% psk demodulation
syms = psk2bitstring(fft_sig, psk_points);

received_text = ascii_decoding(syms);