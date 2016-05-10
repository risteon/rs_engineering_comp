load('../../Material/Signal2.mat')

prefix_len = 16;
symbol_len = 64;
unused_carr = [1, 2, 3, 4, 33, 62, 63, 64];
mod_scheme = 8;
pilot = 'A';


%% nothing to change here
window_len = prefix_len + symbol_len;
n_symbols = length(Signal)/window_len;

sig = [];
% cut out cp
for i = 1:n_symbols
    sig = [sig Signal((i-1)*window_len+prefix_len+1-16:...
            i*window_len-16)];
end

% create matrix with OFDM symbol in every column
sig = reshape(sig, symbol_len, []);

fft_sig = fftshift(fft(sig));
% delete unused carriers
fft_sig(unused_carr,:) = [];

H=fft_sig(:,1:2:end);

%simple channel correction
fft_sig(:,2:2:end) =fft_sig(:,2:2:end)./H


if pilot == 'A'
    % delete pilot symbols
    fft_sig(:,1:2:size(fft_sig,2)) = [];
elseif pilot == 'B'
    %TODO
end
plot(reshape(fft_sig,[],1),'*');

% psk demodulation
syms = pskdemod(fft_sig, mod_scheme,1*pi/4);
ascii_decoding(syms, mod_scheme)
