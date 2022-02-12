% Tests full accuracy by comparing decision matrix to ideal identity matrix

% INPUT
% results - decision matrix

% OUTPUT
% accuracy - percent accuracy of results in comparison to identity matrix

function accuracy = testAccuracy(results)

accuracy = 100 * nnz(results == eye(size(results, 1))) / numel(results);
