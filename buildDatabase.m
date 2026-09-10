base_dir = "wav_source";
songs = {"Alice Cooper - School's Out.wav", "Cream - Sunshine of Your Love.wav",...
    "DRAGONFORCE - Through the Fire and Flames.wav", "Foghat - Slow Ride.wav","Guitar Battle vs Tom Morello.wav", "Heart - Barracuda.wav",...
    "KISS - Rock and Roll All Nite.wav", "Lynyrd Skynyrd - Sweet Home Alabama.wav", "Mountain - Mississippi Queen.wav",...
    "Pat Benatar - Hit Me With Your Best Shot.wav", "Poison - Talk Dirty to Me.wav", "Rage Against the Machine - Bulls on Parade.wav"...
    "Social Distortion - Story of my Life.wav"};

database = cell(length(songs), 1);  % each cell holds the hashes for one song

for s = 1:length(songs)
    fprintf('Processing song %d: %s\n', s, fullfile(base_dir, songs{s}));
    database{s} = computeHashes(fullfile(base_dir, songs{s}));
end

save('database.mat', 'database', 'songs');
disp('Database saved.');