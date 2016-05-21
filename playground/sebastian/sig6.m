addpath('../../toolbox');
load('../../material/Signal6');
clf

pilot = 'B';
prefix_len = 32;
symbol_len = 4*prefix_len;

sig = resample(Signal, 1,1);
plot(abs(sig))
sig = sig(19:end);
%freq_off = freq_offset_est_DC(sig, symbol_len);
freq_off = 0;
sig = sig .* exp(-1j*2*pi*freq_off/symbol_len*(1:size(sig,2)));

fft_sig = shape_ofdm(sig, symbol_len, prefix_len);



%plot pilot phases
plot(angle(fft_sig(6,:)));
hold on
plot(angle(fft_sig(13,:)));
plot(angle(fft_sig(21,:)));
plot(angle(fft_sig(29,:)));
hold off
H=channel_estimation_methB_2DInterpolation(fft_sig,symbol_len,'linear');
H(:,end)=fft_sig(:,end-1);
    
fft_sig=fft_sig./H;
%plot(abs(fft_sig(5,:)));

fft_sig = remove_unused(fft_sig, symbol_len);
fft_sig = remove_pilot(fft_sig, pilot, symbol_len);

% plot constellation
for i = 1:size(fft_sig,2)
    %plot(fft_sig(i,:),'*')
    %hold on
end
%plot(angle(fft_sig(5,:)));

syms = pskdemod(fft_sig, 2, 0);
text = ascii_decoding(syms, 8)