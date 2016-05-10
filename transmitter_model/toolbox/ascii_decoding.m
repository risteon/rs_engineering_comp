function [ text ] = ascii_decoding( syms )
%ASCII_DECODING Do ascii decoding
%   syms: bitstring

% group into bytes
syms = reshape(syms, 8, []).';
% ascii decoding
text = char(bin2dec(syms))';

%TODO: remove whitespace at the end

end

