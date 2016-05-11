function [ out_sig ] = shape_ofdm( in_sig, fft_len, cp_len )
%SHAPE_OFDM creates OFDM matrix of input signal
%   in_sig:     time input signal with cyclic prefix
%   fft_len:    number of total carriers
%   cp_len:     length of cyclic prefix in samples
%   out_sig:    output matrix in shape carriers x symbols

% cut cyclic prefix
out_sig = cut_cp(in_sig, cp_len);
% create matrix with OFDM symbol in every column
out_sig = reshape(out_sig, fft_len, []);
out_sig = fftshift(fft(out_sig),1);

end

