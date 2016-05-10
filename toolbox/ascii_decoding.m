function [ text ] = ascii_decoding( syms, mod_scheme )
%ASCII_DECODING Do ascii decoding
%   syms: bitstring
%   mod_scheme: modulation order

% convert int < log2(mod_scheme) to binary
syms = dec2bin(syms, log2(mod_scheme))';
% group into bytes
syms = reshape(syms, 8, []).';
% ascii decoding
text = char(bin2dec(syms))';

%TODO: remove whitespace at the end

end

