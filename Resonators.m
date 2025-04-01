%% Cardiac Pacemaking Model (Noble 1962)
% This script simulates the membrane potential of a cardiac cell
% based on the Noble 1962 model using the Hodgkin-Huxley formalism.

clear; clc; close all;

%% Define Constants
Cm = 12;  % Membrane capacitance (in µF/cm^2)

t_max = 1500;  % Total simulation time (in ms)
tspan = 0:0.01: t_max;  % Time vector


% Initial conditions

y0= [-70;0.996;0.01;0.32];

[t,y]= ode45(@noble, tspan,y0); 


%Plot Results
figure;
plot(t, y(:,1),'LineWidth',2);
title('Membrane Potential Over Time');
xlabel('Time (ms)');
ylabel('Membrane Potential (mV)');
grid on;
%Making the arrows, normalising the cordinates since annotations only takes
%values between 0 and 1
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

hold off;
