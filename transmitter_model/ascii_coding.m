function [ b_n ] = ascii_coding( c_m )
%ASCII_CODING Summary of this function goes here
%   returns double vector of zeros and ones ascii coded

b_n = reshape(dec2bin(c_m, 8), 1, []);
b_n = b_n-'0';

end

