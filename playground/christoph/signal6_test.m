addpath('../../toolbox');
load('../../Material/Signal6');
clf

pilot_meth = 'B';
fft_len = 32;
prefix_len = fft_len/4;
mod_scheme = 4;

%shift = 44;

sig = Signal;

%% t sync

symb_len = 128;
pre_len = symb_len / 4;
frame_len = symb_len + pre_len;

scores = zeros(1, symb_len);

for shift = 1:symb_len
    score = 0;
    
    for frame_no = 0:10
        
        a = shift;
        b = shift + pre_len - 1;
        c = shift + symb_len;
        d = shift + frame_len - 1;
        
        symbol_shift = frame_no * frame_len;
        
        part_one = sig(a+symbol_shift:b+symbol_shift);
        part_two = sig(c+symbol_shift:d+symbol_shift);
        
        score = score + sum(part_one .* conj(part_two));
        
    end
   
    scores(shift) = score;
    
end

[~, t_sync_shift] = max(scores);

sig = sig(t_sync_shift:end);

test = [1 zeros(1, 31) 1 zeros(1, 127)];
test = repmat(test, 1, 54);

% equalize transmitter sampling period
sig = resample(sig, 1, 128/fft_len);

%freq estimate
eps = freq_offset_est_DC(sig, fft_len);
sig = sig .* exp(-1j*eps*2*pi*(1:size(sig,2)));

%TODO: Sampling frequency offset
sig = resample(sig, 40000,40000);



fft_sig = shape_ofdm(sig, fft_len, prefix_len);

fft_sig_save = fft_sig;
%plot(abs(fft_sig_save));
%return

%channel estimation
H = channel_estimation_methB_2DInterpolation(fft_sig, fft_len ,'linear');
fft_sig=fft_sig./H;
%plot(abs(fft_sig));

fft_sig = remove_unused(fft_sig, fft_len);
fft_sig = remove_pilot(fft_sig, pilot_meth, fft_len);

% plot constellation
plot(reshape(fft_sig,[],1),'*')

%demod
syms = pskdemod(fft_sig, mod_scheme, pi/4);
text = ascii_decoding(psk2bitstring(fft_sig, mod_scheme)) %#ok<NOPTS>

%remodulate
ideal = pskmod(syms, mod_scheme);
ideal = carrier_mapping(ideal,fft_len,pilot_meth);
ideal = remove_unused(ideal,fft_len);

%%mean channel
H_abs = abs(H);
H_abs = mean(H_abs,2);

fft_sig = remove_unused(fft_sig_save./H,fft_len);


%% calculate SNR
fft_noise = fft_sig - ideal;
fft_noise = reshape(fft_noise, 1, []);
% plot(fft_noise, '*');
p_noise = var(fft_noise);
p_sig = 1;
SIR = p_sig/p_noise;
