function [ output_tx ] = cyclic_prefix_adding( input_a )
%CYCLIC_PREFIX_ADDING Summary of this function goes here
%   Detailed explanation goes here

% task description: The length N_cp of the cyclic prefix is equal to one
% quarter of the length N_nfft of the inverse Fourier transform:
num_rows = size(input_a, 1);
assert(~mod(num_rows, 4), 'Cyclic prefix: ifft length is no multiple of 4!');
n_cp = num_rows / 4;

output_tx = [input_a(end-n_cp+1:end, :); input_a] ; 
output_tx = reshape(output_tx, 1, []);

end