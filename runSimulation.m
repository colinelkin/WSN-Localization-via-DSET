% Runs the entire localization process for all test data under multiple combinations of features

clear all; clc; close all; 

% variables to set
nmon = 3; % number of monitors (2 or 3)

% add subdirectories
addpath('Datasets');
addpath('Saved Files');
addpath(genpath('Utils'));

% determine which input file to load
fname = 'data.csv';
if nmon == 2
    test_fname  = 'test-71.3333-data.csv'; % for 2 monitors
else
    test_fname = 'test-107-data.csv'; % for 3 monitors
end

% options - rss, aoa, standby in that order 
% 1 means feature is active, 0 means inactive
options=[1 1 1; 1 0 1; 1 1 0; 0 1 1; 0 0 1; 0 1 0; 1 0 0;];

% range for features RSS, AOA, standby 
% -1 means no range use direct value
range = [20; .002; -1];    

d1 = readmatrix(fname);        % full data set
d3 = readmatrix(test_fname);   % test data set

for ii = 1:size(options, 1) % for each feature selection

    % display feature combination
    disp('rss aoa standby'); disp(options(ii, :));
    % run DSET alorithm for all nodes
    [dec, match] = testSimulation(d1, d3, options(ii, :), range, 1.3, .95);
    close; 
    
    % save all three accuracy metrics to a CSV file
    save_dir = strcat('Saved Files', filesep, num2str(options(ii, :)), '-');
    accuracy_metrics = [testAccuracy(dec), testAccuracyShort(dec), testAccuracyMatch(match)];
    accuracy_header = {'FullAccuracy', 'ShortAccuracy', 'MatchingAccuracy'};
    accuracy_table = array2table(accuracy_metrics, 'VariableNames', accuracy_header);
    writetable(accuracy_table, strcat(save_dir, 'Accuracy.csv'));
    
    % display accuracy
    disp('test accuracy (%)');
    disp(accuracy_metrics(2));
    
    % save predicted (left) and actual (right) county outputs to a CSV file
    output_compare = array2table(horzcat(match', unique(d3(:, 4))), 'VariableNames', {'Predicted', 'Actual'});
    writetable(output_compare,strcat(save_dir, 'County Outputs.csv'));
end