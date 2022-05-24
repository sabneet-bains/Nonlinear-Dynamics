% Defining equations of the Rock-Paper-Scissors-Lizard-Spock system:
%   dR/dt = R(-P+S+L-K)
%   dP/dt = P(R-S-L+K)
%   dS/dt = S(-R+P+L-K)
%   dL/dt = L(-R+P-S+K)
%   dK/dt = K(R-P+S-L)

% Intializing the Rock-Paper-Scissors-Lizard-Spock system:
% where, p(1) = R; p(2) = P; p(3) = S; p(4) = L; p(5) = K
% RPSLK = @(t,p)...
%     [p(1)*(-p(2)+p(3)+p(4)-p(5)); ...
%      p(2)*(p(1)-p(3)-p(4)+p(5)); ...
%      p(3)*(-p(1)+p(2)+p(4)-p(5)); ...
%      p(4)*(-p(1)+p(2)-p(3)+p(5)); ...
%      p(5)*(p(1)-p(2)+p(3)-p(4))];

a = 1;

RPSLK = @(t,p)...
    [p(1)*((-p(2)+a*p(3)+a*p(4)-p(5))-(a-1)*(p(1)*p(2)+p(1)*p(3)+p(1)*p(4)+p(1)*p(5)+p(2)*p(3)+p(2)*p(4)+p(2)*p(5)+p(3)*p(4)+p(3)*p(5)+p(4)*p(5))); ...
    p(2)*((a*p(1)-p(3)-p(4)+a*p(5))-(a-1)*(p(1)*p(2)+p(1)*p(3)+p(1)*p(4)+p(1)*p(5)+p(2)*p(3)+p(2)*p(4)+p(2)*p(5)+p(3)*p(4)+p(3)*p(5)+p(4)*p(5))); ...
    p(3)*((-p(1)+a*p(2)+a*p(4)-p(5))-(a-1)*(p(1)*p(2)+p(1)*p(3)+p(1)*p(4)+p(1)*p(5)+p(2)*p(3)+p(2)*p(4)+p(2)*p(5)+p(3)*p(4)+p(3)*p(5)+p(4)*p(5))); ...
    p(4)*((-p(1)+a*p(2)-p(3)+a*p(5))-(a-1)*(p(1)*p(2)+p(1)*p(3)+p(1)*p(4)+p(1)*p(5)+p(2)*p(3)+p(2)*p(4)+p(2)*p(5)+p(3)*p(4)+p(3)*p(5)+p(4)*p(5))); ...
    p(5)*((a*p(1)-p(2)+a*p(3)-p(4))-(a-1)*(p(1)*p(2)+p(1)*p(3)+p(1)*p(4)+p(1)*p(5)+p(2)*p(3)+p(2)*p(4)+p(2)*p(5)+p(3)*p(4)+p(3)*p(5)+p(4)*p(5)))];


% Creating random initial conditions:
% rng('shuffle')
% R0 = randsample((10).*rand(1000,1),1);
% P0 = randsample((10).*rand(1000,1),1);
% S0 = randsample((10).*rand(1000,1),1);
% L0 = randsample((10).*rand(1000,1),1);
% K0 = randsample((10).*rand(1000,1),1);
R0 = 0.000;
P0 = 0.150;
S0 = 0.300;
L0 = 0.550;
K0 = 0.000;

% Integration using ode45:
[t,p] = ode45(RPSLK, [0 200], [R0; P0; S0; L0; K0]);


for i = 1:numel(p)
    if (abs(p(i)) < 1e-03)
        p(i) = 0;
    end
end

% Removing transients (if needed):
% p = p(50:end,:);
% t = t(50:end,:);

% hold on
% Plotting t vs R(t):
figure(1)
plot(t, p(:,1))
grid
xlabel('t')
ylabel('R(t)')
% 
% % Plotting t vs P(t):
figure(2)
plot(t, p(:,2))
grid
xlabel('t')
ylabel('P(t)')

% Plotting t vs S(t):
figure(3)
plot(t, p(:,3))
grid
xlabel('t')
ylabel('S(t)')

% Plotting t vs L(t):
figure(4)
plot(t, p(:,4))
grid
xlabel('t')
ylabel('L(t)')

% Plotting t vs K(t):
figure(5)
plot(t, p(:,5))
grid
xlabel('t')
ylabel('Population density')
% legend('Rock','Paper','Scissors','Lizzard','Spock')

% hold off

% % Plotting R vs S vs K:
figure(6)
plot3(p(:,3), p(:,4), p(:,5))
grid
xlabel('R')
ylabel('S')
zlabel('K')
axis equal