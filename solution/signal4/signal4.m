%% Parameter
clear all;

pilot_method = 'A';
fft_len = 64;
load('../../Material/Signal4.mat');  % Variable 'Signal'
out_snr=[];
out_H_abs = [];
out_freq = [];

tx_in = Signal;

%% timing offset estimation and compensation
offset = t_sync_pilot_A(tx_in,fft_len);

% apply offset
tx_in = [tx_in(offset+1:end)];

%% Frequency offset estimate and compensation

eps = freq_offset_est_DC(tx_in, fft_len);
sample_count = size(tx_in, 2);
eps_compensation = exp(-1i* 2*pi*eps*(1:sample_count));

tx_in = tx_in .* eps_compensation;
plot(abs(tx_in))
freq_offset_est_DC(tx_in, fft_len);

pilots = tx_in(17:end);
pilots = pilots(1:160:end);
plot(unwrap(angle(pilots)))
% return

%% Demod

prefix_len = 16;
mod_scheme = 2;
pilot = 'A';
symbol_len = 64;

%% without the offset the channel estimation is crap, value by trial and
% error, why better??????
for offset = 4:10
    time_sig=[zeros(1,offset) tx_in(1:end-offset)];
    
    %do ofdm operations
    fft_sig = shape_ofdm(time_sig, symbol_len, prefix_len);
    
    %compensate resulting phase drift from offset
    drehvector = 2j*pi*offset/64*(0:63).';
    fft_sig = fftshift(ifftshift(fft_sig,1) .* repmat(exp(drehvector),1,size(fft_sig,2)),1);
    
    fft_sig_save = fft_sig;
    
    %% simple channel estimation and correction
    H = fft_sig(:,1:2:end);
    H = repmat(H,2,1);
    H = reshape(H, 64 ,[]);
    
    H=channel_estimation_methA_2DInterpolation(fft_sig,64,'linear');
    H(:,end)=fft_sig(:,end-1);
    
    fft_sig=fft_sig./H;
    
    fft_sig = remove_unused(fft_sig, symbol_len);
    fft_sig_no_pilot = remove_pilot(fft_sig, 'A', symbol_len);
    
    plot(fft_sig_no_pilot,'*');
    axis([-1.5,1.5,-1.5,1.5])
    
    %% psk demodulation
    syms = pskdemod(fft_sig_no_pilot, mod_scheme,0);
    text= ascii_decoding(psk2bitstring(fft_sig, mod_scheme));
    
    %% re-modulate decoded signal
    ideal = pskmod(syms, mod_scheme, 0);
    ideal = carrier_mapping(ideal,fft_len,'A');
    ideal = remove_unused(ideal,fft_len);
    
    %% make a new channel estimate using all used carriers
    H_abs = remove_unused(fft_sig_save,fft_len) ./ideal;
    H_abs = abs(H_abs);
    H_abs = mean(H_abs,2);
    
    
    %% calculate SNR
    fft_noise = fft_sig-ideal;
    fft_noise = reshape(fft_noise, 1, []);
    % plot(fft_noise, '*');
    p_noise = var(fft_noise);
    p_sig = 1;
    SIR = p_sig/p_noise;
        
    out_snr = [out_snr, SIR];
    out_H_abs=[out_H_abs, H_abs];
    out_freq = [out_freq, eps];
end

out_freq = mean(out_freq)
out_snr = mean(out_snr)
out_H_abs = mean(out_H_abs,2)
out_text = text
out_mod = 'BPSK'



