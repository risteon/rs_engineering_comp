load('../../Material/Signal3.mat');

prefix_len = 16;
mod_scheme = 4;
pilot = 'B';

%% nothing to change here
addpath('../../toolbox')
symbol_len = 4*prefix_len;

%without the offset the channel estimation is crap, value by trial and
%error, why better?????? ISI?
offset = 8;
time_sig=[zeros(1,offset) Signal(1:end-offset)];

%do ofdm operations
fft_sig = shape_ofdm(time_sig, symbol_len, prefix_len);

%compensate resulting phase drift from offset
drehvector = 2j*pi*offset/64*(0:63).';
fft_sig = fft_sig .* repmat(exp(drehvector),1,size(fft_sig,2));
fft_sig_save = fft_sig;

%channel estimation
H = channel_estimation_methB_2DInterpolation(fft_sig, symbol_len,'linear');

%channel correction with H
fft_sig = fft_sig./H;

%delete unused carriers and pilots
fft_sig = remove_unused(fft_sig,64);
fft_sig = remove_pilot(fft_sig, 'B', 64);



% psk demodulation
syms = pskdemod(fft_sig, mod_scheme,1*pi/4);
ascii_decoding(syms, mod_scheme)

% %re-modulate decoded signal
ideal = pskmod(syms, mod_scheme, pi/4);
ideal = carrier_mapping(ideal,64,'B');
ideal = remove_unused(ideal,64);

%%make a new channel estimation with all used carriers, also now known data
%(data is used as pilots)
H_all = remove_unused(fft_sig_save,64) ./ ideal;
H_all = sum(H_all, 2)/size(ideal,2);    %assume constant channel
H_all = repmat(H_all,1,size(ideal,2));
fft_sig=remove_unused(fft_sig_save,64)./H_all;
H=H_all;


% calculate channel
H_abs = abs(H);
H_abs = mean(H_abs.')';

% % calculate SNR
fft_noise = fft_sig-ideal;
fft_noise = reshape(fft_noise, 1, []);
% plot(fft_noise, '*');
p_noise = var(fft_noise)
p_sig = 1;
SIR = p_sig/p_noise


% result is kenny speech: http://www.namesuppressed.com/kenny/
% results to "Von A nach B schneller denn je. LX138"
