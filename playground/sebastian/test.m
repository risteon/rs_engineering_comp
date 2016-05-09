prefix_len = 16;
symbol_len = 64;
unused_carr = [1, 2, 3, 4, 32, 62, 63, 64];
mod_scheme = 4;
pilot = 'A';


%% nothing to change here
window_len = prefix_len + symbol_len;
n_symbols = length(Signal)/window_len;

sig = [];
% cut out cp
for i = 1:n_symbols
    sig = [sig Signal((i-1)*window_len+prefix_len+1:...
            i*window_len)];
end

% create matrix with OFDM symbol in every column
sig = reshape(sig, symbol_len, []);

if pilot == 'A'
    % delete pilot symbols
    sig(:,1:2:size(sig,2)) = [];
end

fft_sig = fftshift(fft(sig));
% delete unused carriers
fft_sig(unused_carr,:) = [];

syms = pskdemod(fft_sig, mod_scheme, pi/mod_scheme);
syms = dec2bin(syms, log2(mod_scheme))';
syms = reshape(syms, 8, []).';
text = char(bin2dec(syms))'
