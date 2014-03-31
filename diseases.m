% Observations:
% There is always one city whose number of infections goes down
% It's the city with the travel rates the smallest

% There are cities where the Recovery rates are going down as even
% Recovered people are moving between the cities. 

% Learning:
% && - AND

% CHARTS:
% PIE CHART FOR EACH CITY TO SHOW S, I, R
% 4 CIRCLES AND MOVE IN AND OUT OF EACH CIRCLE

clear all; 
clf;
close all;

numCities = 4;
time_simulated = 365; %number of days
clock_max = 365; %divide number of days into quarter-day intervals
dt = time_simulated / clock_max;

N_save = zeros(numCities, clock_max);
S_save = zeros(numCities, clock_max);
I_save = zeros(numCities, clock_max);
R_save = zeros(numCities, clock_max);

prop_s = 0.0;
prop_i = 0.0;
prop_r = 0.0;

N = [1000 500 400 1200];
S = [999 498 399 1199];
I = [1 2 1 1];
R = [0 0 0 0];

totalPopulation = sum(N);

a = [0.15 0.12 0.09 0.11]; % infectivity a = # of new cases per day caused by one infected person.
b = [0.01 0.01 0.01 0.01]; %time taken to recover per person is 1/b = 20 days, so b = 1/20

% Normal Test Case 1
% Just a normal travel case where we have established SR(all) > I(all)
TravelSR1 = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0]; % TravelSR = [0.49; 0.39; 0.64; 0.33];
TravelI1 = [0 0.05 0.1 0.12; 0.01 0 0.03 0.09; 0.11 0.04 0 0.09; 0.11 0.10 0.07 0]; % TravelI = [0.27; 0.13; 0.24; 0.28];

% Normal Test Case 2
% Case where SR/I are the same
TravelSR2 = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0]; % TravelSR = [0.49; 0.39; 0.64; 0.33];
TravelI2 = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0]; % TravelI = [0.49; 0.39; 0.64; 0.33];

% Normal Test Case 3
% A universie where I(all) > SR(all) because people who are sick are kicked
% out of the city and just travel to different cities seeing refuge but no
% one gives them refuge. 
TravelSR3 = [0 0.05 0.1 0.12; 0.01 0 0.03 0.09; 0.11 0.04 0 0.09; 0.11 0.10 0.07 0]; % TravelSR = [0.27; 0.13; 0.24; 0.28]; 
TravelI3 = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0]; % TravelI = [0.49; 0.39; 0.64; 0.33];

% Normal Test Case 4
% 0 are the highest leaving and lowest coming in
% all travel rates for eveerything are equal (n = 4 same travel rate)
TravelSR4 = [0 0.1 0.1 0.1; 0.1 0 0.1 0.1; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];
TravelI4 = [0 0.1 0.1 0.1; 0.1 0 0.1 0.1; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];

% Normal Test Case 5
% 1 are the highest leaving and lowest coming in
% 3 of them have equal travel rates
% high number coming in, small number leaving
TravelSR5 = [0 0.05 0.05 0.05; 0.1 0 0.1 0.1; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];
TravelI5 = [0 0.05 0.05 0.05; 0.1 0 0.1 0.1; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];

% Normal Test Case 6
% 2 are the highest leaving and lowest coming in
% 2 of them have equal travel rates
TravelSR6 = [0 0.05 0.05 0.05; 0.05 0 0.05 0.05; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];
TravelI6 = [0 0.05 0.05 0.05; 0.05 0 0.05 0.05; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];

% Normal Test Case 7
% 3 are the highest leaving and lowest coming in
% 1 city has the maximial travel rates
TravelSR = [0 0.05 0.05 0.05; 0.05 0 0.05 0.05; 0.05 0.05 0 0.05; 0.1 0.1 0.1 0];
TravelI = [0 0.05 0.05 0.05; 0.05 0 0.05 0.05; 0.05 0.05 0 0.05; 0.1 0.1 0.1 0];

f = figure('Position', [10 10 450 200], 'name', 'Susceptible or Recovered people travelling from x to y');
t = uitable('Parent', f, 'Position', [40 15 450 150]);
set(t, 'Data', TravelSR);
set(t, 'ColumnName', {'SR City One', 'SR City Two', 'SR City Three', 'SR City Four'}, 'RowName', {'SR City One', 'SR City Two', 'SR City Three', 'SR City Four'});

