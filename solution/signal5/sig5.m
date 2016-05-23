addpath('../../toolbox');
load('../../Material/Signal5');
clf

pilot_meth = 'B';
prefix_len = 16;
fft_len = 4*prefix_len;
mod_scheme=8;

sig=Signal;

%TODO: estimate
sig = resample(sig, 40007,40000);

%freq estimate
eps = freq_offset_est_DC(sig(19:end), 64);
sig = sig .* exp(-1j*eps*2*pi*(1:size(sig,2)));

%TODO: timing estimate
sig = sig(19:end);

fft_sig = shape_ofdm(sig, fft_len, prefix_len);

fft_sig_save = fft_sig;

%channel estimation
H = channel_estimation_methB_2DInterpolation(fft_sig,64,'linear');
fft_sig=fft_sig./H;
%plot(abs(fft_sig(5,:)));

fft_sig = remove_unused(fft_sig, fft_len);
fft_sig = remove_pilot(fft_sig, pilot_meth, fft_len);

% plot constellation
plot(reshape(fft_sig,[],1),'*')

%demod
syms = pskdemod(fft_sig, mod_scheme, 0);
text = ascii_decoding(psk2bitstring(fft_sig, mod_scheme))

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


%% text decoding
hex = ['42';'3a';'20';'57';'65';'6c';'6c';'2c';'20';'49';'27';'6d';'20';'67';'6f';'6e';'6e';'61';'20';'67';'65';'74';'20';'6f';'75';'74';'20';'6f';'66';'20';'62';'65';'64';'20';'65';'76';'65';'72';'79';'20';'6d';'6f';'72';'6e';'69';'6e';'67';'2e';'2e';'2e';'20';'62';'72';'65';'61';'74';'68';'65';'20';'69';'6e';'20';'61';'6e';'64';'20';'6f';'75';'74';'20';'61';'6c';'6c';'20';'64';'61';'79';'20';'6c';'6f';'6e';'67';'2e';'20';'54';'68';'65';'6e';'2c';'20';'61';'66';'74';'65';'72';'20';'61';'20';'77';'68';'69';'6c';'65';'20';'49';'20';'77';'6f';'6e';'27';'74';'20';'68';'61';'76';'65';'20';'74';'6f';'20';'72';'65';'6d';'69';'6e';'64';'20';'6d';'79';'73';'65';'6c';'66';'20';'74';'6f';'20';'67';'65';'74';'20';'6f';'75';'74';'20';'6f';'66';'20';'62';'65';'64';'20';'65';'76';'65';'72';'79';'20';'6d';'6f';'72';'6e';'69';'6e';'67';'20';'61';'6e';'64';'20';'62';'72';'65';'61';'74';'68';'65';'20';'69';'6e';'20';'61';'6e';'64';'20';'6f';'75';'74';'2e';'2e';'2e';'20';'61';'6e';'64';'2c';'20';'74';'68';'65';'6e';'20';'61';'66';'74';'65';'72';'20';'61';'20';'77';'68';'69';'6c';'65';'2c';'20';'49';'20';'77';'6f';'6e';'27';'74';'20';'68';'61';'76';'65';'20';'74';'6f';'20';'74';'68';'69';'6e';'6b';'20';'61';'62';'6f';'75';'74';'20';'68';'6f';'77';'20';'49';'20';'68';'61';'64';'20';'69';'74';'20';'67';'72';'65';'61';'74';'20';'61';'6e';'64';'20';'70';'65';'72';'66';'65';'63';'74';'20';'66';'6f';'72';'20';'61';'20';'77';'68';'69';'6c';'65';'2e'];
hex = reshape(hex,[],2);
hex = hex2dec(hex);
text2 = char(hex)'