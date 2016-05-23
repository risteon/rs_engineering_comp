function [ bitstring ] = psk2bitstring( fft_sig, psk_points )
%PSK2BITSTRING Summary of this function goes here
%   Detailed explanation goes here

% psk demodulation
ini_phase = 0;
if psk_points == 4
    ini_phase = pi/4;
end
fft_sig = pskdemod(fft_sig, psk_points, ini_phase);

% convert int < log2(mod_scheme) to binary
bitstring = reshape(dec2bin(fft_sig, log2(psk_points))', 1, []) - '0';

end

