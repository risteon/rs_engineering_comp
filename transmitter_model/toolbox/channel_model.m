function [ rx_out ] = channel_model( tx_in, tau_delay )
%CHANNEL_MODEL
%   tx_in: signal to transmit
%   tau_delay: delay in samples

%% check input
assert(exist('tx_in', 'var') ~= 0, 'tx in not set');

if ~exist('tau_delay', 'var')
    tau_delay = 0.0;
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


rx_out = tx_delayed;

end