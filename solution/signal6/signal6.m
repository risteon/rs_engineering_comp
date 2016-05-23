addpath('../../toolbox');
load('../../Material/Signal6');
clf

pilot_meth = 'B';
fft_len = 32;
prefix_len = fft_len/4;
mod_scheme = 4;

shift = 44;

sig = Signal;

%cut_out = sig(1+shift:shift+128 + 32);

%[t, lags] = xcorr(cut_out);
%[~, idx] = max(t);

%lags(idx)

%plot(abs(xcorr(cut_out)));
%plot(abs(cut_out));
%return

%TODO: timing estimate
sig = sig(1+shift:end);

% equalize transmitter sampling period
sig = resample(sig, 1, 128/fft_len);

%plot(abs(sig));

%TODO: Sampling frequency offset
sig = resample(sig, 40000,40000);

%freq estimate
eps = freq_offset_est_DC(sig, fft_len);
sig = sig .* exp(-1j*eps*2*pi*(1:size(sig,2)));


fft_sig = shape_ofdm(sig, fft_len, prefix_len);

fft_sig_save = fft_sig;
%plot(abs(fft_sig_save));
%return

%channel estimation
H = channel_estimation_methB_2DInterpolation(fft_sig, fft_len ,'linear');
fft_sig=fft_sig./H;
%plot(abs(fft_sig));

fft_sig = remove_unused(fft_sig, fft_len);
fft_sig = remove_pilot(fft_sig, pilot_meth, fft_len);

% plot constellation
plot(reshape(fft_sig,[],1),'*')

%demod
syms = pskdemod(fft_sig, mod_scheme, pi/4);
text = ascii_decoding(psk2bitstring(fft_sig, mod_scheme)) %#ok<NOPTS>

%remodulate
ideal = pskmod(syms, mod_scheme);
ideal = carrier_mapping(ideal,fft_len,pilot_meth);
ideal = remove_unused(ideal,fft_len);

%%mean channel
H_abs = abs(H);
H_abs = mean(H_abs,2);

fft_sig = remove_unused(fft_sig_save./H,fft_len);


%% calculate SNR
fft_noise = fft_sig - ideal;
fft_noise = reshape(fft_noise, 1, []);
% plot(fft_noise, '*');
p_noise = var(fft_noise);
p_sig = 1;
SIR = p_sig/p_noise;
