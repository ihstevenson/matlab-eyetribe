
addpath('..\jsonlab\')
tet = eyetribe();
tet.connect();

% To supress status output initialize with...
%   tet.connect(0);
% To access tracker properties and calibration...
%   tet.trackerProperties.values
% To access real-time data...
%   f = tet.frame

%% A simple demo plotting real-time gaze data...

figure(1); clf
for i=1:600
    f = tet.frame; % note: occasionally get_frame will return a heartbeat frame instead of a data frame
    try
        plot(f.lefteye.raw.x,f.lefteye.raw.y,'o','MarkerSize',f.lefteye.psize+1)
        hold on
        plot(f.righteye.raw.x,f.righteye.raw.y,'o','MarkerSize',f.righteye.psize+1)
        hold off
        xlim([0 tet.trackerProperties.values.screenresw])
        ylim([0 tet.trackerProperties.values.screenresh])
        set(gca,'YDir','reverse'); box off;
        drawnow
    end
    pause(1/tet.trackerProperties.values.framerate/2)
end

%% To save to a file you can use...
% note: these files are ~40KB/s @ 60Hz

tet.record_start('tmp.txt'); % can also be called without a filename, in which case it will use indexing mode (record.txt, record01.txt,...)
pause(10)
tet.record_stop();

%% Disconnect

tet.disconnect();

%% Load gaze data from a file...

F = readTETfile('tmp.txt');
J = loadjson(F);
%%
gazexy =[];
for i=1:length(J)
    if strcmp(J{i}.category,'tracker')
        gazexy = [gazexy; [J{i}.values.frame.time J{i}.values.frame.avg.x J{i}.values.frame.avg.y]];
    end
end
plot(gazexy(:,2),gazexy(:,3),'.-')
1/(mean(diff(gazexy(:,1)))/1000)