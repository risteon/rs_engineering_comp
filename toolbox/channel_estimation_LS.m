function [ H ] = channel_estimation_LS( A, ideal)
%CHANNEL_ESTIMATION_LS
%   channel estimation for CONSTANT channel, LS approach
%
%   input A: received time-freq grid
%   input ideal: sent/ideal/correct values

%   output H: estimate of the channel 


H = [];

for i=1:size(A,1)
    a=A(i,:);
    b=ideal(i,:);
    x=inv(b*b')*conj(b)*a.';
    H = [H; x];
    
end

H = repmat(H,1,size(A,2));

