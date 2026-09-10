%INPUTS: query hash matrix, database hash matrix we are comparing to,
%frequency tolerance, time tolerance
%OUTPUTS:highest score, denotes the total number of hash matches within
%tolerance
function score = computeSimilarity(queryHashes, dbHashes, freq_tol, time_tol)
    score = 0;
    
    % grab the first query hash as anchor
    q_anchor = queryHashes(1, :);  % [f1, f2, dT, t1]
    
    % find all candidates in dbHashes that match the first hash entry within a tolerance
    candidateIdx = find( ...
        abs(dbHashes(:,1) - q_anchor(1)) < freq_tol & ...
        abs(dbHashes(:,2) - q_anchor(2)) < freq_tol & ...
        abs(dbHashes(:,3) - q_anchor(3)) < time_tol );
    
    if isempty(candidateIdx)
        return;  % no candidates, return score = 0 and exit
    end
    
    % for each candidate, compute the time offset and score
    for c = 1:length(candidateIdx)
        t_offset = dbHashes(candidateIdx(c), 4) - q_anchor(4);
        
        % now count how many query hashes match dbHashes at this offset
        candidateScore = 0;
        for i = 1:size(queryHashes, 1)
            q = queryHashes(i, :);
            % shift query time (t1) by offset to align with database
            q_t1_shifted = q(4) + t_offset;
            
            %match checks if any row in dbHashes matches all 4 hash values
            %within a tolerance. if it does, it sets match = true.
            match = any( ...
                abs(dbHashes(:,1) - q(1))          < freq_tol & ...
                abs(dbHashes(:,2) - q(2))          < freq_tol & ...
                abs(dbHashes(:,3) - q(3))          < time_tol & ...
                abs(dbHashes(:,4) - q_t1_shifted)  < time_tol );
            
            if match
                candidateScore = candidateScore + 1;
            end
        end
        
        % keep the best score across all candidates
        score = max(score, candidateScore);
    end
end