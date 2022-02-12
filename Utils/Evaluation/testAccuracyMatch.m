% Tests matching accuracy by comparing predicted county array to actual county array

% INPUT
% results - decision matrix

% OUTPUT
% accuracy - percent accuracy of results in comparison to ideal county array

function accuracy = testAccuracyMatch(matching_county)

accuracy = 100 * (nnz(matching_county == (1:length(matching_county))') / length(matching_county));