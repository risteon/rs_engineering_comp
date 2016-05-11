function [ H ] = channel_estimation_methB_linear1dInterpolation( A, fft_len)
%CHANNEL_ESTIMATION_METHB_LINEAR1DINTERPOLATION 
%   input A: time-freq grid with pilots and with unused carriers
%   output H: estimate of the channel transfer function 


assert(fft_len == 32 | fft_len == 64 | fft_len == 128);
assert(size(A,1)==fft_len,'wrong matrix A input size');

%for method A and B
unused_carriers_32 = [-16,-15,-14,0,14,15];
unused_carriers_64 = [-32,-31,-30,-29,0,29,30,31];
unused_carriers_128 = [-64,-63,-62,-61,-60,0,60,61,62,63];
unused_carriers = 0;

%for method B
ofdm_pilot_carriers_32 = [-13,-4,4,13];
ofdm_pilot_carriers_64 = [-28,-20,-12,-4,4,12,20,28];
ofdm_pilot_carriers_128 = [-59,-52,-44,-36,-28,-20,-12,-4,+4,+12,+20,+28,+36,+44,+52,+59];
ofdm_pilot_carriers = 0;

if(fft_len == 32)
    unused_carriers = unused_carriers_32;
    ofdm_pilot_carriers = ofdm_pilot_carriers_32;
elseif (fft_len == 64)
    unused_carriers = unused_carriers_64;
    ofdm_pilot_carriers = ofdm_pilot_carriers_64;
elseif (fft_len == 128)
    unused_carriers = unused_carriers_128;
    ofdm_pilot_carriers = ofdm_pilot_carriers_128;
end

used_carriers = -fft_len/2:fft_len/2-1;
used_carriers(unused_carriers+fft_len/2+1) = [];


for i=1:size(A,2)
    pilots=A(ofdm_pilot_carriers+fft_len/2+1,i).';
    H(:,i)=interp1(ofdm_pilot_carriers,pilots,-fft_len/2:fft_len/2-1).';
end

