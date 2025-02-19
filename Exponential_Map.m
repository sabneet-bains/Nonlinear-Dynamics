function exponential_map_main()
% exponential_map_main - Bifurcation diagram simulation for the exponential map
%
% This script simulates the map:
%   x(n+1) = x(n) * exp(lambda*(1 - x(n)))
% for lambda values ranging from 1.5 to 4.0. For each lambda, the system is
% iterated 512 times and the initial transient dynamics (first 255 iterations)
% are discarded. The resulting values are plotted in a bifurcation diagram.
%
% Author: Sabneet Bains
% License: MIT License

    try
        %% Initialization
        clear; close all; clc;
        
        % Preallocate arrays to store simulation results
        xResults = [];
        lambdaResults = [];
        
        % Define parameter range for lambda
        lambdaVals = 1.5:0.001:4;
        
        % Simulation parameters
        numIterations = 512;      % Total iterations per lambda
        transientCutoff = 255;    % Remove the first 255 iterations
        
        %% Main Loop: Iterate the map for each lambda
        for lambda = lambdaVals
            % Preallocate the vector for iterates
            xn = zeros(numIterations, 1);
            
            % Set the initial condition and compute the first iterate
            x0 = 0.5;
            xn(1) = x0 * exp(lambda * (1 - x0));
            
            % Iterate the map using a for-loop
            for i = 1:(numIterations - 1)
                xn(i+1) = xn(i) * exp(lambda * (1 - xn(i)));
            end
            
            % Remove transient dynamics
            xn_trimmed = xn(transientCutoff+1:end);
            
            % Create a vector of lambda values corresponding to xn_trimmed
            lambda_vector = lambda * ones(size(xn_trimmed));
            
            % Append the results for this lambda
            xResults = [xResults; xn_trimmed];
            lambdaResults = [lambdaResults; lambda_vector];
        end
        
        %% Plotting the Bifurcation Diagram
        figure;
        plot(lambdaResults, xResults, '.', 'MarkerSize', 1);
        xlabel('\lambda');
        ylabel('x_n');
        title('Bifurcation Diagram for x(n+1) = x(n) * exp(\lambda (1 - x(n)))');
        grid on;
        
    catch ME
        fprintf('An error occurred: %s\n', ME.message);
    end
end

% Run the main function if this script is executed directly
if ~isdeployed
    exponential_map_main();
end
