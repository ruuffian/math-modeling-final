function fukui_ishibashi(steps_p, p_slow_p, p_change_p, road_length_p, num_vehicles_p, v_max_p, lanes_p, chunk_length_p)
% A basic implementation of the Fukui-Ishibashi cellular automaton model.
% The key difference between this and the Nagel-Schreckenberg models are
% that agents are incentivized to accelerate to the maximum allowable
% velocity at each step, rather than only increase by 1 per step. Another
% big change is the addition of multi-lane traffic- there can be
% arbitrarily many lanes, each of which is color coded to the velocity
% graph above it.
clf
% Parameters
road_length = road_length_p;      % Length of road (m)
num_vehicles = num_vehicles_p;      % Number of vehicles
v_max = v_max_p;              % Maximum speed (m/s)
p_slow = p_slow_p;           % Probability of slowing down
p_change = p_change_p;         % Probability of changing lanes
ns = 3000;              % Duration of simulation (s)
lanes = lanes_p;              % # of lanes
colors = linspecer(lanes); % RGB colors for each lane
% Initialize vehicle positions
for q = 1:lanes
    positions{q} = round(road_length/lanes) * q; % Every lane starts with 1 car in it.
end
for i = 4:num_vehicles
    lane = randi(lanes); % Pick lane;
    idx = length(positions{lane})+1; % convert from linear index to cell index;
    positions{lane}(idx) = randi(road_length);
    while length(unique(positions{lane})) ~= length(positions{lane})
        positions{lane}(idx) = randi(road_length); % We don't preallocate to ensure cars dont start in the same cell
    end
end
for q = 1:lanes
    positions{q} = sort(positions{q});
end

% Main loop
for t = 0:ns
    % Step 1: Increase velocity
    for q = 1:lanes
        velocities{q} = v_max * ones(1, length(positions{q}));
    end
    % Step 2: Lane Change
    for q = 1:lanes
        idx = rand(1, length(positions{q}))...
            < p_change; % Select the cars that are looking for a lane change
        cur_lane = positions{q}(idx);
        directions = randi(2, 1, sum(idx));
        % Handle each lane change
        for k = 1:length(directions)
            updown = directions(k);
            cur_car = cur_lane(k);
            if updown == 1 % Lane change up
                if q > 1 % Skip first lane upward lane change
                    up_lane = positions{q-1};
                    if ismember(cur_car, up_lane)
                        continue; % Do not lane change if car is next to you
                    end
                    % Update data with lane changes
                    positions{q-1} = sort([positions{q-1} cur_car]); % Add new cars into new lane
                    index = find(positions{q} == cur_car); % Find old data index
                    velocities{q-1} = insert_val(velocities{q-1}, velocities{q}(index), index);
                    % Delete old data
                    positions{q}(index) = [];
                    velocities{q}(index) = [];
                end 
            else % Lane change down
                if q < lanes % Skip last lane downward lane change
                    down_lane = positions{q+1};
                    if ismember(cur_car, down_lane)
                        continue; % Do not lane change if car is next to you
                    end
                    % Update data with lane changes
                    positions{q+1} = sort([positions{q+1} cur_car]);
                    index = find(positions{q} == cur_car);
                    velocities{q+1} = insert_val(velocities{q+1}, velocities{q}(index), index);
                    % Delete old data
                    positions{q}(index) = [];
                    velocities{q}(index) = [];
                end
            end
        end
    end
    % Step 3: Account for car in front
    for q = 1:lanes
        if isempty(positions{q})
            continue;
        end
        lane_shift = circshift(positions{q}, -1);
        gap{q} = lane_shift(1:end-1) - positions{q}(1:end-1);
        gap{q}(end+1) = road_length - positions{q}(end) + lane_shift(end); % boundary
        velocities{q} = min(velocities{q}, gap{q}-1); 
    end
    % Step 4: Stochasticity in velocity
    for q = 1:lanes
        idx = rand(1, length(positions{q})) < p_slow;
        velocities{q}(idx) = max(velocities{q}(idx) - 1, 0);
    end
    % Step 5: Movement
    for q = 1:lanes
        positions{q} = positions{q} + velocities{q};
    end
    % Step 6: Periodic Boundary
    for q = 1:lanes
        positions{q} = mod(positions{q}, road_length);
        positions{q} = sort(positions{q}); % As stated above, we MUST sort every time step.
    end
    % Plotting
    clf
    hold on
    % Plot per-lane
    for q = 1:lanes
        plot(positions{q}-.5,positions{q}*0-q,'.','Color',colors(q, :),'markersize', 10);
        plot(positions{q}-.5,velocities{q},'.:','Color',colors(q, :),'markersize',12) % and plot velocities
    end
    hold off
    axis([0,road_length,-(lanes + 2),v_max+1])
    title(sprintf('Fukui-Ishibashi model after %d steps',t))
    xlabel('position'), ylabel('velocity')
    pause(1e-1) % wait a bit
end


end

function [a] = insert_val(a, val, idx)
% Utility function to insert a value(s) into a specific index(ces) of a vector
    for i = 1:length(idx)
        a = [a(1:length(a) < idx(i)), val(i), a(1:length(a) >= idx(i))];
    end
end