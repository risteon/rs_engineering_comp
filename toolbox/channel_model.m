function [ rx_out ] = channel_model( tx_in, tau_delay, h, delta_f, snr )
%CHANNEL_MODEL
%   tx_in: signal to transmit
%   tau_delay: delay in samples
%   h: complex channel impulse response
%   delta_f: carrier frequency offset delta f/f_a
%   snr: SNR

%% check input and use default values
assert(exist('tx_in', 'var') ~= 0, 'tx in not set');

if ~exist('tau_delay', 'var')
    tau_delay = 0.0;
end
if ~exist('h', 'var')
    h = 1;
end
if ~exist('delta_f', 'var')
    delta_f = 0.0;
end
if ~exist('snr', 'var')
    snr = Inf(1);
end

assert(tau_delay >= 0.0);

%% delay

leading_zeros = floor(tau_delay);
frac_samples = tau_delay - leading_zeros;

% add zeros in front
tx_delayed = [zeros(1, leading_zeros) tx_in];

if frac_samples > 0
   assert(0, 'not implemented yet, use fdesign.fracdelay');
end

%% complex channel impulse response

tx_channel_res = conv(h, tx_delayed);


%% frequency offset

% rotate every sample
drehvector = 2j*pi*delta_f*(0:size(tx_channel_res, 2)-1);
tx_freq_offset = tx_channel_res .* exp(drehvector);


%% noise

if snr ~= Inf(1)
    % exact definition of SNR in task description is currently ignored...
    rx_out = awgn(tx_freq_offset, snr);
else
    rx_out = tx_freq_offset;
end

end