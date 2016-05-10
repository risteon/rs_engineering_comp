function [ out_sig ] = remove_unused( in_sig, fft_len )
%REMOVE_UNUSED removes unused carriers from OFDM matrix
%   in_sig:     input signal vector
%   fft_len:    number of carriers (total)
%   out_sig:    output signal vector without unused carriers

if fft_len == 32
    unused_carr = [1, 2, 3, 17, 31, 32];
elseif fft_len == 64
    unused_carr = [1, 2, 3, 4, 33, 62, 63, 64];
elseif fft_len == 128
    unused_carr = [1, 2, 3, 4, 5, 65, 125, 126, 127, 128];
end
in_sig(unused_carr,:) = [];
out_sig = in_sig;
    
end

