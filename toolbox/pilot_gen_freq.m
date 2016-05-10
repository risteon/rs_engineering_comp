function [ pilot_vec ] = pilot_gen_freq( pilot_method, fft_len )
%PILOT_GEN_FREQ generate one OFDM symbol in freq domain

assert(fft_len==32 | fft_len ==64| fft_len== 128, 'wrong fft_len');

%for method A and B
unused_carriers_32 = [-16,-15,-14,0,14,15];
unused_carriers_64 = [-32,-31,-30,-29,0,29,30,31];
unused_carriers_128 = [-64,-63,-62,-61,-60,0,60,61,62,63];

%for method B
ofdm_pilot_carriers_32 = [-13,-4,4,13];
ofdm_pilot_carriers_64 = [-28,-20,-12,-4,4,12,20,28];
ofdm_pilot_carriers_128 = [-59,-52,-44,-36,-28,-20,-12,-4,+4,+12,+20,+28,+36,+44,+52,+59];

if(pilot_method == 'A')
    pilot_vec=ones(fft_len,1);
    if(fft_len ==32)
        pilot_vec(unused_carriers_32+fft_len/2+1)=0;
    elseif(fft_len==64)
        pilot_vec(unused_carriers_64+fft_len/2+1)=0;        
    elseif(fft_len==128)
        pilot_vec(unused_carriers_128+fft_len/2+1)=0;        
    end
    
else if(pilot_method == 'B')
        assert(0, 'method b not yet implemented');
    end
    
    
end

