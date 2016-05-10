load('../../Material/Signal2.mat')

prefix_len = 16;
mod_scheme = 8;
pilot = 'A';


%% nothing to change here
addpath('../../toolbox')
symbol_len = 4*prefix_len;

fft_sig = shape_ofdm(Signal, symbol_len, prefix_len);

% delete unused carriers
fft_sig = remove_unused(fft_sig, symbol_len);

H=fft_sig(:,1:2:end);

%simple channel correction
fft_sig(:,2:2:end) = fft_sig(:,2:2:end)./conj(H);

fft_sig = remove_pilot(fft_sig, 'A', symbol_len);

plot(reshape(fft_sig,[],1),'*');

% psk demodulation
syms = pskdemod(fft_sig, mod_scheme,0*pi/4);
ascii_decoding(syms, mod_scheme)
