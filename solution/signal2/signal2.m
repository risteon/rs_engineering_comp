load('../../Material/Signal2.mat')
addpath('../../toolbox')

prefix_len = 16;
mod_scheme = 8;
pilot = 'A';
symbol_len = 64;
out_snr=[];
out_H_abs = [];

%without the offset the channel estimation is crap, 
%why better?? next ofdm symbol interfers??
%average of the signal processing for several valid offsets
for offset = 2:12
    time_sig=[zeros(1,offset) Signal(1:end-offset)];
    
    %do ofdm operations
    fft_sig = shape_ofdm(time_sig, symbol_len, prefix_len);
    
    %compensate resulting phase drift from offset
    drehvector = +2j*pi*offset/64*(0:63).';
    fft_sig = fftshift(ifftshift(fft_sig,1) .* repmat(exp(drehvector),1,size(fft_sig,2)),1);
    
    fft_sig_save = fft_sig;
    
    %% first channel estimation and correction
    H = channel_estimation_methA_simple(fft_sig);
    fft_sig = fft_sig.*conj(H)./(abs(H).^2);
    fft_sig = remove_unused(fft_sig, symbol_len);
    fft_sig = remove_pilot(fft_sig, 'A', symbol_len);
    
    %plot(reshape(fft_sig,[],1),'*');
    
    %% psk demodulation
    syms = pskdemod(fft_sig, mod_scheme,0);
    text = ascii_decoding(syms, mod_scheme);
    
    
    %% re-modulate decoded signal
    ideal = pskmod(syms, mod_scheme);
    ideal = carrier_mapping(ideal,64,'A');
    ideal = remove_unused(ideal,64);
    
    
    %% new channel estimation with all used carriers, also now known data
    % (data is used as pilots)
    % assumed constant channel
    % this should be the mean LS estimation (?)
    H = remove_unused(fft_sig_save,64) ./ ideal;
    H = sum(H, 2)/size(ideal,2);
    H = repmat(H,1,size(ideal,2));
    fft_sig=remove_unused(fft_sig_save,64)./H;
    
    
    %% calculate channel
    H_abs = abs(H);
    H_abs = mean(H_abs.')';
    
    %% calculate SNR
    fft_noise = fft_sig-ideal;
    fft_noise = reshape(fft_noise, 1, []);
    % plot(fft_noise, '*');
    p_noise = var(fft_noise)
    p_sig = 1;
    SIR = p_sig/p_noise
    
    %%save output
    out_snr = [out_snr, SIR];
    out_H_abs=[out_H_abs, H_abs];
end


out_snr = mean(out_snr)
out_H_abs = mean(out_H_abs,2)
out_text = text
out_mod = '8PSK'









