function [ A ] = carrier_mapping(symbols, fft_len, pilot_method )
%CARRIER_MAPPING Summary of this function goes here
%   pilot_method: 'A' or 'B'

assert(pilot_method == 'A' | pilot_method == 'B');
assert(fft_len == 32 | fft_len == 64 | fft_len == 128);

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


ofdm_symbol_generated = 0;
tx_sym_processed = 0;
tx_sym_cnt = length(symbols);

%A = zeros(fft_len,1);

if(pilot_method == 'A')
    finish = 0;
    
    while ~finish
        %init time/freq grid
        A(:,ofdm_symbol_generated+1) = zeros(fft_len,1);
        
        %map pilot_carriers
        if( mod(ofdm_symbol_generated,2) == 0)
            k=0;
            for i=-fft_len/2:fft_len/2-1
                k = k+1;
                if(~any(i==unused_carriers))    %dont use unused carriers
                    A(k,ofdm_symbol_generated+1) = 1;
                end
            end
            ofdm_symbol_generated=ofdm_symbol_generated+1;
        else
            %map symbols
            k=0;
            for i=-fft_len/2:fft_len/2-1
                k = k+1;
                if(~any(i==unused_carriers))    %dont use unused carriers
                    if(tx_sym_processed == tx_sym_cnt)
                        finish = 1;
                        break;
                    end
                    A(k,ofdm_symbol_generated+1) = symbols(tx_sym_processed+1);
                    tx_sym_processed = tx_sym_processed+1;
                end
            end
            ofdm_symbol_generated=ofdm_symbol_generated+1;
        end
    end
end


if(pilot_method == 'B')
    finish = 0;
    
    while ~finish
        %init time/freq grid
        A(:,ofdm_symbol_generated+1) = zeros(fft_len,1);
        
        k=0;
        for i=-fft_len/2:fft_len/2-1
            k = k+1;
            if(~any(i==unused_carriers))    %dont use unused carriers
                
                %map pilots
                if(any(i==ofdm_pilot_carriers))
                    A(k,ofdm_symbol_generated+1) = 1;
                elseif(tx_sym_processed == tx_sym_cnt)
                    finish = 1;                   
                else
                    A(k,ofdm_symbol_generated+1) = symbols(tx_sym_processed+1);
                    tx_sym_processed = tx_sym_processed+1;
                end               
            end            
            
        end
        ofdm_symbol_generated=ofdm_symbol_generated+1;
        
    end
    
end

