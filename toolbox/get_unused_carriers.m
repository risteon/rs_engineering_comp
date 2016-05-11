function [ unused_carriers ] = get_unused_carriers( fft_len, shift )
%GET_OFDM_PILOT_CARRIERS returns the positions of the unused carriers
%   input fft_len
%   input shift: =0 unshifted, from negative to positve
%                =1 shifted for vector use from 1 to fft_len                 


assert(any(fft_len==[32 64 128]));
assert(any(shift==[0 1]));

unused_carriers_32 = [-16,-15,-14,0,14,15];
unused_carriers_64 = [-32,-31,-30,-29,0,29,30,31];
unused_carriers_128 = [-64,-63,-62,-61,-60,0,60,61,62,63];
unused_carriers = 0;

if(fft_len == 32)
    unused_carriers = unused_carriers_32;
elseif (fft_len == 64)
    unused_carriers = unused_carriers_64;
elseif (fft_len == 128)
    unused_carriers = unused_carriers_128;
end

if(shift==1)
    unused_carriers = unused_carriers+fft_len/2+1;
end

end

