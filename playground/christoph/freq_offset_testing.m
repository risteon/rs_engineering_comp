%% Create signal

psk_points = 4;
fft_len = 64;
cp_length = fft_len / 4;
pilot_method = 'A';

tx = signal_generator('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',...
                        psk_points, fft_len, pilot_method);

freq_offset = -0.0035;
rx = channel_model(tx, 0.0, 1, freq_offset);

%% Frequency offset estimate and compensation

% for every symbol

frame_len = fft_len + cp_length;
current_sample = 1;
sample_count = size(rx, 2);

% estimated epsilon for every OFDM frame
epsilon = [];

while current_sample + frame_len < sample_count
    r = rx(current_sample:current_sample+frame_len-1);

    gamma = sum(r(1:cp_length).*conj(r(frame_len - cp_length + 1:frame_len)));
    
    epsilon = [epsilon -1/2/pi * angle(gamma)];
    
    current_sample = current_sample + frame_len;
end

epsilon_mean = mean(epsilon)/64;



eps_compensation = exp(-2j*pi*epsilon_mean * (1:sample_count));
%eps_compensation = exp(-2j*pi* freq_offset * (1:sample_count));

rx = rx .* eps_compensation;

pilots = rx(17:end);
pilots = pilots(1:160:end);
plot(angle(pilots))
