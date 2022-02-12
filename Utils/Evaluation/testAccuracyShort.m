% Tests short accuracy by comparing diagonal of results against vector of all ones

% INPUT
% results - decision matrix

% OUTPUT
% accuracy - percent accuracy of results in comparison to all ones

function accuracy = testAccuracyShort(results)

accuracy = 100 * nnz(diag(results) == ones(numel(diag(results)), 1)) / numel(diag(results));