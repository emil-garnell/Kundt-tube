# Kundt-tube

Matlab scripts to perform scattering matrix measurements and reflection coefficien measurements in a B&K Kundt Tube

The documentation for the different steps is available as pdf in the Documentation folder.

## Step 1 : microphone calibration
Aquisition using acquisitionScattering.m or acquisition1P.m.
The goal is to get the relative gain and phase of each microphone compared to microphone 1. This is done by the microphone switching method.
Place mic1 and micN in the tube at positions A and B, play a sweep and record time signals. Switch the position of mic1 and micN and measure again.
Run calibrate.m to obtain the relative gain of micN compared to mic1. 

Repeat this for all microphones.

## Scattering matrix measurement
Aquisition using acquisitionScattering.m
Play a sweep and measure microphone signals. Change the boundary conditions at the end of the tube and reapeat. Use computeScattering.m to obtain scattering matrix.

## Reflection coefficient measurement
Aquisition using acquisition1P.m
Play a sweep and measure microphone signals. Use compute1P.m to obtain the reflection coefficient.

You can tune a Delany Bazeley Miki model on the measured reflection coefficient by using the DelanyBazeleyReflection.m script.
