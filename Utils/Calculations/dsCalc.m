% INPUTS
% data - the monitor number, monitor x, monitor y, distance, and feature columns of the full data set
% county - the county that is to be tested for reliability as well as its
% corresponding x and y coordinates and distance from monitors
% measurements - the array of different types of measurements
% range - the vector of range values

% OUTPUTS
% decision - the decision of whether or not set of measurements belong to given county, 1 if yes, 0 if no
% difference - the difference between measured distance and predicted distance at 100% plausibility
% given as Inf if value is less than -1.5

function [decision, difference] = dsCalc(data, county, measurements, range, upper, lower)

% determine range of data in which to extract distance values
decision = 0; decision_per_mon = zeros(size(measurements, 2), 1); 
elts = zeros(size(measurements, 3),3,size(measurements, 2)); difference_per_mon = Inf(size(measurements, 2), 1);

for ii = 1:size(measurements, 2) % for each monitor
    p = 0;
	for jj = 1:size(measurements,3) % for each feature type
		mon_data = data(find(data(:, 1) == ii), :);
		if(range(jj) ~= -1)
			numerator = 1 / measurements(1, ii, jj);
			if numerator < range(jj)
				lowerlimit = 0;
				upperlimit = 1 / range(jj);
			else
				quotient = floor(numerator / range(jj));
				upperlimit = 1 / (quotient * range(jj));
				lowerlimit = 1 / (quotient * range(jj) + range(jj));
            end
			% find the records that lie within this range
			s = mon_data(find((mon_data(:, 4 + jj) >= lowerlimit) & (mon_data(:, 4 + jj) <= upperlimit)),:); 
		else
			% there is no range, pick up the matching value
			s = mon_data(find(mon_data(:, 4 + jj) == measurements(1, ii, jj)), :); 
        	end
        	distance = s(:, 4);
        	if (size(distance) ~= 0)
            		p = p + 1;
            		w(p) = 1;
            		elts(p, :, ii) = [min(distance), max(distance), 1];
            		lambda(ii, p) = dsstruct(elts(p, :, ii));
            		% may try different fhandles, e.g. norminv
    	    		exp1(p) = dsadf('norminv', 10, lambda(ii, p));
        	end
    	end
    	if p > 0
    		bpa(ii) = dswmix(exp1, w); % may try dsdempstersrule
			
			
			% actual_distance is measured distance, predicted distance is calculated distance
        	actual_distance = sqrt(((county(2) - mon_data(1 ,2))^2) + ((county(3) - mon_data(1, 3))^2));
        	pl = dspl(bpa(ii));
        
        	if ((upper * pl(end, 1) > actual_distance) && (actual_distance > lower * pl(end, 1)))
         	   	decision_per_mon(ii, 1) = 1;
        	end
        	difference_per_mon(ii, 1) = actual_distance - pl(end, 1);
    	end
end

difference = min(difference_per_mon);
if difference < -1.5
	difference = Inf;
end
if decision_per_mon == ones(size(measurements, 2), 1)
    decision = 1;
end
