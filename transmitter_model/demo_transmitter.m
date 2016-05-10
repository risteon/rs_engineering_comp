%% Parameters
addpath('toolbox');
data = 'test';
%   const_points: number of psk points (2, 4 or 8)
psk_points = 4;
%   pilot_method: 'A' or 'B'
pilot_method = 'A';
%   fft_len 32, 64, 128
fft_len = 32;


%% ASCII CODING
disp(['Input c(m) for ascii coding: ', data])

b_n = ascii_coding(data);


%% Symbol Modulation
disp(['Input b_n0 for 4-PSK: ', num2str(b_n)])

s_n1 = symbol_mod(b_n, psk_points);

%% Carrier Mapping
disp(['Input s_n1 for Carrier mapping: ', num2str(s_n1)])

A = carrier_mapping(s_n1, fft_len, pilot_method);

%% IFFT
disp('Input A for IFFT: ');
disp(A);

a = tm_ifft(A);

%% Cyclic Prefix
disp('Input a for cyclic prefix adding: ');
disp(a);

tx = cyclic_prefix_adding(a);

disp(['Output tx: ', num2str(tx)]);
