function [ text ] = ascii_decoding( syms )
%ASCII_DECODING Do ascii decoding
%   syms: bitstring
syms = char(syms + '0');
% group into bytes
syms = reshape(syms, 8, []).';
% ascii decoding
text = char(bin2dec(syms))';

% remove leading and trailing whitespace
text = strtrim(text);

end

