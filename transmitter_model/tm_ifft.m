function [ output_a ] = tm_ifft( input_A )
%IFFT Summary of this function goes here

%   see: http://de.mathworks.com/matlabcentral/newsreader/view_thread/285244
%   Thus, if you start with a naturally ordered spectrum (say, a desired filter frequency response centred at DC)
%   then you must make it swapped before you use the ifft(). The function fftshift 'unswaps' an array, and the
%   inverse function ifftshift() swaps one. So we use ifftchift BEFORE an ifft() in the case where the input
%   (spectrum) is NOT the result of a MATLAB fft()

%   ifftshift(X,dim) applies the ifftshift operation along the dimension dim

%   ifft returns the inverse DFT of each column of the matrix:
output_a = ifft( ifftshift( input_A, 1 ) );

end