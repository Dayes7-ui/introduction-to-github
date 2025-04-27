%% TWO-SOLVER ERROR COMPARISON: ode23 & ode15s vs. ode45

%--- Solver options ---
opts_ref  = odeset('RelTol',1e-8,'AbsTol',1e-10,'Stats','off');    % tight ref
opts_norm = odeset('RelTol',1e-3,'AbsTol',1e-6,'Stats','off');     % default

%--- 1) reference solve with ode45 (tight tol) ---
[t_ref, y_ref] = ode45(@noble, tspan, y0, opts_ref);
V_ref = y_ref(:,1);

%--- 2) solve with ode23 & ode15s (normal tol) ---
[t23,  y23 ] = ode23 (@noble, tspan, y0, opts_norm);
[t15s,y15s] = ode15s(@noble, tspan, y0, opts_norm);

%--- 3) interpolate onto reference grid ---
V23  = interp1(t23,  y23(:,1),  t_ref, 'linear');
V15s= interp1(t15s,y15s(:,1),t_ref, 'linear');

%--- 4) compute errors ---
abs23   = abs(V23  - V_ref);
rel23   = abs23 ./ (abs(V_ref)+eps);
abs15s  = abs(V15s - V_ref);
rel15s  = abs15s./ (abs(V_ref)+eps);

%--- 5) plot absolute error ---
figure('Name','Abs Error: ode23 & ode15s vs ode45','NumberTitle','off');
plot(t_ref, abs23,  'b-', 'LineWidth',1.5, 'DisplayName','ode23');
hold on;
plot(t_ref, abs15s, 'r-', 'LineWidth',1.5, 'DisplayName','ode15s');
plot(t_ref, zeros(size(t_ref)),'k--','DisplayName','ref = ode45 (tight)');
xlabel('Time (ms)');
ylabel('Absolute error (mV)');
title('Absolute Error: ode23 & ode15s vs. ode45 (tight tol)');
legend('Location','northeast');
grid on; hold off;

%--- 6) plot relative error (semilogy) ---
figure('Name','Rel Error: ode23 & ode15s vs ode45','NumberTitle','off');
semilogy(t_ref, rel23,  'b-', 'LineWidth',1.5, 'DisplayName','ode23');
hold on;
semilogy(t_ref, rel15s, 'r-', 'LineWidth',1.5, 'DisplayName','ode15s');
semilogy(t_ref, eps*ones(size(t_ref)),'k--','DisplayName','ref');
xlabel('Time (ms)');
ylabel('Relative error');
title('Relative Error: ode23 & ode15s vs. ode45 (tight tol)');
legend('Location','northeast');
grid on; hold off;
