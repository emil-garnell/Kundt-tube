close all
clear

%% parameters

Fs=44100; % sampling frequency
T=4; % measurement time in s

F_low = 20; % low frequency limit (Hz)
F_high = 10000; % high frequency limit (Hz)

time=linspace(0,T,Fs*T)'; % time for signal 
N=length(time); % number of samples

folder = '20200924_scattering_empty';
savename='case3';


%% Build output signal

% chirp
sig=chirp(time,F_low,T,F_high,'quadratic',90);

% frequency filtered white noise
% s_wn = 2*rand(N,1)-1;
% d = fdesign.lowpass('Fp,Fst,Ap,Ast',F_high/Fs*2,F_high/Fs*2*1.5,1,40);
% Hd = design(d,'equiripple');
% b=coeffs(Hd);
% s_wn_filt = fftfilt(b.Numerator,s_wn);
% sig = s_wn_filt/max(abs(s_wn_filt)); % amplitude max = ratio


%% plot output signal
figure
plot(time,sig)

xlabel('Time (s)')
ylabel('Amplitude (V)')
title('Excitation signal')


%% Data Acquisition Session

% create session
s = daq.createSession('ni');

% To get the list of devices connected to the
% computer, type "daq.reset", and then "daq.getDevices"
% Look at the derive list and choose right device.
device='Dev1';

% Add Input Channels to Session
addAnalogInputChannel(s,device,'ai0','Voltage'); % mic1
addAnalogInputChannel(s,device,'ai1','Voltage'); % mic2
addAnalogInputChannel(s,device,'ai2','Voltage'); % mic3
addAnalogInputChannel(s,device,'ai3','Voltage'); % mic4
addAnalogInputChannel(s,device,'ai6','Voltage'); % loudspeaker

names = {'mic1','mic2','mic3','mic4','loudspeaker'};

mic_gain = 1/0.0316; % (Pa/V)

scaling(1) = mic_gain; 
scaling(2) = mic_gain; 
scaling(3) = mic_gain; 
scaling(4) = mic_gain; 
scaling(5) = 1; %(V/V)
N_chan=length(names);


% Add output Channels to Session
addAnalogOutputChannel(s,device,'ao1','Voltage');

% Set session properties
s.Rate = Fs; % sampling rate

% send the output signal to the right output
queueOutputData(s,sig);

% lauch measurement
[data,time] = s.startForeground;


%% plot time signals

for n = 1:length(names)
figure(10+n);
plot(time,data(:,n));
xlabel('Time (secs)');
ylabel('measured amplitude (V)')
legend(names{n})
end


%% save data

for n = 1:size(data,2)
    data(:,n) = data(:,n)*scaling(n);
end

mkdir(folder);
save([folder '/' savename],'data','time','names');
