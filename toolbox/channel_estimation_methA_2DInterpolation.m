function [ H ] = channel_estimation_methA_2DInterpolation( A, fft_len, inter_method)
%CHANNEL_ESTIMATION_METHB_LINEAR1DINTERPOLATION 
%   channel estimation with a 2D linear interpolation approach
%   only method A
%
%   input A: time-freq grid with pilots and with unused carriers
%   input inter_method: interpolation method, look up interp2 help, ('linear',
%   'spline', 'cubic', 'nearest')
%
%   output H: estimate of the channel 



assert(fft_len == 32 | fft_len == 64 | fft_len == 128);
assert(size(A,1)==fft_len,'wrong matrix A input size');

cnt_symbols=size(A,2);

%position of pilots in freq domain
pilot_carriers = 1:fft_len;
pilot_carriers(get_unused_carriers(fft_len,1))=[];
pilot_carriers=pilot_carriers';

%position of pilots in time domain
pilot_pos=1:2:cnt_symbols;

%pilot_carriers and pilot_pos define a grid in the freq/time grid

pilots=A(pilot_carriers, pilot_pos);

freq_points = (1:fft_len)';
time_points = (1:cnt_symbols);

H=interp2(pilot_pos,pilot_carriers,pilots,time_points,freq_points,inter_method);



