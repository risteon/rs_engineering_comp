function [ Hvec ] = channel_estimation_methA_simple( A )
%CHANNEL_ESTIMATION_METHA_SIMPLE estimation of the channel
%   using a simple average over all pilots 
%   (assumption: constant channel!)
%   A: rx time freq grid
%   Hvec: estimated channel 

Hvec = sum(A(:,1:2:end),2) / size(A(:,1:2:end),2);


end

