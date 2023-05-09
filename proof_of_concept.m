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

N = 20; % Number of roads
p = .7; % density of roads we want - higher p = less roads
unit = 400; % path length scaling factor
speed = 45;
ns = 5000;

d = (rand(N,1) > p)... % 1 = road exists, 0 = it doesn't
    .* randn(N, 1); % Random length for each road
t = abs(triu(bsxfun(@min,d,d.').*rand(N),1)); % The upper trianglar random values
init = t;
M = diag(0)+t+t.'; % Put them together in a symmetric matrix - 
            % diagonal is 0s
M = M*unit; % Scale roads based on unit length

%%%%%%%%%%%
% Phase 2 %
%%%%%%%%%%%

% Now that we have a matrix representing roads and their lengths, we can 
% create some agents and initialize them with some basic data

initial_pos = init > .5; % Bootleg way to create initial agent positions
initial_pos_copy = initial_pos;

agents = zeros(sum(sum(initial_pos)), 4); % Preallocate list holding agents
% Agents do not expire so this only needs to happen once

for i = 1:size(agents, 1)
    [pos, initial_pos_copy] = trawl(initial_pos_copy); % Find an agent and record its position
    agents(i, 1:2) = pos;
    agents(i, 4) = M(pos(1), pos(2));
end
agents(:, 3) = speed; % Initialize unit speed

%%%%%%%%%%%
% Phase 3 %
%%%%%%%%%%%
% Here we have the actual simulation taking place
clf
xlabel('x'), ylabel('y') % axis labels
title("Traffic Simulation")
axis([0 N 0 N])
xlabel("Destinations")
ylabel("Origins")
plot(agents(:, 1), agents(:, 2), '.');

for q = 1:ns
    % Plotting
    % Calculate direction
    origin = agents(:, 1:2);
    destination = [origin(:, 2), origin(:, 1)] ;
    dir = (destination - origin) ./ abs(origin - destination); % Compute unit vector representing direction
    % Calculate deltas
    ind = sub2ind(size(M), agents(:, 1), agents(:, 2)); % Linear indexing
    total = M(ind); 
    current = agents(:, 4);
    delta = ((total - current) ./ total) .* dir; % Calculate progress along path for each agent

    plot(agents(:, 1) + delta(:, 1), agents(:, 2) + delta(:, 2), '.');
    xlabel('x'), ylabel('y') % axis labels
    title("Traffic Simulation")
    xlabel("Destinations")
    ylabel("Origins")
    axis([0 N 0 N])
    drawnow

  % Update Rules
    for i = 1:size(agents, 1)
        if agents(i,4) <= agents(i, 3) % End of road
            targets = M(agents(i, 2), :);
            choice = 0; 
            while 1
                choice = randi([1, length(targets)]); % Randomly choose connected path as next path
                if targets(choice) ~= 0
                    break;
                end
            end
            agents(i, :) = [agents(i, 2), choice, speed, M(agents(i, 2), choice)];
        else
            agents(i,4) = agents(i,4) - agents(i, 3); % subtract speed from path (the car is moving)
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