mm = figure('Position', [10 10 450 200], 'name', 'Sick people travelling from x to y');
gg = uitable('Parent', mm, 'Position', [40 15 450 150]);
set(gg, 'Data', TravelI);
set(gg, 'ColumnName', {'City One', 'I City Two', 'I City Three', 'I City Four'}, 'RowName', {'I City One', 'I City Two', 'I City Three', 'I City Four'});

%maybe make fixed fraction?
%probability per unit time?
%we fix the probability for a person to travel to city j from city i per unit time
%traffic is a rate!

% people coming in
% inTravel = [0 40 30 5; 10 0 25 14; 9 49 0 14; 19 32 44 0];
% people who are leaving from i, j are people coming in from i to j
% outTravel = [0 0 0 0; 50 0 50 50; 50 50 0 50; 50 50 50 0];

%doneInitializing = false;
startedTravel = false;
% so travel to i, i does not work
% and travel to j, j does not work
for c = 1:numCities
    for x = 1:numCities
       if c == x
          Travel(c, x) = 0;
       end
    end
end

figure;
set(gcf, 'double', 'on');
subplot(3, 3, 1);
pie_1 = pie([S(1)/totalPopulation I(1)/totalPopulation R(1)/totalPopulation], {'Susceptible', 'Infected', 'Recovered'});
title(strcat('City 1, a = ', num2str(a(1)), ', b = ', num2str(b(1))));
subplot(3, 3, 3);
pie_2 = pie([S(2)/totalPopulation I(2)/totalPopulation R(2)/totalPopulation], {'Susceptible', 'Infected', 'Recovered'});
title(strcat('City 2, a = ', num2str(a(2)), ', b = ', num2str(b(2))));
subplot(3, 3, 7);
pie_3 = pie([S(3)/totalPopulation I(3)/totalPopulation R(3)/totalPopulation], {'Susceptible', 'Infected', 'Recovered'});
title(strcat('City 3, a = ', num2str(a(3)), ', b = ', num2str(b(3))));
subplot(3, 3, 9);
pie_4 = pie([S(4)/totalPopulation I(4)/totalPopulation R(4)/totalPopulation], {'Susceptible', 'Infected', 'Recovered'});
title(strcat('City 4, a = ', num2str(a(4)), ', b = ', num2str(b(4))));
subplot(3, 3, 5);
pie_5 = pie([(S(4)/totalPopulation + S(3)/totalPopulation + S(2)/totalPopulation + S(1)/totalPopulation) (I(4)/totalPopulation + I(3)/totalPopulation + I(2)/totalPopulation + I(1)/totalPopulation) (R(4)/totalPopulation + R(3)/totalPopulation + R(2)/totalPopulation + R(1)/totalPopulation)], {'Susceptible', 'Infected', 'Recovered'});
title('Global');
hold on;

