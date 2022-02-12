% Launches the plot of the WSN

% INPUT
% number of monitors (2 or 3)

function plotWSN(nmon)

if nmon == 2
	test_fname  = 'test-71.3333-data.csv'; % for 2 monitors
else
	test_fname = 'test-107-data.csv'; % for 3 monitors
end

d = matrixread(test_fname);   % load test data set

%nmon = max(d(:, 1)); % delete this line if program works
node_x = d(1:nmon:size(d, 1), 5); node_y = d(1:nmon:size(d, 1), 6); 
monitor_x = d(1:nmon, 2); monitor_y = d(1:nmon, 3);

scatter(node_x, node_y, [], 'blue', '+'); hold on;
scatter(monitor_x, monitor_y, [], 'red'); hold on;
scatter(500, 800, [], 'cyan'); hold on;
scatter(500, 500, [], 'green');

grid on;

xlabel('Longitudinal coordinate (m)');
ylabel('Latitudinal coordinate (m)');

title('Map of All Nodes in a Wireless Sensor Network');
legend('Sensor Node', 'Anchor Node', 'Standby Node', 'Fusion Center');