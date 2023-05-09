function nagel_schreck(P)
%   Cellular automaton model for vehicular traffic flow.
%   Implemented is the Nagel-Schreckenberg model. Each cell
%   carries a number. 0 means the cell is unoccupied, while
%   a positive number means that a vehicle occupies the
%   cell, and the vehicle speed is one less than the value
%   stored.
%
% 03/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = 400; % number of cells
p = P.p_slow; % probability of velocity reduction
v_max = 6; % maximum velocity
ns = 1000;
steps = P.steps;
plot = 1;

% Initialization
x = double(mod(1:n,20)==0); % place cars equidistantly and at rest initially
avg = zeros(1, round(ns/steps)+1);
count = sum(x);
% Computation
for j = 1:ns % time loop  

    % Update rule (4 steps)
    %Step 1: All cars velocity increases by 1
    x(x>0) = min(x(x>0),v_max)+1;
    %Step 2: Check velocity of cars in front of them
    ind_car = find(x>0); % indices of cells with a car in them
    headway = diff([ind_car,ind_car(1)+n])-1; % number of void cells ahead
    xi = x(ind_car); % values of cell with cars in them
    xi = min(xi,headway+1); % reduce velocity to headway
    %Step 3: Randomly reduce the velocity of all cars with v>0
    xi = max(xi-(rand(size(xi))<p),1); % reduce velocity randomly
    %Step 4: Move each car based on its velocity
    ind_new = mod(ind_car+xi-2,n)+1; % new car indices
    % Create new state vector
    x = x*0; x(ind_new) = xi; % assign values to new car positions
    
    if plot == 1
        % Plotting
        cp = find(x>0); % vehicle positions
        clf
        plot(cp-.5,cp*0-1,'r.',... % plot cars
            cp-.5,x(cp)-1,'b.:','markersize',12) % and plot velocities
        axis([0,n,-3,v_max+1])
        title(sprintf('Nagel-Schreckenberg model after %d steps',j))
        xlabel('position'), ylabel('velocity')
        pause(1e-2) % wait a bit
    end
    % Calculate avg velocity
    if mod(j, steps) == 0
        avg(j/steps + 1) = sum(x) / count;
    end
end
