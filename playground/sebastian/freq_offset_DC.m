addpath('../../toolbox');
load('../../material/Signal4.mat');

cp_len = 16;
symbol_len = 5*cp_len;
phase = [];
bw = 1500;

for symbol = 1:63

% cut out current OFDM symbol
sig = Signal(symbol*symbol_len+1:(symbol+1)*symbol_len);

% zero pad
sig = [sig zeros(1,65456)];

% fft calc
fft_sig = abs(fftshift(fft(sig)));
%plot(axe,fft_sig)

% window over 2000 samples in middle of spectrum
window_axe = -bw:bw;
window = fft_sig(2^16/2-bw:2^16/2+bw);
plot(window_axe, window)

% find minimum near DC and append
phase = [phase window_axe(find(min(window) == window))/2^16];

end

phase = mean(phase)

%pilots = Signal(17:end);
%pilots = pilots(1:160:end);
%plot(angle(pilots))

tx_in = Signal .* exp(-1i*phase*(1:size(Signal,2)));

pilots = tx_in(17:end);
pilots = pilots(1:160:end);
plot(angle(pilots))