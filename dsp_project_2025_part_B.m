% Parameters
filename = 'pirates.wav';   % Replace with your file
windowSize = 4096;
overlap = 2048;
fanOut = 5;
ampMin = 10;                 % Amplitude threshold for peaks
neighborhoodSize = 3;        % Size of the local neighborhood for peak detection

% Step 1: Read audio
[x, Fs] = audioread(filename);
x = mean(x, 2);  % Convert to mono if stereo

% Step 2: Compute spectrogram
[S, F, T] = spectrogram(x, windowSize, overlap, [], Fs);
S = abs(S);  % Magnitude spectrogram

% Step 3: Detect local peaks manually
peaks = zeros(size(S));
[nFreqBins, nTimeBins] = size(S);

for t = (1 + neighborhoodSize):(nTimeBins - neighborhoodSize)
    for f = (1 + neighborhoodSize):(nFreqBins - neighborhoodSize)
        localWindow = S(f - neighborhoodSize:f + neighborhoodSize, ...
                        t - neighborhoodSize:t + neighborhoodSize);
        localMax = max(localWindow(:));
        if S(f, t) == localMax && S(f, t) > ampMin
            peaks(f, t) = 1;
        end
    end
end

% Extract peak coordinates
[peakFreqIdx, peakTimeIdx] = find(peaks);

% Step 4: Generate hashes
hashes = [];
for i = 1:length(peakTimeIdx)
    for j = 1:fanOut
        if i + j <= length(peakTimeIdx)
            t1 = T(peakTimeIdx(i));
            t2 = T(peakTimeIdx(i + j));
            f1 = F(peakFreqIdx(i));
            f2 = F(peakFreqIdx(i + j));
            deltaT = round(t2 - t1, 2);
            hashes(end+1, :) = [round(f1), round(f2), deltaT, round(t1, 2)]; %#ok<AGROW>
        end
    end
end

disp('First few hashes:');
disp(hashes(1:min(10, size(hashes,1)), :));
