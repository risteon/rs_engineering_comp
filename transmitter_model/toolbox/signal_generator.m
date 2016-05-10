function [ tx_out ] = signal_generator( data, psk_points, fft_len, pilot_method )
%SIGNAL_GENERATOR Summary of this function goes here
%   Detailed explanation goes here

b_n = ascii_coding(data);


%% Symbol Modulation

s_n1 = symbol_mod(b_n, psk_points);

%% Carrier Mapping

A = carrier_mapping(s_n1, fft_len, pilot_method);

%% IFFT

a = tm_ifft(A);

%% Cyclic Prefix

tx_out = cyclic_prefix_adding(a);

end

