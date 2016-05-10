function [ out_sig ] = remove_pilot( in_sig, method, fft_len )
%REMOVE_PILOT Removes pilot symbols/carriers from signal
%   in_sig: input signal vector
%   method: pilot method A or B
%   out_sig: output signal vector without pilots

if (~exist('fft_len', 'var'))
    fft_len = true;
end
if method == 'A'
    % delete pilot symbols in every odd column
    in_sig(:,1:2:size(in_sig,2)) = [];
elseif method == 'B'
    if fft_len == 32
        pilot_indixes = [4 13 21 30];
    elseif fft_len == 64
        pilot_indixes = [5 13 21 29 37 45 53 61]
    elseif fft_len == 128
        pilot_indixes = [6 13 21 29 37 45 53 61 69 77 85 93 101 109 117 124]
    end
    in_sig(pilot_indixes,:) = [];
end
out_sig = in_sig;
end

