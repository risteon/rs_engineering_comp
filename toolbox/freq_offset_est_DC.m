function [ freq_offset ] = freq_offset_est_DC( sig, fft_len )
%FREQ_OFFSET_EST_DC calculates a estimation of the freqency offset
%   The frequency offset is calculated using the DC Carrier in the middle
%   of the spectrum. To find a clearly minimum, the signal is zero padded
%   before FFT. The signal has to be time synced (beginning with the first
%   sample of the first ofdm symbol)

fft_len_padded = 2^18;
frame_len = fft_len /4*5;
current_sample = 1;
sample_count = size(sig, 2);
f = zeros(1, fft_len_padded);
win_faktor = 8;
window = -fft_len_padded/win_faktor:+fft_len_padded/win_faktor;
window = window + fft_len_padded/2;
pos = [];

while current_sample + frame_len < sample_count
    %one ofdm symbol (shifted)
    r = sig(current_sample+5:current_sample+frame_len-1-11);
    f = fft(r,fft_len_padded);
    current_sample = current_sample + frame_len;
    
    f=abs(fftshift(f));
   plot(f);
    [m, p] = min(f(window));
    pos = [pos p];
end
pos = mean(pos);
assert(length(pos) == 1);
freq_offset = (pos+fft_len_padded/2-fft_len_padded/win_faktor)/fft_len_padded;
freq_offset = (freq_offset-1/2);

end
