%% Parameter

pilot_method = 'A';
fft_length = 64;
cp_length = fft_length/4;
load('../../Material/Signal4.mat');  % Variable 'Signal'

%for method A and B
unused_carriers_32 = [-16,-15,-14,0,14,15];
unused_carriers_64 = [-32,-31,-30,-29,0,29,30,31];
unused_carriers_128 = [-64,-63,-62,-61,-60,0,60,61,62,63];

if pilot_method == 'A'
    %for method A
    ofdm_pilot_carriers_32 = setdiff(-16:15, unused_carriers_32);
    ofdm_pilot_carriers_64 = setdiff(-32:31, unused_carriers_32);
    ofdm_pilot_carriers_128 = setdiff(-128:127, unused_carriers_32);
elseif pilot_method == 'B'
    %for method B
    ofdm_pilot_carriers_32 = [-13,-4,4,13];
    ofdm_pilot_carriers_64 = [-28,-20,-12,-4,4,12,20,28];
    ofdm_pilot_carriers_128 = [-59,-52,-44,-36,-28,-20,-12,-4,+4,+12,+20,+28,+36,+44,+52,+59];
end

if fft_length == 32
    I_v = unused_carriers_32 + 16;
    I_p = ofdm_pilot_carriers_32 + 16;
    I_d = setdiff(0:31, union(I_v, I_p));
elseif fft_length == 64
    I_v = unused_carriers_64 + 32;
    I_p = ofdm_pilot_carriers_64 + 32;
    I_d = setdiff(0:63, union(I_v, I_p));
elseif fft_length == 128
    I_v = unused_carriers_128 + 64;
    I_p = ofdm_pilot_carriers_128 + 64;
    I_d = setdiff(0:127, union(I_v, I_p));
else
    assert(0);
end


%% time sync using known pilot A peaks

tx_in = Signal;
fft_len = fft_length;

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
    superpositioned = superpositioned + abs(time_corr(startpoint:endpoint));
    startpoint = endpoint + 1;
    endpoint = endpoint + 2*pilot_length;
end

% find maximum position and calculate shift
[~, idx] = max(superpositioned);
offset = lags(considerable_length -1+ idx)/upsampling_l;

% check estimate
assert(offset < size(tx_in, 2));
assert(offset == 23, 'Something is wrong! You previously had an t sync estimate of 23!');

% apply offset
tx_in = [tx_in(offset+1:end) zeros(1, offset)];

%% Frequency offset estimate and compensation

% for every symbol

frame_len = fft_len + cp_length;
current_sample = 1;
sample_count = size(tx_in, 2);

epsilon = [];

while current_sample + frame_len < sample_count
    r = tx_in(current_sample:current_sample+frame_len-1);

    gamma = sum(r(1:cp_length).*conj(r(frame_len - cp_length + 1:frame_len)));
    
    epsilon = [epsilon -1/2/pi * angle(gamma)];

    current_sample = current_sample + frame_len;
end

epsilon_mean = mean(epsilon);

%eps_compensation = exp(-2j*pi*epsilon_mean/fft_length * (1:sample_count));
%eps_compensation = exp(2j*pi* 0.08  /fft_length * (1:sample_count));


%tx_in = tx_in .* eps_compensation;

pilots = tx_in(17:end);
pilots = pilots(1:160:end);
plot(angle(pilots))
phase = [];
for i = 1:length(pilots)-1
   phase = [phase unwrap(angle(pilots(i+1)))-unwrap(angle(pilots(i)))] 
end
phase = mean(unwrap(phase))

tx_in = tx_in .* exp(-j*phase/160*(1:sample_count));

pilots = tx_in(17:end);
pilots = pilots(1:160:end);
plot(angle(pilots))
