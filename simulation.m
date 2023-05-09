% In order to run individual situations, comment out the previous ones to
% save compute time. Also, fukui_ishibashi_no_plot generates avg vel and
% flux graphs, while fukui_ishibashi() actually runs the simulation.

clear
ns = 3000;
steps = 20;

% Equivalent conditions to Nagel-Schreckenberg
% As an example of how this model expands on the nagel-schreckenberg model,
% here are the parameters that make it identical in setup. So, the
% difference between this run and the NS model is purely in update rules.
NS_metrics = fukui_ishibashi_no_plot(steps, .5, 0, 500, 62, 6, 1, 50);

% Plotting
disp(NS_metrics);
x = 1:(ns/steps);
x = steps*x;
plot(x, NS_metrics.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, NS_metrics.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changing Some Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 'Default' FI conditions
% This is what I would consider the 'default' conditions for this model. A
% three lane road, decently populated with a decent amount of lane changes
% and 50% chance to slow down while driving.
DEF_metrics = fukui_ishibashi_no_plot(steps, 0.5, 0.3, 125, 62, 6, 4, 25);

% Plotting
disp(DEF_metrics);
x = 1:(ns/steps);
x = steps*x;
plot(x, DEF_metrics.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, DEF_metrics.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 2]);

% Increase lane change prob
LC_metrics = fukui_ishibashi_no_plot(steps, 0.5, 0.6, 125, 62, 6, 4, 25);

% Plotting
disp(LC_metrics);
x = 1:(ns/steps);
x = steps*x;
plot(x, LC_metrics.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, LC_metrics.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 2]);

% Increase slow down prob
SD_metrics = fukui_ishibashi_no_plot(steps, 0.8, 0.3, 125, 62, 6, 4, 25);

% Plotting
disp(SD_metrics);
x = 1:(ns/steps);
x = steps*x;
plot(x, SD_metrics.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, SD_metrics.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 2]);

% Decrease slow down prob
SD2_metrics = fukui_ishibashi_no_plot(steps, 0.1, 0.3, 125, 62, 6, 4, 25);

% Plotting
disp(SD2_metrics);
x = 1:(ns/steps);
x = steps*x;
plot(x, SD2_metrics.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, SD2_metrics.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 2]);

% Increase car density
ICD_metrics = fukui_ishibashi_no_plot(steps, 0.5, 0.3, 125, 124, 6, 4, 25);

% Plotting
disp(ICD_metrics);
x = 1:(ns/steps);
x = steps*x;
plot(x, ICD_metrics.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, ICD_metrics.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 2]);

% More lanes and more cars
ML_metrics = fukui_ishibashi_no_plot(steps, 0.5, 0.3, 125, 300, 6, 8, 25);

% Plotting
disp(ML_metrics);
x = 1:(ns/steps);
x = steps*x;
plot(x, ML_metrics.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, ML_metrics.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 2]);

%%%%%%%%%%%%%%
% Situations %
%%%%%%%%%%%%%%

% Longer road, Lots of cars, rainy -> higher slowdown chance & less lane
% change chance
fukui_ishibashi(steps, 0.8, 0.1, 1000, 1000, 6, 3, 100);
SIT1_metrics = fukui_ishibashi_no_plot(steps, 0.8, 0.1, 1000, 1000, 6, 3, 100);

% Plotting
disp(SIT1_metrics);
x = 1:(ns/steps);
x = steps*x;
plot(x, SIT1_metrics.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, SIT1_metrics.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 2]);

% Same road under low density, good weather so less slowdown and more lane
% changes

fukui_ishibashi(steps, 0.2, 0.5, 1000, 1000, 6, 3, 100);
SIT2_metrics = fukui_ishibashi_no_plot(steps, 0.2, 0.5, 1000, 1000, 6, 3, 100);

% Plotting
disp(SIT2_metrics);
x = 1:(ns/steps);
x = steps*x;
plot(x, SIT2_metrics.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, SIT2_metrics.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 2]);