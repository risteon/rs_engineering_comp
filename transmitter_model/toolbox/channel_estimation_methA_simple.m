function [ Hvec ] = channel_estimation_methA_simple( A )
%CHANNEL_ESTIMATION_METHA_SIMPLE estimation of the channel
%   using a simple average over all pilots 
%   (assumption: constant channel!)
%   A: rx time freq grid
%   Hvec: estimated channel 

fft_len = size(A,1);
ofdm_symbols = size(A,2);
assert(fft_len==32 | fft_len ==64| fft_len== 128, 'wrong fft_len');
pilot = pilot_gen_freq('A',fft_len);


%delete unused carriers
for i=1:ofdm_symbols
   A(:,i)=A(:,i).*pilot; 
end
% average of the pilots
Hvec = sum(A(:,1:2:end),2) / size(A(:,1:2:end),2);





end

