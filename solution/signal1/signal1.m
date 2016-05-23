load('../../material/Signal1.mat');

symbol_len = 64;
prefix_len = 16;
mod_scheme = 4;
pilot = 'A';

%% nothing to change here
addpath('../../toolbox')

% cut out cyclic prefix
sig = cut_cp(Signal, prefix_len);

% create matrix with OFDM symbol in every column
sig = reshape(sig, symbol_len, []);

% remove pilot symbols/carriers
sig = remove_pilot(sig, 'A', symbol_len);

% fftshift
fft_sig = fftshift(fft(sig),1);

% delete unused carriers
fft_sig = remove_unused(fft_sig, symbol_len);

% psk demodulation
syms = psk2bitstring(fft_sig, mod_scheme);

% ascii decoding
text = ascii_decoding(syms);
