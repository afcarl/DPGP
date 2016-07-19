%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to generate a pair of trajectories
% for two agents, that model cooperative
% collision avoidance (if needed)
% by Anirudh Vemula, Jul 18, 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x1, y1, x2, y2, dt1, dt2] = generateTwoAgentTraj(n, pLimit, ...
                                                  speed, threshold, ...
                                                  func)

% Generate a linear trajectory for 1st agent
[x1, y1] = func(n, pLimit);

% Generate a linear trajectory for 2nd agent
[x2, y2] = func(n, pLimit);

% Flip the trajectory of the 2nd agent so that they will come
% against each other
x2 = flipud(x2);
y2 = flipud(y2);

% Add a random noise to the trajectories
x1 = x1 + (2*rand - 1); x2 = x2 + (2*rand - 1);
y1 = y1 + (2*rand - 1); y2 = y2 + (2*rand - 1);

% Check for collisions according to the input threshold
while true
    distances = sqrt(sum(([x1 y1] - [x2 y2]).^2, 2));
    collisions = find (distances < threshold);
    
    if isempty(collisions)
        break
    else
        ind = collisions(1);
        % Either move agent 1 or agent 2 (or both can also be included)
        moveCase = unidrnd(2);
        
        if moveCase==1
            % Move agent 1
            if x2(ind) > x1(ind)
                x1(ind) = x1(ind) - threshold;
                x1(ind-1) = x1(ind-1) - threshold/2;
                x1(ind+1) = x1(ind+1) - threshold/2;
            else
                x1(ind) = x1(ind) + threshold;
                x1(ind-1) = x1(ind-1) + threshold/2;
                x1(ind+1) = x1(ind+1) + threshold/2;
            end
            
            if y2(ind) > y1(ind)
                y1(ind) = y1(ind) - threshold;
                y1(ind-1) = y1(ind-1) - threshold/2;
                y1(ind+1) = y1(ind+1) - threshold/2;
            else
                y1(ind) = y1(ind) + threshold;
                y1(ind-1) = y1(ind-1) + threshold/2;
                y1(ind+1) = y1(ind+1) + threshold/2;
            end
        elseif moveCase == 2
            % Move agent 2
            if x1(ind) > x2(ind)
                x2(ind) = x2(ind) - threshold;
                x2(ind-1) = x2(ind-1) - threshold/2;
                x2(ind+1) = x2(ind+1) - threshold/2;
            else
                x2(ind) = x2(ind) + threshold;
                x2(ind-1) = x2(ind-1) + threshold/2;
                x2(ind+1) = x2(ind+1) + threshold/2;
            end
            
            if y1(ind) > y2(ind)
                y2(ind) = y2(ind) - threshold;
                y2(ind-1) = y2(ind-1) - threshold/2;
                y2(ind+1) = y2(ind+1) - threshold/2;
            else
                y2(ind) = y2(ind) + threshold;
                y2(ind-1) = y2(ind-1) + threshold/2;
                y2(ind+1) = y2(ind+1) + threshold/2;
            end
        end    
    end

end

% Initialize the dt array
dt1 = zeros(n+1, 1);
dt2 = zeros(n+1, 1);

% Fill the values of the dt array
for i=1:n-1
    dt1(i) = norm([x1(i+1)-x1(i) y1(i+1)-y1(i)]) / speed;
    dt2(i) = norm([x2(i+1)-x2(i) y2(i+1)-y2(i)]) / speed;
end
dt1(n) = dt1(n-1);
dt2(n) = dt2(n-1);

end