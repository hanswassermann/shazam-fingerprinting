% Load your audio file
[audioIn, Fs] = audioread('pirates.wav');  % Replace with your filename

% Filter specifications
filterOrder = 64;        % Order of the filter (higher = sharper cutoff)
cutoffFreq = 3000;       % Cutoff frequency in Hz (e.g., 4 kHz for vocals)
normalizedCutoff = cutoffFreq / (Fs / 2);  % Normalize to Nyquist

% Design the FIR low-pass filter using a Hamming window
%b = fir1(filterOrder, normalizedCutoff, 'low', hamming(filterOrder + 1));
b = fir1(filterOrder, normalizedCutoff, 'high', hamming(filterOrder + 1));

% Apply the filter to the audio signal
audioOut = filter(b, 1, audioIn);

% Play original and filtered audio
disp('Playing original audio...');
%sound(audioIn, Fs);
%pause(length(audioIn)/Fs + 1);

disp('Playing filtered audio...');
%sound(audioOut, Fs);

% Save the filtered output
%audiowrite('filtered_papas.wav', audioOut, Fs);

[H, w] = freqz(b, 1, 1024, 'whole');   % compute frequency response at 1024 points over [0, 2pi]
w = w - pi;                             % shift to center at 0
H = fftshift(H);                        % align H from [0,2pi] to [-pi,pi]

[H_hz, f] = freqz(b, 1, 1024, 'whole', Fs); % same freq response computation but with Fs, so frequency axis is in Hz instead of rads/sample
f = f - Fs/2; %shifts frequencies left by Fs/2, aligns it at 0
H_hz = fftshift(H_hz); %H_hz reorders from [0,Fs] to [-Fs/2, Fs/2]

subplot(2,2,1);
plot(w, abs(H));
xlabel('\omega (rads/sample)'); ylabel('|H(e^{j\omega})|');
title('Magnitude Response of 64 order HPF');
xlim([-pi, pi]); grid on;

subplot(2,2,2);
plot(f/1000, abs(H_hz));
xlabel('Frequency (kHz)'); ylabel('|H(e^{j\omega})|');
title('Magnitude Response of 64 order HPF');
xlim([-Fs/2000, Fs/2000]); grid on;

subplot(2,2,3);
plot(w, angle(H));
xlabel('\omega (rads/sample)'); ylabel('\angle H(e^{j\omega})');
title('Phase Response of 64 order HPF');
xlim([-pi, pi]); grid on;

subplot(2,2,4);
plot(f/1000, angle(H_hz));
xlabel('Frequency (kHz)'); ylabel('\angle H(e^{j\omega})');
title('Phase Response of 64 order HPF');
xlim([-Fs/2000, Fs/2000]); grid on;