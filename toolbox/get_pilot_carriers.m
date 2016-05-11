function [ pilot_carriers ] = get_pilot_carriers( fft_len, shift)
%GET_OFDM_PILOT_CARRIERS returns the positions of the pilot carriers ONLY 
%   for method B
%   input fft_len: fft length
%   input shift: =0 unshifted, from negative to positve
%                =1 shifted for vector use from 1 to fft_len
%                   with unused carriers
%                =2 shifted for vector use from 1 to
%                   fft_len-nr_of_unused_carriers
%                   without unused carriers

assert(any(fft_len==[32 64 128]));
assert(any(shift==[0 1 2]));

pilot_carriers_32 = [-13,-4,4,13];
pilot_carriers_64 = [-28,-20,-12,-4,4,12,20,28];
pilot_carriers_128 = [-59,-52,-44,-36,-28,-20,-12,-4,+4,+12,+20,+28,+36,+44,+52,+59];
pilot_carriers = 0;

if(fft_len == 32)
    pilot_carriers = pilot_carriers_32;
elseif (fft_len == 64)
    pilot_carriers = pilot_carriers_64;
elseif (fft_len == 128)
    pilot_carriers = pilot_carriers_128;
end

if (shift==1)
    pilot_carriers=pilot_carriers+fft_len/2+1;
end

if(shift==2)
    if(fft_len == 32)
        pilot_carriers = [1 10 17 26];
    elseif (fft_len == 64)
        pilot_carriers = [1 9 17 25 32 40 48 56];
    elseif (fft_len == 128)
        pilot_carriers = [1 8 16 24 32 40 48 56 63 71 79 87 95 103 111 118];
    end
end

end

