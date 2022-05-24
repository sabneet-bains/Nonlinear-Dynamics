classdef SIQR_Cellular_Automaton < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        COVID19SIQR2DCellularAutomatonUIFigure  matlab.ui.Figure
        RUNButton              matlab.ui.control.StateButton
        QuarantineRateLabel    matlab.ui.control.Label
        RecoveryRateLabel      matlab.ui.control.Label
        LockdownStrengthLabel  matlab.ui.control.Label
        q_Label                matlab.ui.control.Label
        q_control              matlab.ui.control.Knob
        gamma_Label            matlab.ui.control.Label
        gamma_control          matlab.ui.control.Knob
        alpha_Label            matlab.ui.control.Label
        alpha_control          matlab.ui.control.Knob
        UIAxes                 matlab.ui.control.UIAxes
    end

    % COVID-19: SIQR 2D Cellular Automaton Simulation
    % Forked from "Modeling and Simulating Social Systems with MATLAB" by
    % Stefano Balietti and Karsten Donnay (http://www.soms.ethz.ch/matlab)
    
    % Parameter values obtained from "Exact properties of SIQR model for COVID-19"
    % by Takashi Odagaki (https://doi.org/10.1016/J.PHYSA.2020.125564)

    % Callbacks that handle component events
    methods (Access = private)

        % Callback function
        function alpha_controlValueChanged(app, event)

        end

        % Callback function
        function gamma_controlValueChanged(app, event)
          
        end

        % Callback function
        function q_controlValueChanged(app, event)
          
        end

        % Callback function
        function RUNButtonPushed(app, event)

        end

        % Value changing function: alpha_control
        function alpha_controlValueChanging(app, event)
            % Strength of lockdown measures:
            app.alpha_Label.Text = num2str(round(event.Value,2));
            drawnow()
        end

        % Value changing function: gamma_control
        function gamma_controlValueChanging(app, event)
            % Recovery rate:
            app.gamma_Label.Text = num2str(round(event.Value,2));
            drawnow()
        end

        % Value changing function: q_control
        function q_controlValueChanging(app, event)
            % Quarantine rate:
            app.q_Label.Text = num2str(round(event.Value,2));
            drawnow()
        end

        % Value changed function: RUNButton
        function RUNButtonValueChanged(app, event)
            if (app.RUNButton.Value == 0)
                app.RUNButton.Text = 'RESET';
                app.RUNButton.FontColor = [0.95,0.76,0.76];
                app.RUNButton.BackgroundColor = [0.74,0.04,0.04];
                drawnow()
            else
                app.RUNButton.Text = 'START';
                app.RUNButton.FontColor = [0.39,0.83,0.07];
                app.RUNButton.BackgroundColor = [0.17,0.17,0.38];
                drawnow()
            end

            % Initialize paramaters:
            N = 160;         % Grid size (NxN) -> N² = Population of a small NJ suburb
            beta_0 = 0.4;    % Transmission rate at the earliest stage when no measures are imposed

            % Preallocate the 2D grid:
            app.UIAxes.XLim = [1 N];
            app.UIAxes.YLim = [1 N];
            x = zeros(N, N);

            % Set the initial grid x with a single infected individual in the center
            % of the grid (town)
            for i = 1:N
                for j = 1:N
                    dx = i-N/2;
                    dy = j-N/2;
                    R = sqrt(dx*dx + dy*dy);
                    if (R < 1)
                        x(i, j) = 1;
                    end
                end
            end

            % Define the Moore neighborhood, i.e. the 8 nearest neighbors
            neighbor = [-1 -1; 0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1; -1 0];

            % main loop, iterating the time variable, t
            for t = 1:5000
                rng('shuffle'); % random generator based on the current time
                if (app.RUNButton.Value == 1)
                    cla(app.UIAxes);
                    title(app.UIAxes,'\color[rgb]{0.17,0.17,0.38}Time iteration = 0');
                    drawnow()
                    break;
                end
                % iterate over all cells in grid x, for index i=1..N and j=1..N
                for i = 1:N
                    for j = 1:N
                        
                        % Iterate over the neighbors and spread the disease
                        for k = 1:length(neighbor)
                            i2 = i + neighbor(k, 1);
                            j2 = j + neighbor(k, 2);
                            
                            % Check that the cell is within the grid boundaries
                            if (i2 >= 1 && j2 >= 1 && i2 <= N && j2 <= N)
                                % if cell is in state Susceptible and neighboring cell
                                % Infected => Spread infection with probability beta
                                if (x(i, j) == 0 && x(i2, j2) == 1)
                                    if (rand < ((1 - app.alpha_control.Value) * beta_0))
                                        x(i, j) = 1;
                                    end
                                end
                            end
                        end
                        
                        % If infected => quarantine from disease with probability q
                        if (x(i, j) == 1 && rand < (app.q_control.Value))
                            x(i, j) = 2;
                        end
            
                        % If quarantine => recover from disease with probability gamma
                        if (x(i, j) == 2 && rand < (app.gamma_control.Value))
                            x(i, j) = 3;
                        end
                        
                    end
                end
            
                % Animate
                cla(app.UIAxes)
                imagesc(app.UIAxes, x, [0 3]);
                colorbar(app.UIAxes,'Ticks',[0.38, 1.13, 1.88, 2.63],'TickLabels',...
                    {'\bf\fontsize{15}\color[rgb]{0.17,0.17,0.38}S\rm\fontsize{10}usceptible',...
                    '\bf\fontsize{15}\color[rgb]{0.17,0.17,0.38}I\rm\fontsize{10}nfected',...
                    '\bf\fontsize{15}\color[rgb]{0.17,0.17,0.38}Q\rm\fontsize{10}uarantined',...
                    '\bf\fontsize{15}\color[rgb]{0.17,0.17,0.38}R\rm\fontsize{10}emoved'},'Direction','reverse')
                title(app.UIAxes, strcat('\color[rgb]{0.17,0.17,0.38}Time iteration = ', int2str(t)))
                drawnow()
                
                % If no more quarantined => Stop the simulation
                if (sum(x == 1) == 0)
                    if (sum(x == 2) == 0)
                        title(app.UIAxes, strcat('\color[rgb]{0.17,0.17,0.38}Total time iterations before recovery = ', int2str(t)))
                        drawnow()
                        break;
                    end
                end
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create COVID19SIQR2DCellularAutomatonUIFigure and hide until all components are created
            app.COVID19SIQR2DCellularAutomatonUIFigure = uifigure('Visible', 'off');
            app.COVID19SIQR2DCellularAutomatonUIFigure.Color = [1 1 1];
            app.COVID19SIQR2DCellularAutomatonUIFigure.Position = [700 400 800 560];
            app.COVID19SIQR2DCellularAutomatonUIFigure.Name = ' COVID-19: SIQR 2D Cellular Automaton';
            app.COVID19SIQR2DCellularAutomatonUIFigure.Icon = fullfile(pathToMLAPP, 'SARS-CoV-2.png');

            % Create UIAxes
            app.UIAxes = uiaxes(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.UIAxes.Toolbar.Visible = 'off';
            app.UIAxes.XLim = [1 160];
            app.UIAxes.YLim = [1 160];
            app.UIAxes.XColor = [0.1686 0.1686 0.3804];
            app.UIAxes.YColor = [0.1686 0.1686 0.3804];
            app.UIAxes.ZColor = [0.1686 0.1686 0.3804];
            app.UIAxes.GridColor = [0.1686 0.1686 0.3804];
            app.UIAxes.MinorGridColor = [0.1686 0.1686 0.3804];
            app.UIAxes.Position = [244 88 500 426];

            % Create alpha_control
            app.alpha_control = uiknob(app.COVID19SIQR2DCellularAutomatonUIFigure, 'continuous');
            app.alpha_control.Limits = [0 1];
            app.alpha_control.ValueChangingFcn = createCallbackFcn(app, @alpha_controlValueChanging, true);
            app.alpha_control.FontColor = [0.1686 0.1686 0.3804];
            app.alpha_control.Position = [81 426 57 57];
            app.alpha_control.Value = 0.7;

            % Create alpha_Label
            app.alpha_Label = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.alpha_Label.HorizontalAlignment = 'center';
            app.alpha_Label.FontWeight = 'bold';
            app.alpha_Label.FontColor = [0.502 0.502 0.502];
            app.alpha_Label.Position = [97 444 25 22];
            app.alpha_Label.Text = 'α';

            % Create gamma_control
            app.gamma_control = uiknob(app.COVID19SIQR2DCellularAutomatonUIFigure, 'continuous');
            app.gamma_control.Limits = [0 1];
            app.gamma_control.ValueChangingFcn = createCallbackFcn(app, @gamma_controlValueChanging, true);
            app.gamma_control.FontColor = [0.1686 0.1686 0.3804];
            app.gamma_control.Position = [82 285 57 57];
            app.gamma_control.Value = 0.06;

            % Create gamma_Label
            app.gamma_Label = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.gamma_Label.HorizontalAlignment = 'center';
            app.gamma_Label.FontWeight = 'bold';
            app.gamma_Label.FontColor = [0.502 0.502 0.502];
            app.gamma_Label.Position = [98 303 25 22];
            app.gamma_Label.Text = 'ɣ';

            % Create q_control
            app.q_control = uiknob(app.COVID19SIQR2DCellularAutomatonUIFigure, 'continuous');
            app.q_control.Limits = [0 1];
            app.q_control.ValueChangingFcn = createCallbackFcn(app, @q_controlValueChanging, true);
            app.q_control.FontColor = [0.1686 0.1686 0.3804];
            app.q_control.Position = [83 144 57 57];
            app.q_control.Value = 0.1;

            % Create q_Label
            app.q_Label = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.q_Label.HorizontalAlignment = 'center';
            app.q_Label.FontWeight = 'bold';
            app.q_Label.FontColor = [0.502 0.502 0.502];
            app.q_Label.Position = [99 162 25 22];
            app.q_Label.Text = 'q';

            % Create LockdownStrengthLabel
            app.LockdownStrengthLabel = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.LockdownStrengthLabel.HorizontalAlignment = 'center';
            app.LockdownStrengthLabel.FontColor = [0.1686 0.1686 0.3804];
            app.LockdownStrengthLabel.Position = [55 385 107 22];
            app.LockdownStrengthLabel.Text = 'Lockdown Strength';

            % Create RecoveryRateLabel
            app.RecoveryRateLabel = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.RecoveryRateLabel.HorizontalAlignment = 'center';
            app.RecoveryRateLabel.FontColor = [0.1686 0.1686 0.3804];
            app.RecoveryRateLabel.Position = [65 244 91 22];
            app.RecoveryRateLabel.Text = 'Recovery Rate';

            % Create QuarantineRateLabel
            app.QuarantineRateLabel = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.QuarantineRateLabel.HorizontalAlignment = 'center';
            app.QuarantineRateLabel.FontColor = [0.1686 0.1686 0.3804];
            app.QuarantineRateLabel.Position = [63 103 94 22];
            app.QuarantineRateLabel.Text = 'Quarantine Rate';

            % Create RUNButton
            app.RUNButton = uibutton(app.COVID19SIQR2DCellularAutomatonUIFigure, 'state');
            app.RUNButton.ValueChangedFcn = createCallbackFcn(app, @RUNButtonValueChanged, true);
            app.RUNButton.Text = 'RUN';
            app.RUNButton.BackgroundColor = [0.1686 0.1686 0.3804];
            app.RUNButton.FontWeight = 'bold';
            app.RUNButton.FontColor = [0.3882 0.8314 0.0706];
            app.RUNButton.Position = [71 31 80 40];
            app.RUNButton.Value = true;

            % Show the figure after all components are created
            app.COVID19SIQR2DCellularAutomatonUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SIQR_Cellular_Automaton

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.COVID19SIQR2DCellularAutomatonUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.COVID19SIQR2DCellularAutomatonUIFigure)
        end
    end
end