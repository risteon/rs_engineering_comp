load('Signal1.mat');

prefix_len = 16;
symbol_len = 64;
mod_scheme = 4;
pilot = 'A';

%% nothing to change here
addpath('toolbox')
window_len = prefix_len + symbol_len;
n_symbols = length(Signal)/window_len;

% cut out cyclic prefix
sig = cut_cp(Signal, prefix_len);

% create matrix with OFDM symbol in every column
sig = reshape(sig, symbol_len, []);

% remove pilot symbols/carriers
sig = remove_pilot(sig, 'A', symbol_len);

% fftshift
fft_sig = fftshift(fft(sig));

% delete unused carriers
fft_sig = remove_unused(fft_sig, symbol_len);

% psk demodulation
syms = pskdemod(fft_sig, mod_scheme, pi/mod_scheme);

% ascii decoding
text = ascii_decoding(syms, mod_scheme)
