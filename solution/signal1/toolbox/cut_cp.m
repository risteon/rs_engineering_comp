function [ out_sig ] = cut_cp( in_sig, cp_len )
%CUT_CP cuts cyclic prefix of length cp_len out of signal
%   in_sig:     input signal vector. Sample 1 is the first CP of the first
%               OFDM Symbol.
%   cp_len:     cyclic prefix length in samples
%   out_sig:    signal vector without cyclic prefix

% calculate number of OFDM symbols in signal
n_symbols = length(in_sig)/5/cp_len;

out_sig = [];
% cut out cp
for i = 1:n_symbols
    out_sig = [out_sig in_sig((i-1)*5*cp_len+cp_len+1:...
            i*5*cp_len)];
end


end

