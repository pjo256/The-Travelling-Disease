
clear all; 
clf;
close all;

numCities = 4;
time_simulated = 365; %number of days
clock_max = 365; %divide number of days into day intervals
dt = time_simulated / clock_max;

N_save = zeros(numCities, clock_max);
S_save = zeros(numCities, clock_max);
I_save = zeros(numCities, clock_max);
R_save = zeros(numCities, clock_max);
I_peaks = zeros(1, clock_max);

N = [1000 500 400 1200];
S = [999 498 399 1199];
I = [1 2 1 1];
R = [0 0 0 0];

totalPopulation = sum(N);

a = [0.15 0.12 0.09 0.11]; % infectivity a = # of new cases per day caused by one infected person.
b = [0.01 0.01 0.01 0.01]; %time taken to recover per person is 1/b.


TravelSR = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0];
TravelI = [0 0.05 0.1 0.12; 0.01 0 0.03 0.09; 0.11 0.04 0 0.09; 0.11 0.10 0.07 0];


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
    % Allow each system to evolve before considering changes in population
    % due to traffic.
    if (t >= (time_simulated / 8))
        startedTravel = true;
    end
        
    if startedTravel                                                                             
        for c = 1:numCities
            %Consider each susceptible, infected, and recovered individual
            %Probabilistically move from S to I or from I to R
            
            newlyInfected = 0;
           
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
            for j = i+1:numCities
                 % Count traffic entering and leaving ordered tuple (i, j)
                if(i ~= j)
                    
                    biasedSR_j = 0;
                    biasedI_j = 0;
                    biasedSR_i = 0;
                    biasedI_i = 0;
                    if (S(i) + R(i)) < I(i)
                        %Bias rates
                        biasedSR_j = (I(i) / N(i));
                        biasedI_j = (I(i) / N(i));

                        biasedSR_i = 1 - biasedSR_j;
                        biasedI_i = 1 - biasedI_j;
                        
                    else
                        %Resume static rates
                        biasedSR_j = TravelSR(i, j);
                        biastedI_j = TravelI(i, j);

                        biasedSR_i = TravelSR(j, i);
                        biasedI_i = TravelI(j, i);

                    end
                    
                     % i -> j                     
                     for s = 1:S(i)
                        if rand < biasedSR_j && (S(i) ~= 0) && (sum(N) >= R(j) + I(j) + S(j)))
                            %Only move from i to j if bounds allow one person to be removed from i and one person 
                            %to be addded to j
                            S(i) = S(i) - 1;
                            S(j) = S(j) + 1;
                        end
                     end                     
                     
                     for inf = 1:I(i)
                        if rand < biasedI_j && (I(i) ~= 0) && (sum(N) >= R(j) + I(j) + S(j)))
                            I(i) = I(i) - 1;
                            I(j) = I(j) + 1;
                        end
                     end                   
                     
                     for r = 1:R(i)
                         if rand < biasedSR_j && (R(i) ~= 0) && (sum(N) >= R(j) + I(j) + S(j)))
                             R(i) = R(i) - 1;
                             R(j) = R(j) + 1;
                         end
                     end
                     
                     % j -> i
                     
                     for s = 1:S(j)
                        if rand < biasedSR_i && (S(j) ~= 0) && (sum(N) >= R(i) + I(i) + S(i))
                            S(j) = S(j) - 1;
                            S(i) = S(i) + 1;
                        end
                     end                     
                     
                     for inf = 1:I(j)
                        if rand < biasedI_i && (I(j) ~= 0) && (sum(N) >= R(i) + I(i) + S(i))
                            I(j) = I(j) - 1;
                            I(i) = I(i) + 1;
                        end
                     end
                     
                     for r = 1:R(j)
                         if rand < biasedSR_i && (R(j) ~= 0) && (sum(N) >= R(i) + I(i) + S(i))
                            R(j) = R(j) - 1;
                            R(i) = R(i) + 1;
                         end
                     end
                     
                end
            end
    end
    
    for i = 1:numCities
         N_save(i, clock) = S(i)+I(i)+R(i);
         S_save(i, clock) = S(i);
         I_save(i, clock) = I(i);
         R_save(i, clock) = R(i);
         I_peaks(1, clock) = I_save(i,  clock) + I_peaks(1, clock);
    end
    
    %Draw pie charts
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
