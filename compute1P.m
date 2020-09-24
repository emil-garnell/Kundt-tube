clear
close all

debugPlots = 1;


%% choose measurement folder

folder = '20200924_reflection';

ncase = 2; % measurement number

%% load data

addpath(folder);

run('parameters_1P.m');

Files = dir(fullfile(folder,'case*.mat'));
Nmeas = length(Files);

load([folder '/' Files(ncase).name]);

load([folder '/micCalib.mat']);

Nmics = size(data,2)-1;


%% build frequency vectors
Fs=1/(time(2)-time(1));

NFFT=2^15;
N_ov=NFFT/2;
win=hanning(NFFT);
freq=((0:NFFT/2)*Fs/NFFT).';
omega = 2*pi*freq;

disp(['Frequency resolution ' num2str(freq(2)) 'Hz'])

[~,ifmin] = min(abs(freq-fmin));
[~,ifmax] = min(abs(freq-fmax));

fcut = freq(ifmin:ifmax);
Nf = length(fcut);


%% compute FRF

H =  tfestimate(data(:,end),data(:,1:end-1),win,N_ov); % H = mic/loudspeaker
coh =  mscohere(data(:,end),data(:,1:end-1),win,N_ov); % coherence mic / loudspeaker

% apply relative calibration
Hcal = [cal.g];
H = H.*Hcal;


if debugPlots ==1
	
	% transfer functions amplitude
	figure(1)
	plot(freq,20*log10(abs(H/pref)));
	xlabel('Frequency (Hz)');
	ylabel('H = P/LP');
	xlim([fmin,fmax])
	
	% coherence
	figure(2)
	plot(freq,coh);
	xlabel('Frequency (Hz)');
	ylabel('H = P/LP');
	xlim([fmin,fmax])
	
end


%% compute scattering matrix

Papm = zeros(2,Nf);

for nf = 1:Nf
	
	f = fcut(nf);
	w = 2*pi*f;
	k = w/c0;
	
	if Nmics==2
		Da = [ [exp(-1i*k*x1a) , exp(1i*k*x1a)] ;...
			   [exp(-1i*k*x2a) , exp(1i*k*x2a)] ];
	elseif Nmics==3
		Da = [ [exp(-1i*k*x1a) , exp(1i*k*x1a)] ;...
			   [exp(-1i*k*x2a) , exp(1i*k*x2a)] ;...
			   [exp(-1i*k*x3a) , exp(1i*k*x3a)] ];
	end

	Papm(:,nf) = pinv(Da)*H(nf,1:Nmics).'; % [P+ ; P-] side A
	
end

R = Papm(1,:)./Papm(2,:);

%% plot Reflection coefficient

figure(3)
plot(fcut,abs(R));
ylabel('mod R (-)')
xlabel('Frequency (Hz)')
ylim([0,1.2])

figure(4)
plot(fcut,180/pi*unwrap(angle(R)));
ylabel('arg R (deg)')
xlabel('Frequency (Hz)')


%% save scattering matrix

save([folder '/1PResult.mat'], 'fcut','R');
