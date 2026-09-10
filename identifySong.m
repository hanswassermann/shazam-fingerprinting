load('database.mat');  % loads database and songs

queryFile = 'Foghat - Slow Ride.wav'; %input song we are comparing to database
root_dir = 'wav_chunks';
queryHashes = computeHashes(fullfile(root_dir, queryFile)); %compute input songs hashes

% These are tolerances because some of these frequency calculations wont be
% exactly the same even if its the same song
freq_tol = 50;   % Hz
time_tol = 0.05; % seconds

%iterate through the 13 songs in the database
scores = zeros(13, 1);
for i = 1:13
    scores(i) = computeSimilarity(queryHashes, database{i}, freq_tol, time_tol); %find highest score for each song in database
end

[bestScore, bestIdx] = max(scores); %find max score out of score array
fprintf('Best match: song %d (%s) with score %d\n', bestIdx, songs{bestIdx}, bestScore);

% show all scores 
disp('All scores:');
for i = 1:13
    fprintf('  Song %d (%s): %d matches\n', i, songs{i}, scores(i));
end