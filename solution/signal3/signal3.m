load('../../Material/Signal3.mat');
addpath('../../toolbox')

prefix_len = 16;
mod_scheme = 4;
pilot = 'B';
symbol_len = 64;
out_snr=[];
out_H_abs = [];

%calculate channel and SNR over 9 shifts to get mean value
for offset = 2:10
    time_sig=[zeros(1,offset) Signal(1:end-offset)];
    
    %do ofdm operations
    fft_sig = shape_ofdm(time_sig, symbol_len, prefix_len);
    
    %compensate resulting phase drift from offset
    drehvector = 2j*pi*offset/symbol_len*(0:symbol_len-1).';
    fft_sig = fftshift(ifftshift(fft_sig,1) .* repmat(exp(drehvector),1,size(fft_sig,2)),1);
    fft_sig_save = fft_sig;
    
    %channel estimation
    H = channel_estimation_methB_2DInterpolation(fft_sig, symbol_len,'linear');
    
    %channel correction with H
    fft_sig = fft_sig./H;
    
    %delete unused carriers and pilots
    fft_sig = remove_unused(fft_sig,symbol_len);
    fft_sig = remove_pilot(fft_sig, 'B', symbol_len);
    
    % psk demodulation
    syms = pskdemod(fft_sig, mod_scheme,1*pi/4);
    text = ascii_decoding(psk2bitstring(fft_sig, mod_scheme));
    
    % %re-modulate decoded signal
    ideal = pskmod(syms, mod_scheme, pi/4);
    ideal = carrier_mapping(ideal,symbol_len,'B');
    ideal = remove_unused(ideal,symbol_len);
    
    %%make a new channel estimation with all used carriers, also now known data
    %(data is used as pilots)
    H = channel_estimation_LS(remove_unused(fft_sig_save,symbol_len),ideal);    
    fft_sig=remove_unused(fft_sig_save,symbol_len)./H;
    
    % calculate channel
    H_abs = abs(H);
    H_abs = mean(H_abs.')';
    % plot(H_abs);
    
    % % calculate SNR
    fft_noise = fft_sig-ideal;
    fft_noise = reshape(fft_noise, 1, []);
    % plot(fft_noise, '*');
    p_noise = var(fft_noise);
    p_sig = 1;
    SIR = p_sig/p_noise;
    
    out_snr = [out_snr, SIR];
    out_H_abs=[out_H_abs, H_abs];
end

out_snr = mean(out_snr)
out_H_abs = mean(out_H_abs,2)
out_text = text
out_mod = 'QPSK'

% result is kenny speech: http://www.namesuppressed.com/kenny/
% results to "Von A nach B schneller denn je. LX138"
