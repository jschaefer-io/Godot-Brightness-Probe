# Brightness Probe
This repository contains a basic implementation of a brightness/ light-level detection in the Godot Engine.
The Brightness-Probe currently supports all Light Nodes (OmniLight, SpotLight, DirectionalLight) but is not
yet configured to handle ambient light.

## Node Types
This addons comes with three Nodes, allowing granual control on which light sources are requested, which obstacle are ignored
and when to determine the light level.

### BrightnessResolver
The BrightnessResolver Node is placed as a direct child Node of a Godot Light. This Node is used by the other Nodes to resolve
a points light level relative to the parent Light. The main method to query the light level is it's public `get_light_level`-Method.

### BrightnessCollector
A BrightnessCollector Node manages a collection of Points, on which a light-level-check is to be executed. It's configured through
a small number of exported values.

- **Exluce Paths:** \
  Array of NodePath's which are explicitly excluded when doing any raycasts
- **Raycast Layers:** \
  A Collision Bit-Mask determining on which layer the raycasts are executed
- **Collector Group:** \
  The Groupname of all BrightnessResolver-Nodes which this BrightnessCollector is aggregating it's light level from.
 
 A BrightnessCollector must have a collection of BrightnessProbe's as it's direct children. When the BrightnessCollector's
 public `collect()`-Method is called, a brightness check is executed on all BrightnessProbes and the average brightness is returned as
 a float value from 0 to 1. (0 is Absolute Darkness)
 
 ### BrightnessProbe
 A BrightnessProbe is a singular Point, which on which a Light-Level check is executed. It inherits from Spatial and can be freely
 positioned within the BrightnessCollector. A BrightessProbe exports one value.
 
 - **Influence**: \
   The Influence value determines the impact of this BrightnessProbe is when calculating the average brightness value from all
   BrightnessProbes. An influence of 2 means, this BrightnessProbe's light-level gets counted twice.
   
***@todo***: \
In the future, BrightnessProbes will be able to be freely attached to any Node within the
same scene in order to attach them to animated/moving Nodes.
   
## Usage
1. Add a BrightnessResolver as Child Node to any Light in your Scene
2. Add the BrightnessResolver to a new Group.
3. Add a BrightnessCollector as a Child Node to an Object, for which you want to query the brigthness
4. Set the group name as the Collectors exported "Collector Group"-Value
5. Add at least one BrightnessProbe as a Child Node to the BrightnessCollector
6. Call the Collectors `collect()`-Method to query the light level

***@todo***: \
In the future, an example project will be added to this addon
   
