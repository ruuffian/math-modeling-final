## Traffic Flow Simulation

This simulation is an agent-based mode of basic traffic flow, varying parameters such as driving tendencies, speed limits, and traffic light models to show their effects on traffic flow.

#### Proof of Concept

This is a very basic description of the initial model- there are no traffic lights, the roads are very basic, agent behavior is extremely simple.

![Basic ABM Model](assets/images/poc.png)


##### Phase 1

The first phase of the model is to actually generate the terrain. This is done in a few steps- initally, we start with a blank grid that will eventually contain our simulation. Then, we randomly select some points as points of interest (POI)- these will be our origins/destinations. It's okay that the distribution is random- since they will arbitrarily be origins or destinations, it makes sense that they are scattered. Next, we generate semi-random paths between the POI- these will emulate roads. The paths are semi random because the generators will tend to follow already established paths, only branching off when necessary.

##### Phase 2

Now that our terrain is generated, we need to initialize our agents! Here, we take a logical array of POI and select about 20% of them to be origins. Then, we remove the origins from our terrain- we don't want agents headed to origins! After that, each agent will randomly select a destination, and from there will begin to travel towards it along the established roadways. In our POC, the speed limit is uniform, but ideally we can set markers to indicate to agents what the speed limits are along different roadways, and allow agents to choose how closely they follow said speed limits.
