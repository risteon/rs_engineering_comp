function [ out_sig ] = remove_pilot( in_sig, method, fft_len )
%REMOVE_PILOT Removes pilot symbols/carriers from signal
%   in_sig: input signal vector
%   method: pilot method A or B
%   out_sig: output signal vector without pilots

if (~exist('fft_len', 'var'))
    fft_len = true;
end
if method == 'A'
    % delete pilot symbols after removed unused carriers
    in_sig(:,1:2:size(in_sig,2)) = [];
elseif method == 'B'
    if fft_len == 32
        pilot_indixes = [1 10 17 26];
    elseif fft_len == 64
        pilot_indixes = [1 9 17 25 32 40 48 56]
    elseif fft_len == 128
        pilot_indixes = [1 8 16 24 32 40 48 56 63 71 79 87 95 103 111 118]
    end
    in_sig(pilot_indixes,:) = [];
end
out_sig = in_sig;
end