for clock = 1:clock_max
    t = clock * dt;
    % clock
    % Allow each system to evolve before considering changes in population
    % due to traffic.
    if (clock >= (time_simulated / 8))
        startedTravel = true;
    end
        
    if startedTravel                                                                             
        for c = 1:numCities
            newlyInfected = 0;
            % So we don't cross the threshold of having everyone recovered
            % before introducing traffic
            %if I(c) >= N(c)/2
            %    doneInitializing = true;
            %    break;
            %end
            for s = 1:S(c)
                if (rand < (dt * a(c) * I(c) / N(c)))
                    dt * a(c) * I(c) / N(c)  
                    newlyInfected = newlyInfected + 1;
                end
            end
            newlyRecovered = 0;
            for i = 1:I(c)
                if (rand < dt * b(c))
                    dt * b(c)
                    newlyRecovered = newlyRecovered + 1;
                end
            end

            S(c) = S(c) - newlyInfected;
            I(c) = I(c) + newlyInfected - newlyRecovered;
            R(c) = R(c) + newlyRecovered;
        end
    end

    for i = 1:numCities
        %if doneInitializing
            for j = 1:numCities
                % Count traffic entering and leaving city i
                if(i ~= j)
                    %for each pair, loop into all people in city i
                        %loop over all susceptible, give them a chance to
                        %travel
                        %loop over all infected, give them a chance to
                        %travel
                        % . . .
                        %three matrices.
                            %
                            %F_S_ij
                            %F_I_ij
                            %F_R_ij
                            %maybe have F_S_ij = F_R_ij
              
                     % Aggregate population moving i from to j
                     %study travel by itself, populations should settle
                     %down. should be equilibrium populations.
                     
                     %Instead of letting SIR evolve first, let travel
                     %evolve first until approx. settled down populations.
                     
                     %static travel rate array.
                     %at least 3 cities --> 2 kinds of steady states. every
                     %path balanced by its own path. detail balance -->
                     %paths equal.
                     %set up probabilities so only possible to go in cycle.
                     %it'll settle down, there is no reverse path. 
                     
                     %principle of detail balance.
                     
                     %a nice complication 
                     %travel rates depends on level of infection at each
                     %time step
                     %get it working for static rates
                     %make it proportional to I(c)/N(c)
                     
                     
                     % i -> j                     
                     for s = 1:S(i)
                        if rand < TravelSR(i, j) && (S(i) ~= 0)
                            S(i) = S(i) - 1;
                            S(j) = S(j) + 1;
                        end
                     end                     
                     
                     for inf = 1:I(i)
                        if rand < TravelI(i, j) && (I(i) ~= 0)
                            I(i) = I(i) - 1;
                            I(j) = I(j) + 1;
                        end
                     end                   
                     
                     for r = 1:R(i)
                         if rand < TravelSR(i, j) && (R(i) ~= 0)
                             R(i) = R(i) - 1;
                             R(j) = R(j) + 1;
                         end
                     end
                     
                     % j -> i
                     
                     for s = 1:S(j)
                        if rand < TravelSR(j, i) && (S(j) ~= 0)
                            S(j) = S(j) - 1;
                            S(i) = S(i) + 1;
                        end
                     end                     
                     
                     for inf = 1:I(j)
                        if rand < TravelI(j, i) && (I(j) ~= 0)
                            I(j) = I(j) - 1;
                            I(i) = I(i) + 1;
                        end
                     end
                     
                     for r = 1:R(j)
                         if rand < TravelSR(j, i) && (R(j) ~= 0)
                            R(j) = R(j) - 1;
                            R(i) = R(i) + 1;
                         end
                     end
                     
%                      if(S(i) + R(i) + I(i) >= Travel(i, j))
%                          for k = 1:Travel(i, j)
%                             prop_s = S(i) / N(i);
%                             prop_i = I(i) / N(i);
%                             prop_r = R(i) / N(i);
%                             rand_num = rand;
%                             if(rand_num >= 0 && (rand_num <= prop_s && S(i) ~= 0))
%                                 S(i) = S(i) - 1;
%                                 S(j) = S(j) + 1;
%                             elseif(rand_num > prop_s && (rand_num <= prop_s + prop_i && I(i) ~= 0))
%                                 I(i) = I(i) - 1;
%                                 I(j) = I(j) + 1;
%                             elseif(rand_num > prop_s + prop_i && (rand_num <= 1 && R(i) ~= 0))
%                                 R(i) = R(i) - 1;
%                                 R(j) = R(j) + 1;
%                             end
%                          end
%                      end
% 
%                      % Aggregate population moving from j to i
%                      if(S(j) + R(j) + I(j) >= Travel(j, i))
%                          for k = 1:Travel(j, i)
%                             prop_s = S(j) / N(j);
%                             prop_i = I(j) / N(j);
%                             prop_r = R(j) / N(j);                           
%                             rand_num = rand;
%                             if(rand_num >= 0 && (rand_num <= prop_s && S(j) ~= 0))
%                                 S(i) = S(i) + 1;
%                                 S(j) = S(j) - 1;
%                             elseif(rand_num > prop_s && (rand_num <= prop_s + prop_i && I(j) ~= 0))
%                                 I(i) = I(i) + 1;
%                                 I(j) = I(j) - 1;
%                             elseif(rand_num > prop_s + prop_i && (rand_num <= 1 && R(j) ~= 0))
%                                 R(i) = R(i) + 1;
%                                 R(j) = R(j) - 1;
%                             end
%                          end
%                      end
                end
            end
        %end
        N_save(i, clock) = [S(i)+I(i)+R(i)];
        S_save(i, clock) = S(i);
        I_save(i, clock) = I(i);
        R_save(i, clock) = R(i);
    end
    
    clf('reset')
