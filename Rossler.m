% Rossler.m - Simulation of the Rössler System using ode45
%
% Equations of the Rössler system:
%   dx/dt = -y - z
%   dy/dt = x + a*y
%   dz/dt = b + x*z - c*z
%
% Constant parameters:
%   a = 0.2, b = a, c = 6.3
%
% This script generates random initial conditions, integrates the Rössler system
% over a specified time span, removes transient dynamics, and plots:
%   - The time series of x(t)
%   - A phase plot of x versus y
%
% Author: Sabneet Bains
% License: MIT License

clear; close all; clc;

%% Parameters
a = 0.2;
b = a;
c = 6.3;

%% Define the Rössler System
% p(1)=x, p(2)=y, p(3)=z
rossler = @(t,p) [ - (p(2) + p(3));
                     p(1) + a * p(2);
                     b + p(1) * p(3) - c * p(3) ];

%% Generate Random Initial Conditions
rng('shuffle');
x0 = 10 * rand;
y0 = 10 * rand;
z0 = 10 * rand;
initialConditions = [x0; y0; z0];

%% Numerical Integration with ode45
tspan = [0 500];
[t, p] = ode45(rossler, tspan, initialConditions);

%% Remove Transients
% Remove the first 5000 data points if available; otherwise, use the full data.
if length(t) > 5000
    t_trim = t(5000:end);
    p_trim = p(5000:end, :);
else
    t_trim = t;
    p_trim = p;
end

%% Plotting Results

% Plot x(t) versus time
figure;
plot(t_trim, p_trim(:,1), 'LineWidth', 1.5);
grid on;
xlabel('Time t');
ylabel('x(t)');
title('Time Series of x(t)');

% Plot phase plot: x versus y
figure;
plot(p_trim(:,1), p_trim(:,2), 'LineWidth', 1.5);
grid on;
xlabel('x');
ylabel('y');
title('Phase Plot: x vs. y');
axis equal;
