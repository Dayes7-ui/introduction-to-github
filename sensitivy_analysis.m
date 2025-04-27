%% Cardiac Pacemaking Model (Noble 1962) Sensitivity on Cm (Separate Graphs)
clear; clc; close all;

% Define parameters
t_max = 1500;  % Total simulation time (in ms)
tspan = 0:0.01: t_max;  % Time vector
y0 = [-70; 0.996; 0.01; 0.32];  % Initial conditions
options = odeset('RelTol',1e-2,'AbsTol',1e-1);

% Test different Cm values
Cm_values = [6, 12, 24];  % (in µF/cm^2)
colors = ['r','k','b'];   % red, black, blue

% Run simulation for each Cm value and plot in separate figures
for i = 1:length(Cm_values)
    Cm = Cm_values(i);
    
    % Run the simulation
    [t, y] = ode23tb(@(t,y) noble(t,y,Cm), tspan, y0, options);
    
    % Create new figure
    figure;
    plot(t, y(:,1), 'Color', colors(i), 'LineWidth', 2);
    
    % Format plot
    title(['Membrane Potential with Cm = ', num2str(Cm), ' \muF/cm^2']);
    xlabel('Time (ms)');
    ylabel('Membrane Potential (mV)');
    grid on;
end
