% Defining equations of the One-parameter attractor system:
%   dx/dt = -αx + sin⁡y
%   dy/dt = -αy + sin⁡z
%   dz/dt = -αz + sin⁡x

% Setting constant parameter:
alpha = 0.30;

% Intializing the attractor system:
% where, p(1) = x; p(2) = y; p(3) = z
attractor = @(t,p) [-alpha*p(1) + sin(p(2)); -alpha*p(2) + sin(p(3)); -alpha*p(3) + sin(p(1))];

% Creating random initial conditions:
rng('shuffle')
x0 = randsample((10).*rand(1000,1),1);
y0 = randsample((10).*rand(1000,1),1);
z0 = randsample((10).*rand(1000,1),1);

% Integration using ode45:
[t,p] = ode45(attractor, [0 1000], [x0; y0; z0]);

% Removing transients:
p = p(2000:end,:);
t = t(2000:end,:);

% Plotting t vs x(t):
figure(1)
plot(t, p(:,1))
grid
xlabel('t')
ylabel('x(t)')

% Plotting t vs y(t):
figure(2)
plot(t, p(:,2))
grid
xlabel('t')
ylabel('y(t)')

% Plotting x vs z:
figure(3)
plot(p(:,1), p(:,3))
grid
xlabel('x')
ylabel('z')
axis equal