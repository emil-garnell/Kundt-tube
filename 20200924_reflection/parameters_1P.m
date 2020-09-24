%% primary values

% measurement parameters
s1 = 0.05; % microphone separation 1
s2 = 0.05; % microphone separation 2

L = 0.19; % distance mic-object side A
D = 0.1; % tube diameter

% physical constants
rho0 = 1.18; % air density
c0 = 346; % speed of sound
pref = 2e-5; % reference pressure

% frequency parameters
fmax=2500;
fmin=100;

% any comments, to describe the test
comments = 'hard wall';


%% derived values

x1a = L;
x2a = L - s1;
x3a = L - s1 - s2;

Z0 = rho0*c0; % plane wave impedance
S = pi*(D/2)^2; % tube section

