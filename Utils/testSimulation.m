% INPUTS
%
% full_data - full data set
% test_data - test data set
% options - the options array
% range - array of range values

% OUTPUTS
%
% decision - the adjacency matrix of whether a set of measurements (row) belong to a given county (column)
% matching_county - array of counties that most closely match given measurement set

function [decision, matching_county] = testSimulation(full_data, test_data, options, range, upper, lower)

nmon = max(test_data(find(test_data(:, 4) == 1), 1)); % number of monitors
nafeat = nnz(options); % number of active features
nc = size(test_data, 1)/nmon; % number of counties

decision = -1 * ones(nc, nc);
matching_county = -1 * ones(1, nc);
test_measurements = zeros(nc, nmon, nafeat);

county = test_data(1:nmon:size(test_data, 1), 4:6);

% create measurement matrix
for ii = 1:nc % for each county
	k = 0;
	for jj = 1:size(options, 2) % for each active option
		if (options(jj) == 1)
			k = k + 1;
			test_measurements(ii, :, k) = test_data(nmon * (ii-1) + 1:nmon * ii, 7 + k);
			the_range(k) = range(jj);
		end
	end
end

% obtain decision for each set of measurements for each county
for m = 1:nc % for each measurement set
	difference = Inf(1, nc);
	for n = 1:nc % for each county
		[decision(m, n), difference(1, n)] = dsCalc(horzcat(full_data(:, 1:3),full_data(:, 7:end)),county(n, :),test_measurements(m, :, :), the_range, upper, lower);
    end
	[~, Ind] = min(difference);
	matching_county(1, m) = Ind; % can be modified to find name of county in case county numbers are out of order
end