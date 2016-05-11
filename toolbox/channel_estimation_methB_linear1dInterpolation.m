function [ H ] = channel_estimation_methB_linear1dInterpolation( A, fft_len)
%CHANNEL_ESTIMATION_METHB_LINEAR1DINTERPOLATION 
%   channel estimation with a 1D linear interpolation approach
%   only method B
%
%   input A: time-freq grid with pilots and with unused carriers
%   output H: estimate of the channel 


assert(fft_len == 32 | fft_len == 64 | fft_len == 128);
assert(size(A,1)==fft_len,'wrong matrix A input size');

pilot_carriers = get_pilot_carriers(fft_len,0);

for i=1:size(A,2)
    pilots=A(get_pilot_carriers(fft_len,1),i).';
    H(:,i)=interp1(pilot_carriers,pilots,-fft_len/2:fft_len/2-1,'linear').';
end

