%% primary values

% measurement parameters
s1 = 0.05; % microphone separation 1
s2 = 0.05; % microphone separation 2
La = 0.13+0.19; % distance mic-object side A
Lb = 0.13; % distance mic-object side B
L = 0.19; % test object length
D = 0.1; % tube diameter

% physical constants
rho0 = 1.2; % air density
c0 = 343; % speed of sound
pref = 2e-5; % reference pressure

% frequency parameters
fmax=2500;
fmin=20;

comments = '3cm yellow foam';


%% derived values

x1a = La ;
x2a = La - s1;
x3a = La - s1 - s2;

x1b = Lb ;
x2b = Lb - s1;
x3b = Lb - s1 - s2;

Z0 = rho0*c0; % plane wave impedance
S = pi*(D/2)^2; % tube section
