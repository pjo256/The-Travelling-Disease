clear all; 
clf;
close all;

numCities = 4;
time_simulated = 365 * 2; %number of days
clock_max = 365 * 2; %divide number of days into day intervals
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

%Testing epidemicity e = 1,2, 3
a2 = [0.05 0.02 0.3 0.28]; % infectivity a = # of new cases per day caused by one infected person. %time taken to recover per person is 1/b
a1 = [0.05 0.02 0.04 0.28];
a3 = [0.05 0.15 0.3 0.28];
%b = [0.07 0.03 0.06 0.04];




% Default rates
% Just a normal travel case where we have established SR(all) > I(all)
TravelSR = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0]; 
TravelI = [0 0.05 0.1 0.12; 0.01 0 0.03 0.09; 0.11 0.04 0 0.09; 0.11 0.10 0.07 0];
a = [0.15 0.12 0.09 0.11];
b = [0.01 0.01 0.01 0.01];


%F_SR > F_I, F_SR = F_I, F_SR < F_I
% Normal Test Case 2
% Case where SR/I are the same
TravelSR2 = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0]; 
TravelI2 = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0]; 

% Normal Test Case 3
% A scenario where I(all) > SR(all) because people who are sick are kicked
% out of the city and just travel to different cities seeing refuge but no
% one gives them refuge. 
TravelSR3 = [0 0.05 0.1 0.12; 0.01 0 0.03 0.09; 0.11 0.04 0 0.09; 0.11 0.10 0.07 0];
TravelI3 = [0 0.1 0.3 0.09; 0.19 0 0.10 0.10; 0.29 0.15 0 0.20; 0.1 0.2 0.03 0]; 

% Normal Test Case 4
% 0 are the highest leaving and lowest coming in
% all travel rates for eveerything are equal (n = 4 same travel rate)
TravelSR4 = [0 0.1 0.1 0.1; 0.1 0 0.1 0.1; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];
TravelI4 = [0 0.1 0.1 0.1; 0.1 0 0.1 0.1; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];

% n = 1
% 1 are the highest leaving and lowest coming in
% 3 of them have equal travel rates
% high number coming in, small number leaving
TravelSR5 = [0 0.05 0.05 0.05; 0.1 0 0.1 0.1; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];
TravelI5 = [0 0.05 0.05 0.05; 0.1 0 0.1 0.1; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];

% n = 2
% 2 are the highest leaving and lowest coming in
% 2 of them have equal travel rates
TravelSR6 = [0 0.05 0.05 0.05; 0.05 0 0.05 0.05; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];
TravelI6 = [0 0.05 0.05 0.05; 0.05 0 0.05 0.05; 0.1 0.1 0 0.1; 0.1 0.1 0.1 0];

% n = 3
% 3 are the highest leaving and lowest coming in
% 1 city has the maximial travel rates
TravelSR7 = [0 0.05 0.05 0.05; 0.05 0 0.05 0.05; 0.05 0.05 0 0.05; 0.1 0.1 0.1 0];
TravelI7 = [0 0.05 0.05 0.05; 0.05 0 0.05 0.05; 0.05 0.05 0 0.05; 0.1 0.1 0.1 0];

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
drawnow;
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
                    newlyInfected = newlyInfected + 1;
                end
            end
            newlyRecovered = 0;
            for i = 1:I(c)
                if (rand < dt * b(c))
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
                % Count traffic entering and leaving city ordered tuple (i, j)
                if(i ~= j)
                     % i -> j      
                     initS = S(i);
                     for s = 1:S(i)
                        if rand < (TravelSR(i, j) * dt) && (S(i) ~= 0 && (sum(N) >= R(j) + I(j) + S(j)))
                            %Only move from i to j if bounds allow one person to be removed from i and one person 
                            %to be addded to j
                            S(i) = S(i) - 1;
                            S(j) = S(j) + 1;
                        end
                     end                     
                     
                     for inf = 1:I(i)
                        if rand < (TravelI(i, j) * dt) && (I(i) ~= 0 && (sum(N) >= R(j) + I(j) + S(j)))
                            I(i) = I(i) - 1;
                            I(j) = I(j) + 1;
                        end
                     end                   
                     
                     for r = 1:R(i)
                         if rand < (TravelSR(i, j) * dt) && (R(i) ~= 0 && (sum(N) >= R(j) + I(j) + S(j)))
                             R(i) = R(i) - 1;
                             R(j) = R(j) + 1;
                         end
                     end
                     
                     % j -> i
                     
                     for s = 1:S(j)
                        if rand < (TravelSR(j, i) * dt) && (S(j) ~= 0 && (sum(N) >= R(i) + I(i) + S(i)))
                            S(j) = S(j) - 1;
                            S(i) = S(i) + 1;
                        end
                     end                     
                     
                     newS = S(i);
                     for inf = 1:I(j)
                        if rand < (TravelI(j, i) * dt) && (I(j) ~= 0 && (sum(N) >= R(i) + I(i) + S(i)))
                            I(j) = I(j) - 1;
                            I(i) = I(i) + 1;
                        end
                     end
                     
                     for r = 1:R(j)
                         if rand < (TravelSR(j, i) * dt) && (R(j) ~= 0 && (sum(N) >= R(i) + I(i) + S(i)))
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
    
    %Draw pie chart
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
U = 1.2 * time_simulated;
set(gcf, 'double', 'on');
% --- Susceptible --- %
L = 1.1 * max(S_save(:));
subplot(4, 4, 1);
plot(S_save(1,1:clock))
title('Susceptible 1');
axis([0 U 0 L]);
subplot(4, 4, 2);
plot(S_save(2,1:clock))
title('Susceptible 2');
axis([0 U 0 L]);
subplot(4, 4, 3);
plot(S_save(3,1:clock))
title('Susceptible 3');
axis([0 U 0 L]);
subplot(4, 4, 4);
plot(S_save(4,1:clock))
title('Susceptible 4');
axis([0 U 0 L]);

% --- Infected --- %
L = 1.1 * max(I_save(:));
subplot(4, 4, 5);
plot(I_save(1,1:clock))
title('Infected 1');
axis([0 U 0 L]);
subplot(4, 4, 6);
plot(I_save(2,1:clock))
title('Infected 2');
axis([0 U 0 L]);
subplot(4, 4, 7);
plot(I_save(3,1:clock))
title('Infected 3');
axis([0 U 0 L]);
subplot(4, 4, 8);
plot(I_save(4,1:clock))
title('Infected 4');
axis([0 U 0 L]);

% --- Recovered --- %
L = 1.1 * max(R_save(:));
subplot(4, 4, 9);
plot(R_save(1,1:clock))
title('Recovered 1');
axis([0 U 0 L]);
subplot(4, 4, 10);
plot(R_save(2,1:clock))
title('Recovered 2');
axis([0 U 0 L]);
subplot(4, 4, 11);
plot(R_save(3,1:clock))
title('Recovered 3');
axis([0 U 0 L]);
subplot(4, 4, 12);
plot(R_save(4,1:clock))
title('Recovered 4');
axis([0 U 0 L]);


% --- General population --- %
L = 1.1 * max(N_save(:));
subplot(4, 4, 13);
plot(N_save(1,1:clock))
title('City Pop 1');
axis([0 U 0 L]);
subplot(4, 4, 14);
plot(N_save(2,1:clock))
title('City Pop 2');
axis([0 U 0 L]);
subplot(4, 4, 15);
plot(N_save(3,1:clock))
title('City Pop 3');
axis([0 U 0 L]);
subplot(4, 4, 16);
plot(N_save(4,1:clock))
title('City Pop 4');
axis([0 U 0 L]);

