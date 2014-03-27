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


% TravelSR = [0.49; 0.39; 0.64; 0.33];
TravelSR = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0];
% TravelI = [0.27; 0.13; 0.24; 0.28];
TravelI = [0 0.05 0.1 0.12; 0.01 0 0.03 0.09; 0.11 0.04 0 0.09; 0.11 0.10 0.07 0];
%maybe make fixed fraction?
%probability per unit time?
%we fix the probability for a person to travel to city j from city i per unit time
%traffic is a rate!


startedTravel = false;

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
            if I(c) >= N(c)/2
                doneInitializing = true;
                break;
            end
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
            for j = 1:numCities
                % Count traffic entering and leaving city i
                if(i ~= j)
                    
                    if S(i) < I(i)
                        %Bias rates
                        global_prop_S = sum(S) / totalPopulation;
                        global_prop_I = sum(I) / totalPopulation;
                        TravelSR(i, j) = global_prop_S * (S(i) / N(i));
                        TravelI(i, j) = global_prop_I * (I(i) / N(i));
                        
                        % think
                        %TravelSR(j, i) = (sum(R)+sum(S)) - N(j)*TravelSR(i, j);
                        %TravelI(j, i) = sum(I) - N(j)*TravelI(i, j);
                    end
                    
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
                end
            end
            
        N_save(i, clock) = [S(i)+I(i)+R(i)];
        S_save(i, clock) = S(i);
        I_save(i, clock) = I(i);
        R_save(i, clock) = R(i);
    end
    
    clf('reset')

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