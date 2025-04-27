%% Cardiac Pacemaking Model (Noble 1962)
% This script simulates the membrane potential of a cardiac cell
% based on the Noble 1962 model using the Hodgkin-Huxley formalism.
clear; clc; close all;

% Define Constants
Cm = 12; % Membrane capacitance (in µF/cm^2)
t_max = 1600; % Total simulation time (in ms)
tspan = 0:0.01:t_max; % Time vector

% Initial conditions
y0 = [-70;0.996;0.01;0.32];
[t,y] = ode45(@noble, tspan, y0);

% Set up video writer
videoObj = VideoWriter('MyAnimation.mp4', 'MPEG-4');
videoObj.FrameRate = 30;
open(videoObj);

% Create figure for the static plot first (as in your original code)
figure;
plot(t, y(:,1),'LineWidth',2);
title('Membrane Potential Over Time');
xlabel('Time (ms)');
ylabel('Membrane Potential (mV)');
grid on;
xticks(0:100:1600);

% Making the arrows, normalising the coordinates since annotations only takes
% values between 0 and 1
ax = gca;
xlimits = ax.XLim;
ylimits = ax.YLim;

% Function to normalize coordinates for annotation
norm_x = @(x) (x - xlimits(1)) / (xlimits(2) - xlimits(1));
norm_y = @(y) (y - ylimits(1)) / (ylimits(2) - ylimits(1));

annotation('arrow', [norm_x(210) norm_x(210)], [norm_y(-60) norm_y(-40)], 'LineWidth', 2); % Upward arrow (Depolarization)
annotation('arrow', [norm_x(450) norm_x(480)], [norm_y(-50) norm_y(-70)], 'LineWidth', 2); % Downward arrow (Repolarization)
annotation('arrow', [norm_x(600) norm_x(700)], [norm_y(-78) norm_y(-75)], 'Color', 'b', 'LineWidth', 2); % Blue horizontal arrow (Diastolic Depolarization)
text(550, -75, 'DD', 'FontSize', 14, 'FontWeight', 'bold');
text(900, 20, 'AP', 'FontSize', 14, 'FontWeight', 'bold');

% Create a new figure for animation
figure;
h = plot(nan, nan, 'r', 'LineWidth', 2);
title('Membrane Potential Over Time (Animated)');
xlabel('Time (ms)');
ylabel('Membrane Potential (mV)');
grid on;
xticks(0:100:1600);
axis([0 t_max -90 40]);

% Animation loop - keep it simple
numFrames = 200; % Adjust this number to control animation speed
step = round(length(t)/numFrames);
indices = 1:step:length(t);

for i = 1:length(indices)
    idx = indices(i);
    set(h, 'XData', t(1:idx), 'YData', y(1:idx,1));
    drawnow;
    
    % Capture the frame
    frame = getframe(gcf);
    writeVideo(videoObj, frame);
end

% Close the video
close(videoObj);
disp('Animation complete! Video saved as MyAnimation.mp4');
