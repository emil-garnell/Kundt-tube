clear
close all

debugPlots = true;


%% choose measurement folder

folder = '20200924_scattering_empty';


%% load data

run([folder '/parameters_S.m']);
load([folder '/micCalib.mat']);

Files = dir(fullfile(folder,'case*.mat'));
Nmeas = length(Files);

cases = 1:Nmeas; % choose which cases to use;
% cases = [3 4];
Ncase = length(cases); % number of chosen cases;

cpt = 1;
for ncase = cases
	load([folder '/' Files(ncase).name]);
	meas(cpt).timedata = data;
	cpt = cpt+1;
end


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

Hcal = [cal.g];
 
for ncase = 1:Ncase
	
	% the last channel is always the loudspeaker signal
	meas(ncase).H =  tfestimate(meas(ncase).timedata(:,end),meas(ncase).timedata(:,1:end-1),win,N_ov); % H = mic/loudspeaker
	meas(ncase).coh =  mscohere(meas(ncase).timedata(:,end),meas(ncase).timedata(:,1:end-1),win,N_ov); % coherence mic / loudspeaker
	
    meas(ncase).H = meas(ncase).H.*Hcal;
end


if debugPlots
	
	ncaseplot = 1;
	
	% transfer functions amplitude
	figure(1)
	plot(freq,20*log10(abs(meas(ncase).H/pref)));
	xlabel('Frequency (Hz)');
	ylabel('H = P/LS');
	legend(names{1:4})
	xlim([fmin,fmax])
	
	% coherence
	figure(2)
	plot(freq,meas(ncase).coh);
	xlabel('Frequency (Hz)');
	ylabel('Coherence');
	legend(names{1:4})
	xlim([fmin,fmax])
	
end


%% compute scattering matrix

S = zeros(2,2,Nf);

Nmics = size(meas(1).H,2);

for nf = 1:Nf

	f = fcut(nf);
	w = 2*pi*f;
	k = w/c0;
	
	if Nmics == 4
	Da = [ [exp(-1i*k*x1a) , exp(1i*k*x1a)] ; ...
		   [exp(-1i*k*x2a) , exp(1i*k*x2a)] ];
	Db = [ [exp(-1i*k*x1b) , exp(1i*k*x1b)] ; ...
		   [exp(-1i*k*x2b) , exp(1i*k*x2b)] ];
	elseif Nmics == 6
	Da = [ [exp(-1i*k*x1a) , exp(1i*k*x1a)] ; ...
		   [exp(-1i*k*x2a) , exp(1i*k*x2a)] ; ...
		   [exp(-1i*k*x3a) , exp(1i*k*x3a)] ];
	Db = [ [exp(-1i*k*x1b) , exp(1i*k*x1b)] ; ...
		   [exp(-1i*k*x2b) , exp(1i*k*x2b)] ; ...
		   [exp(-1i*k*x3b) , exp(1i*k*x3b)] ];
	end
	
	Pp = zeros(2,ncase);
	Pm = zeros(2,ncase);
	
	for ncase = 1:Ncase

		Papm = Da\ ( ( meas(ncase).H(nf,1:Nmics/2) ).' ); % [P+ ; P-] side A
		Pbpm = Db\ ( ( meas(ncase).H(nf,Nmics:-1:Nmics/2+1) ).' ); % [P+ ; P-] side B
		
		Pp(1,ncase) = Papm(1);
		Pp(2,ncase) = Pbpm(1);
		Pm(1,ncase) = Papm(2);
		Pm(2,ncase) = Pbpm(2);
		
	end
	
	S(:,:,nf) = Pp*pinv(Pm);
	
end


%% plot scattering matrix

figure(3)
plotScatteringAmplitude(fcut,S,fmin,fmax)

figure(4)
plotScatteringPhase(fcut,S,fmin,fmax)


%% save scattering matrix

save([folder '/scatteringResult.mat'], 'fcut','S');
