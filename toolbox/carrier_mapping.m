function [ A ] = carrier_mapping(symbols, fft_len, pilot_method )
%CARRIER_MAPPING Maps the symbols into the time-freq grid A(k,l) and
%inserts the pilot symbols.
%   pilot_method: 'A' or 'B'

assert(pilot_method == 'A' | pilot_method == 'B');
assert(fft_len == 32 | fft_len == 64 | fft_len == 128);

unused_carriers=get_unused_carriers(fft_len,0);
ofdm_pilot_carriers = get_pilot_carriers(fft_len,0);

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







