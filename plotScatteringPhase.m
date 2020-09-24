function [] = plotScatteringPhase(fcut,S,fmin,fmax)

subplot(2,2,1);
plot(fcut,180/pi*unwrap(squeeze(angle(S(1,1,:)))));
xlabel('Frequency (Hz)');
title('S11')
xlim([fmin,fmax])

subplot(2,2,2);
plot(fcut,180/pi*unwrap(squeeze(angle(S(1,2,:)))));
xlabel('Frequency (Hz)');
title('S12')
xlim([fmin,fmax])

subplot(2,2,3);
plot(fcut,180/pi*unwrap(squeeze(angle(S(2,1,:)))));
xlabel('Frequency (Hz)');
title('S21')
xlim([fmin,fmax])

subplot(2,2,4);
plot(fcut,180/pi*unwrap(squeeze(angle(S(2,2,:)))));
xlabel('Frequency (Hz)');
title('S22')
xlim([fmin,fmax])

end

