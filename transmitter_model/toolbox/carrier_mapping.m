function [ A ] = carrier_mapping(symbols, fft_len, pilot_method )
%CARRIER_MAPPING Maps the symbols into the time-freq grid A(k,l) and
%inserts the pilot symbols.
%   pilot_method: 'A' or 'B'

assert(pilot_method == 'A' | pilot_method == 'B');
assert(fft_len == 32 | fft_len == 64 | fft_len == 128);

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


if(pilot_method == 'A')
    tx_sym_per_ofdm_sym = fft_len-length(unused_carriers);
    used_carriers = -fft_len/2:fft_len/2-1;
    used_carriers(unused_carriers+fft_len/2+1) = [];
    
    %check for correct symbol length to fill whole ofdm symbols
    m=mod(length(symbols),tx_sym_per_ofdm_sym);
    if(m ~= 0)
        %padding to fill a complete ofdm symbol
        z = tx_sym_per_ofdm_sym-m;
        symbols = [symbols zeros(1,z)];
        warning('carrier mapping method A: symbols given doesnt fill whole ofdm symbols, now using padding with zeroes')
    end
    
    symbols = reshape(symbols,tx_sym_per_ofdm_sym,[]);
    
    %insert pilots on even subcarriers
    symbols = reshape([ones(size(symbols)); symbols], tx_sym_per_ofdm_sym, []);
    %init time freq grid
    A = zeros(fft_len, size(symbols,2));
    %insert symbols on grid
    A(used_carriers+fft_len/2+1,:) = symbols;
    
    
end


if(pilot_method == 'B')
    tx_sym_per_ofdm_sym = fft_len-length(unused_carriers)-length(ofdm_pilot_carriers);
    used_carriers = -fft_len/2:fft_len/2-1;
    used_carriers([unused_carriers ofdm_pilot_carriers]+fft_len/2+1) = [];
    
    %check for correct symbol length to fill whole ofdm symbols
    m=mod(length(symbols),tx_sym_per_ofdm_sym);
    if(m ~= 0)
        %padding to fill a complete ofdm symbol
        z = tx_sym_per_ofdm_sym-m;
        symbols = [symbols zeros(1,z)];
        warning('carrier mapping method B: symbols given doesnt fill whole ofdm symbols, now using padding with zeroes')
    end
    symbols = reshape(symbols,tx_sym_per_ofdm_sym,[]);
    %init time freq grid
    A = zeros(fft_len, size(symbols,2));    
    %insert symbols on grid
    A(used_carriers+fft_len/2+1,:) = symbols;  
    %insert pilots on grid
    A(ofdm_pilot_carriers+fft_len/2+1,:) = 1;
end







