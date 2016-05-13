load('../../Material/Signal3.mat');

prefix_len = 16;
mod_scheme = 4;
pilot = 'B';

%% nothing to change here
addpath('../../toolbox')
symbol_len = 4*prefix_len;

fft_sig = shape_ofdm(Signal, symbol_len, prefix_len);

%channel estimation
H = channel_estimation_methB_2DInterpolation(fft_sig, symbol_len,'linear');

%channel correction with H
fft_sig = fft_sig.*conj(H)./((abs(H)).^2);

%delete unused carriers and pilots
fft_sig([5 13 21 29 37 45 53 61 1 2 3 4 33 62 63 64],:)=[];

%plot(reshape(fft_sig,[],1),'*');

% psk demodulation
syms = pskdemod(fft_sig, mod_scheme,1*pi/4);
ascii_decoding(syms, mod_scheme)

% result is kenny speech: http://www.namesuppressed.com/kenny/
% results to "Von A nach B schneller denn je. LX138"
