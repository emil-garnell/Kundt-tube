function [] = plotScatteringAmplitude(fcut,S,fmin,fmax)

subplot(2,2,1);
plot(fcut,squeeze(abs(S(1,1,:))));
xlabel('Frequency (Hz)');
ylim([0,1.5]);
title('S11')
xlim([fmin,fmax])

subplot(2,2,2);
plot(fcut,squeeze(abs(S(1,2,:))));
xlabel('Frequency (Hz)');
ylim([0,1.5]);
title('S12')
xlim([fmin,fmax])

subplot(2,2,3);
plot(fcut,squeeze(abs(S(2,1,:))));
xlabel('Frequency (Hz)');
ylim([0,1.5]);
title('S21')
xlim([fmin,fmax])

subplot(2,2,4);
plot(fcut,squeeze(abs(S(2,2,:))));
xlabel('Frequency (Hz)');
ylim([0,1.5]);
title('S22')
xlim([fmin,fmax])

end