%     
%     if S(1)/totalPopulation < 0 || S(2)/totalPopulation < 0 || S(3)/totalPopulation < 0 || S(4)/totalPopulation
%         S(1)
%         S(2)
%         S(3)
%         S(4)
%         totalPopulation
%         S(2)/totalPopulation
%         S(1)/totalPopulation
%         S(3)/totalPopulation
%         S(4)/totalPopulation
%         break;
%     end

    subplot(3, 3, 1);
    pie_1 = pie([S(1)/totalPopulation I(1)/totalPopulation R(1)/totalPopulation], {'Susceptible', 'Infected', 'Recovered'});
    title(strcat('City 1, a = ', num2str(a(1)), ', b = ', num2str(b(1))));
    subplot(3, 3, 3);
    pie_2 = pie([S(2)/totalPopulation I(2)/totalPopulation R(2)/totalPopulation], {'Susceptible', 'Infected', 'Recovered'});
    title(strcat('City 2, a = ', num2str(a(2)), ', b = ', num2str(b(2))));
    subplot(3, 3, 7);
    pie_3 = pie([S(3)/totalPopulation I(3)/totalPopulation R(3)/totalPopulation], {'Susceptible', 'Infected', 'Recovered'});
    title(strcat('City 3, a = ', num2str(a(3)), ', b = ', num2str(b(3))));
    subplot(3, 3, 9);
    pie_4 = pie([S(4)/totalPopulation I(4)/totalPopulation R(4)/totalPopulation], {'Susceptible', 'Infected', 'Recovered'});
    title(strcat('City 4, a = ', num2str(a(4)), ', b = ', num2str(b(4))));
    subplot(3, 3, 5);
    pie_5 = pie([(S(4)/totalPopulation + S(3)/totalPopulation + S(2)/totalPopulation + S(1)/totalPopulation) (I(4)/totalPopulation + I(3)/totalPopulation + I(2)/totalPopulation + I(1)/totalPopulation) (R(4)/totalPopulation + R(3)/totalPopulation + R(2)/totalPopulation + R(1)/totalPopulation)], {'Susceptible', 'Infected', 'Recovered'});
    title('Global');
    drawnow;
    hold off;
    
end

%Output static data
figure;
subplot(4, 4, 1);
plot(S_save(1,1:clock))
title('Susceptible 1');
subplot(4, 4, 2);
plot(S_save(2,1:clock))
title('Susceptible 2');
subplot(4, 4, 3);
plot(S_save(3,1:clock))
title('Susceptible 3');
subplot(4, 4, 4);
plot(S_save(4,1:clock))
title('Susceptible 4');
subplot(4, 4, 5);
plot(I_save(1,1:clock))
title('Infected 1');
subplot(4, 4, 6);
plot(I_save(2,1:clock))
title('Infected 2');
subplot(4, 4, 7);
plot(I_save(3,1:clock))
title('Infected 3');
subplot(4, 4, 8);
plot(I_save(4,1:clock))
title('Infected 4');
subplot(4, 4, 9);
plot(R_save(1,1:clock))
title('Recovered 1');
subplot(4, 4, 10);
plot(R_save(2,1:clock))
title('Recovered 2');
subplot(4, 4, 11);
plot(R_save(3,1:clock))
title('Recovered 3');
subplot(4, 4, 12);
plot(R_save(4,1:clock))
title('Recovered 4');
subplot(4, 4, 13);
plot(N_save(1,1:clock))
title('City Pop 1');
subplot(4, 4, 14);
plot(N_save(2,1:clock))
title('City Pop 2');
subplot(4, 4, 15);
plot(N_save(3,1:clock))
title('City Pop 3');
subplot(4, 4, 16);
plot(N_save(4,1:clock))
title('City Pop 4');
