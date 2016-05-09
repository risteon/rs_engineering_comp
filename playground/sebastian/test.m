n_symbols = length(Signal)/80

sig = []
for i = 1:n_symbols
    sig = [sig Signal((i-1)*80+16:(i-1)*80+80)];
end
fft_sig = fft(sig);
fft_sig = reshape(fft_sig, n_symbols, [])