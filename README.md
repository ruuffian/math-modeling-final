
## Introduction

Traffic flow is one of the most commonly found applications of mathematics and modeling. As the world has grown larger and larger, with more and more complex road systems, vehicles, and logistical problems for non-passenger traffic, the need for quality traffic simulations has grown with it. 

## Methods

There are a lot of assumptions being made in this model. Unfortunately, traffic systems in the real world are extremely complex. An entire paper could be written on just a driver's behavior, and that doesn't even take into account things like car model, destinations, multi-road systems- there is so much that can be added to a traffic model to simulate reality. My model takes a lot of inspiration from the Nagel-Schreckenberg model that was covered in class, with some important modifications. In this simplified cellular automaton model, agents consist of 'unit' vehicles on a road. These vehicles follow some simple update rules moving left to right, and uses periodic boundary limits to wrap cars off the right side of the screen back to the left. There also exists the notion of lanes, meaning cars can exist parallel to each other as long as they are in different lanes.

#### Update Rules
1. `All agents accelerate to v_max`
2. `Agents lane change with probability p_change and choose 'up' or 'down' with probability 50%`
3. `Slow down if car in front is close`
4. `Stochastically deccelerate`
5. `Move forwards = velocity`
6. `Account for boundary`

As you can see, the update rules are very simple. The most important choice of update rule is the first step, where each agent accelerates to max velocity. This allows the model to achieve 'optimal' traffic flow very easily. Since agents are always going as fast as allowed, 

#### Plotting

The plotting for this model is basically a carbon copy of the plotting done by Professor Seibold in his implementation of Nagel-Schreckenberg, with an important change- the support for n-lanes. Each lane is plotted below the x axis at y = -1, y = -2 etc. To match the lanes to the velocities, a color generating function found [here](https://www.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap) was used to generate the colors. This function was extremely useful, as it made separating the lanes very easy. I was worried that I would have to plot each lane as a subplot, which would have significant performance impact and also limit the number of lanes much more than the current implementation.

## Results

First, lets take a look at how this model handles the most basic traffic system- a single road, 50% slowdown chance, relatively low car density.

![Basic Configuration](final-project/assets/ns_default.gif)

In this situation, the model quickly reaches equilibrium. Since there are no lane changes, the model does not have any interruptions and remains this way until the simulation ends. Clearly, this traffic model performs extremely well for low density, single-lane traffic. I expect this is because of the semi-unrealistic assumption that drivers will always attempt to drive at v_max. What happens when we expand this simulation to multiple lanes?

![Basic 4-lane traffic](final-project/assets/fi_default.mp4)

Here we can see much more traffic jams than before. This is caused primarily by the lane changes- everyone keeps cutting each other off! Since the logic for lane changes only checks if a car is directly in the space next to the agent, cutoffs are very frequent. But, since each agent accelerates out of the jam immediately, the jam evaporates quickly. Most drivers would probably be more frustrated in these conditions, since the flow is start-stop and there are frequent slowdowns, compared to our original model where the flow was very uniform. Lets compare these two situations using two very basic metrics- average velocity and flux per 20 steps.


| Average Velocity                          | Flux                            |
| ----------------------------------------- | ------------------------------- |
| ![NS velocity](assets/ns_vel.png)         | ![NS Flux](assets/ns_flux.png)  |
| ![FI default velocity](assets/fi_vel.png) | ![FI default flux](fi_flux.png) |

Before I ran this simulation, I expected the first set of parameters to have both a higher average velocity and a higher flux. However, we see the single-lane simulation hovering just above 0.5 cars per 20 time steps, and the 4-lane simulation sits right above 2 cars/20ts, or roughly 4x. This was surprising to me at first, as I assumed a higher avg velocity would lead to agents more quickly traversing the 
## Conclusion

## References

Here is a list of links to various articles, research papers, and videos that I looked at throughout this project. I did not incorporate everything from all of these resources, but I figured they would be of interest to anyone who wanted to learn more about traffic modelling.

[A Review of Traffic Simulation Software, by G. Kotusevski and K.A. Hawick](https://mro.massey.ac.nz/bitstream/handle/10179/4506/TrafficSimulatorReview_arlims.pdf?sequence=1&isAllowed=y)