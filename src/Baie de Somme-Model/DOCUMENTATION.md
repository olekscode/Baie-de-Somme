# Baie de Somme Model Documentation

## Overview
This is an agent-based model simulating the Baie de Somme ecosystem, focusing on human-wildlife interactions. The model is built using Smalltalk and the Cormas framework.

## Model Components

### Main Model (BSModel)
The central class that manages the entire simulation. Key components:
- `theHabitatTypes`: Different types of habitats in the bay
- `theWalkerGuides`: Collection of guided walkers
- `theWalkerAlones`: Collection of independent walkers
- `theSeals`: Collection of seals
- `theBoatKayaks`: Collection of kayaks
- `theBoatMotorizeds`: Collection of motorized boats
- `theRestingPlaces`: Areas where seals can rest
- `theWays`: Paths and walkways
- `theSensitiveHabitats`: Environmentally sensitive areas
- `waysDictionary`: Mapping of paths to their properties
- `numberOfRows`/`numberOfColumns`: Grid dimensions
- `theHomes`: Starting points for agents
- `timer`: Simulation clock

### Agents

#### BSWalker
Base class for all walkers in the simulation. Key attributes:
- `home`: Starting location
- `way`: Current path being followed
- `satisfaction`: Walker's satisfaction level
- `energy`: Walker's energy level
- `sight`: Visual range
- `walkerAction`: Current action (e.g., observation, movement)
- `sealExpectation`: Expectation of seeing seals
- `groupSize`: Size of walking group
- `siteWithSeal`: Location where seals are observed
- `walkerDestination`: Target location
- `walkerPath`: Planned path
- `sealAwareness`: Knowledge of seal locations
- `withBinoculars`: Whether using binoculars

#### BSWalkerGuide
Specialized walker class for guided tours. Inherits from BSWalker.

#### BSWalkerAlone
Specialized walker class for independent walkers. Inherits from BSWalker.

#### BSSeal
Represents seals in the simulation. Key behaviors:
- Resting
- Moving
- Reacting to human presence

#### BSBoat
Base class for all boats. Specialized classes:
- `BSBoatKayak`: Kayaks
- `BSBoatMotorized`: Motorized boats

### Environment

#### BSHabitatCell
Represents individual cells in the simulation grid. Contains:
- Habitat type
- Accessibility rules
- Environmental properties

## Simulation Rules

### Access Rules
The model uses two main access rule matrices:
1. `accessRuleMatrix`: Basic accessibility (30x30 grid)
2. `complexAccessRuleMatrix`: Detailed accessibility (larger grid)

### Movement Rules
- Walkers follow designated paths
- Boats have specific movement patterns
- Seals move between resting places

### Interaction Rules
- Human-seal interactions affect seal behavior
- Different types of visitors have different impacts
- Environmental sensitivity affects access rules

## Key Methods

### Initialization
- `defaultInit`: Sets up the basic environment
- `initialNumberOfPromeneurGuides`: Default number of guided walkers (10)
- `initialNumberOfPromeneurSeuls`: Default number of independent walkers (2)

### Simulation Control
- `step`: Main simulation step
- `initialize`: Sets up the simulation
- `update`: Updates agent states

### Visualization
- `colorOfProbe_*`: Methods for visualizing different aspects of the simulation

## Usage Notes
1. The model can be run in different modes (simple/complex environment)
2. Various parameters can be adjusted to study different scenarios
3. The model tracks multiple metrics for analysis
4. Visualization tools are available for monitoring the simulation

## Best Practices
1. Start with simple scenarios before moving to complex ones
2. Monitor key metrics during simulation runs
3. Use the visualization tools to understand agent behavior
4. Document any parameter changes for reproducibility 