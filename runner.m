m = fukui_ishibashi_no_plot(20, 0.5, 0, 500, 62, 6, 1, 25);
disp(m);
x = 1:(ns/steps);
x = steps*x;
plot(x, m.avg_vel, 'b');
title(sprintf("Avg Velocity every %d steps", steps));
xlabel("Time (unit)");
ylabel("Velocity (unit)");
axis([0 ns 0 6]);
figure
plot(x, m.flux, 'r');
title(sprintf("Flux per %d steps", steps));
xlabel("Time (unit)");
ylabel("Flux (cars/20 unit time)");
axis([0 ns 0 5]);