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
% convert int < log2(mod_scheme) to binary
syms = dec2bin(syms, log2(mod_scheme))';
% group into bytes
syms = reshape(syms, 8, []).';
% ascii decoding
text = char(bin2dec(syms))'
