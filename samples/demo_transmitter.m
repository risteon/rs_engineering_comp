data = 'test';

%% ASCII CODING
disp(['Input c(m) for ascii coding: ', data])

b_n = ascii_coding(data);


%% Symbol Modulation
disp(['Input b_n0 for 4-PSK: ', num2str(b_n)])

s_n1 = symbol_mod(b_n, 4);

%% Carrier Mapping
disp(['Input s_n1 for Carrier mapping: ', num2str(s_n1)])
