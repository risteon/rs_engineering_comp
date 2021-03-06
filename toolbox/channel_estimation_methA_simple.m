function [ H ] = channel_estimation_methA_simple( A )
%CHANNEL_ESTIMATION_METHA_SIMPLE estimation of the channel
%   using a simple average over all pilots 
%   (assumption: constant channel!)
%   in A: rx time freq grid
%   out H: estimated channel 

H= sum(A(:,1:2:end),2) / size(A(:,1:2:end),2);

H = repmat(H,1,size(A,2));

end

