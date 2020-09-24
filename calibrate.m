% perform microphone relative calibration by the microphone switching
% method
% Inputs :
% - 'calib_micNb_1.mat', where mic1 is in position A and micNb in position B
% - 'calib_micNb_2.mat', where mic1 is in position B and micNb in position A
%
% Outputs :
% micCalib, which contains the relative gain and phase of micNb compared to
% mic1
%
% This script should be run one time for each microphone (except mic1)


clear
close all

showPlots = true;

micNb = 3; % microphone number. The reference is always mic1

% frequency range in which the calibration gain is fitted
fmin = 100;
fmax = 6000;

%% choose measurement folder

folder = 'Calibration 3mics';

%% load data

addpath(folder);

file1 = ['calib_mic' num2str(micNb) '_1.mat'];
file2 = ['calib_mic' num2str(micNb) '_2.mat'];

load([folder '/' file1]);
calib(1).data = data;
load([folder '/' file2]);
calib(2).data = data;


%% build frequency vectors

Fs=1/(time(2)-time(1));

NFFT=2^15;
N_ov=NFFT/2;
win=hanning(NFFT);
freq=((0:NFFT/2)*Fs/NFFT).';
omega = 2*pi*freq;

disp(['Frequency resolution ' num2str(freq(2)) 'Hz'])


%% compute FRF


H1 =  tfestimate(calib(1).data(:,micNb),calib(1).data(:,1),win,N_ov); % H = mic1/mic2
H2 =  tfestimate(calib(2).data(:,micNb),calib(2).data(:,1),win,N_ov); % H = mic1/mic2

coh1 =  mscohere(calib(1).data(:,micNb),calib(1).data(:,1),win,N_ov); % coherence micNb / mic1
coh2 =  mscohere(calib(2).data(:,micNb),calib(2).data(:,1),win,N_ov); % coherence micNb / mic1


% plots
if showPlots ==1
	
	% transfer functions amplitude
	figure(1)
	plot(freq,20*log10(abs(H1))); hold on
	plot(freq,20*log10(abs(1./H2)));
	xlabel('Frequency (Hz)');
	ylabel('mod H (-)');
	xlim([fmin,fmax])
	legend('H1','1/H2');
	
	% transfer functions phase
	figure(2)
	plot(freq,180/pi*angle(H1)); hold on
	plot(freq,180/pi*angle(1./H2));
	xlabel('Frequency (Hz)');
	ylabel('arg H');
	xlim([fmin,fmax])
	legend('H12','H21');
	
	% coherence
	figure(3)
	plot(freq,coh1); hold on
	plot(freq,coh2); hold on
	xlabel('Frequency (Hz)');
	ylabel('coherence (-)');
	xlim([fmin,fmax])
	legend('Measurement 1','Measurement 2')
	
end


%% compute relative gain of microphone

g = sqrt(H1.*H2);


%% smooth by fitting a quadratic function

[~,ifmin] = min(abs(freq-fmin));
[~,ifmax] = min(abs(freq-fmax));

pfitMod=polyfit(freq(ifmin:ifmax),abs(g(ifmin:ifmax)),2);
pfitPha=polyfit(freq(ifmin:ifmax),angle(g(ifmin:ifmax)),2);

fitMod = polyval(pfitMod,freq);
fitPha = polyval(pfitPha,freq);

gcal = fitMod.*exp(1i*fitPha);

if showPlots
	figure(5)
	plot(freq,abs(g)); hold on
	plot(freq,abs(gcal));
	xlim([fmin,fmax])
	xlabel('Frequency (Hz)');
	ylabel('mod g (-)');
	legend('g','g fit')
	
	figure(6)
	plot(freq,180/pi*angle(g)); hold on
	plot(freq,180/pi*angle(gcal));
	xlim([fmin,fmax])
	xlabel('Frequency (Hz)');
	ylabel('arg g (deg)')
	legend('g','g fit')
end


%% save calibration data

if exist([folder '/micCalib.mat'], 'file') == 2
	load([folder '/micCalib.mat'])
end

cal(1).g = ones(size(gcal));
cal(micNb).g = gcal;
cal(micNb).freq = freq;

save([folder '/micCalib.mat'], 'cal');
