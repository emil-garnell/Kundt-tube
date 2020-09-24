clear


%% parameters

% folder = '20200630_grey_foam';
folder = '20200630_grey_foam_2';
% folder = '20200630_white_foam';

load([folder '/Result.mat']);

cols = ecolors(4,'thesis');

%% constants

rho0 = 1.204;
c0 = 346;

d = 0.04; % sample thickness (grey foam)
% d = 0.032; % sample thickness (white foam)

w = 2*pi*fcut;
Nf = length(fcut);

%% plot measured R

figure(1)
clf
plot(fcut,abs(R),'Color',cols(3,:)); hold on
ylabel('$|R|$ (-)','Interpreter','latex')
xlabel('Frequency (Hz)')

figure(2)
clf
plot(fcut,180/pi*unwrap(angle(R))+360,'Color',cols(3,:)); hold on
ylabel('arg $R$ (deg)','Interpreter','latex')
xlabel('Frequency (Hz)')


%% Computed reflection coefficient

sigma = 13e3; % grey foam
% sigma = 5e3; % white foam

% Zc=rho0*c0* ( 1 + 5.50*(1e3*fcut/sigma).^(-0.632) - 1i*8.43*(1e3*fcut/sigma).^(-0.632) );
% kc=w/c0.* ( 1 + 7.81*(1e3*fcut/sigma).^(-0.618) - 1i*11.41*(1e3*fcut/sigma).^(-0.618) );

% frequency independant delany bazeley
fref = 1000;
Zc=rho0*c0* ( 1 + 5.50*(1e3*fref/sigma).^(-0.632) - 1i*8.43*(1e3*fref/sigma).^(-0.632) );
kc=w/c0.* ( 1 + 7.81*(1e3*fref/sigma).^(-0.618) - 1i*11.41*(1e3*fref/sigma).^(-0.618) );

Z0 = rho0*c0;
k0 = w/c0;

% Zc = Z0;
% kc = k0;

a11 = exp(-1i*k0*d);
a12 = -( exp(-1i*kc*d) + exp(1i*kc*d) );
a21 = exp(-1i*k0*d)/Z0;
a22 = -( exp(-1i*kc*d) - exp(1i*kc*d) )./Zc;

b1 = -exp(1i*k0*d);
b2 =  exp(1i*k0*d)/Z0;

A(1,1,:) = a11;
A(1,2,:) = a12;
A(2,1,:) = a21;
A(2,2,:) = a22;

B(1,:) = b1;
B(2,:) = b2;

for nf = 1:Nf
	P(:,nf) = squeeze(A(:,:,nf))\B(:,nf);
end

Rcalc = P(1,:);


%% plot computed R

figure(1)
plot(fcut,abs(Rcalc),'Color',cols(4,:)); hold on
legend('Measured','Computed')

figure(2)
plot(fcut,180/pi*unwrap(angle(Rcalc)),'Color',cols(4,:)); hold on
legend('Measured','Computed')











