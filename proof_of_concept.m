%%%%%%%%%%%%
% Cleaning %
%%%%%%%%%%%%

clear
clc

%%%%%%%%%%%
% Phase 1 %
%%%%%%%%%%%

% In phase 1 of our proof of concept, we want to generate our terrain to
% simulate traffic over.

N = 10; % Number of roads
p = 0.85; % density of roads we want - higher p = less roads
unit = 100; % Max road length
speed = 15;
ns = 5000;

d = rand(N,1) > p... % 1 = road exists, 0 = it doesn't
    .* randn(N, 1); % Set a random weight for each road, which corresponds to distance
t = triu(bsxfun(@min,d,d.').*rand(N),1); % The upper trianglar random values
M = diag(0)+t+t.'; % Put them together in a symmetric matrix - 
            % diagonal is 0 since if you start somewhere you're already there
M = M*unit; % Scale roads to their actual length

%%%%%%%%%%%
% Phase 2 %
%%%%%%%%%%%

% Now that we have a matrix representing roads and their lengths, we can 
% create some agents and initialize them with some basic data

initial_pos = triu(M) > (.7 * unit); % Bootleg way to create initial agent positions

agents = zeros(sum(sum(initial_pos)), 5); % Preallocate list holding agents
% Agents do not expire so this only needs to happen once

for i = 1:size(agents, 1)
    [pos, initial_pos] = trawl(initial_pos); % Find an agent and record its position
    agents(i, 1:2) = pos;
    agents(i, 5) = M(pos(1), pos(2));
end
agents(:, 3) = speed; % Initialize unit speed
agents(:, 4) = 1;

%%%%%%%%%%%
% Phase 3 %
%%%%%%%%%%%
% Here we have the actual simulation taking place


for q = 1:ns
    % Plotting
    % Calculate direction
    origin = agents(:, 1:2);
    destination = [origin(:, 2), origin(:, 1)] ;
    dir = (origin - destination) ./ abs(origin - destination);
    % Calculate deltas
    ind = sub2ind(size(M), agents(:, 1), agents(:, 2));
    total = M(ind);
    current = agents(:, 5);
    delta = (total - current) ./ total;
    delta = delta .* dir;
    plot(agents(:, 1) + delta, agents(:, 2) + delta, '.');
    axis equal xy
    xlabel('x'), ylabel('y') % axis labels
    title("Traffic Simulation")
    axis([0 N 0 N])
    xlabel("Destinations")
    ylabel("Origins")
    drawnow

  
    for i = 1:size(agents, 1)
        if agents(i,5) - agents(i, 3) <= 0 % End of road
            targets = M(agents(i, 2), :);
            choice = 0; 
            while 1
                choice = randi([1, length(targets)]); % Randomly choose valid path as next path
                if targets(choice) ~= 0
                    break;
                end
            end
            agents(i, :) = [agents(i, 2), choice, speed, 1, M(agents(i, 2), choice)];
        else
            agents(i,5) = agents(i,5) - agents(i, 4); % subtract speed from path (the car is moving)
        end
    end

end


function [pos,m] = trawl(m) 
% Utility function to find the first occurence of a non-zero number in m
    for i = 1:size(m,1)
        for j = 1:size(m,2)
            if m(i,j) ~= 0
                pos = [i,j];
                m(i,j) = 0;
                return;
            end
        end
    end
end
