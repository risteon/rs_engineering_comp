function [ offset ] = t_sync_pilot_A( tx_in, fft_len )
%T_SYNC_PILOT_A delay estimation using time domain correlation with pilot
%signal

assert(exist('tx_in', 'var') ~= 0, 'tx in not set');

% upsampling factor
upsampling_l = 64;

pilot_symbol = pilot_gen_freq('A', fft_len);
pilot_symbol_time_domain = cyclic_prefix_adding(tm_ifft(pilot_symbol));

% perform upsampling on both signals
pilot_symbol_time_domain = resample(pilot_symbol_time_domain, upsampling_l, 1);
tx_upsampled = resample(tx_in, upsampling_l, 1);

pilot_length = size(pilot_symbol_time_domain, 2);
considerable_length = max(pilot_length, size(tx_upsampled, 2));

[time_corr, lags] = xcorr(tx_upsampled, pilot_symbol_time_domain);
time_corr = time_corr(considerable_length:end);

% superposition 2-symbol sections of correlation for pilots in method A
superpositioned = zeros(1, 2*pilot_length);
startpoint = 1;
endpoint = 2*pilot_length;

while endpoint <= considerable_length
    superpositioned = superpositioned + time_corr(startpoint:endpoint);
    startpoint = endpoint + 1;
    endpoint = endpoint + 2*pilot_length;
end

% find maximum position and calculate shift
[~, idx] = max(superpositioned);
offset = lags(considerable_length -1 + idx)/upsampling_l;

end

