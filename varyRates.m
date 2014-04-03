
clear all; 
clf;
close all;

numCities = 4;
time_simulated = 365 * 3; 
clock_max = 365 * 3; 
dt = time_simulated / clock_max;

N = [1000 500 400 1200];
S = [999 498 399 1199];
I = [1 2 1 1];
R = [0 0 0 0];

totalPopulation = sum(N);

%Testing thresholds
a = [0.07 0.03 0.06 0.04];
b = [0.07 0.03 0.06 0.04];
 
%TravelSR = [0 0.25 0.25 0.25; 0.19 0 0.19 0.19; 0.15 0.15 0 0.15; 0.30 0.30 0.30 0]; 
%TravelI = [0 0.21 0.21 0.21; 0.14 0 0.14 0.14; 0.13 0.13 0 0.13; 0.23 0.23 0.23 0]; 


startedTravel = false;

numTrials = 12;
test = 2; %city whose rates we will vary
maxima = zeros(10, 2);

daysToTestRate = zeros(numTrials, 2);
infectedToTestRate = zeros(numTrials, 2);
for k = 1:numTrials
    startedTravel = false;
    N = [1000 500 400 1200];
    S = [999 498 399 1199];
    I = [1 2 1 1];
    R = [0 0 0 0];
    
    N_save = zeros(numCities, clock_max);
    S_save = zeros(numCities, clock_max);
    I_save = zeros(numCities, clock_max);
    R_save = zeros(numCities, clock_max);
    
    TravelSR = [0 0.17 0.17 0.17; 0.13 0 0.13 0.13; 0.10 0.10 0 0.10; 0.20 0.20 0.20 0]; 
    TravelI = [0 0.11 0.11 0.11; 0.09 0 0.09 0.09; 0.07 0.07 0 0.07; 0.13 0.13 0.13 0]; 
    
    for i = 1:numCities
        if (i ~= j)
            TravelSR(test, i) = TravelSR(test, i) + k * 0.01;
            TravelI(test, i) = TravelI(test, i) + k * 0.01;
        end
    end
    
    for clock = 1:clock_max
        t = clock * dt;
        % Allow each system to evolve before considering changes in population
        % due to traffic.
        if (clock >= (time_simulated / 8))
            startedTravel = true;
        %See initial distribution before travel starts    
        elseif (clock <= 1)
            continue;
        end
        
        if startedTravel                                                                             
            for c = 1:numCities
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
            
%              N_save(c, clock) = S(c)+I(c)+R(c);
%              S_save(c, clock) = S(c);
%              I_save(c, clock) = I(c);
%              R_save(c, clock) = R(c);
            end
        end
   
        for i = 1:numCities
        %if doneInitializing
            for j = 1:numCities
                % Count traffic entering and leaving city i
                if(i ~= j)
                    
                     % i -> j                     
                     for s = 1:S(i)
                        if rand < (TravelSR(i, j) * dt) && (S(i) ~= 0 && (sum(N) >= sum(R(j) + I(j) + S(j))))
                            S(i) = S(i) - 1;
                            S(j) = S(j) + 1;
                        end
                     end                     
                     
                     for inf = 1:I(i)
                        if rand < (TravelI(i, j) * dt) && (I(i) ~= 0 && (sum(N) >= sum(R(j) + I(j) + S(j))))
                            I(i) = I(i) - 1;
                            I(j) = I(j) + 1;
                        end
                     end                   
                     
                     for r = 1:R(i)
                         if rand < (TravelSR(i, j) * dt) && (R(i) ~= 0 && (sum(N) >= sum(R(j) + I(j) + S(j))))
                             R(i) = R(i) - 1;
                             R(j) = R(j) + 1;
                         end
                     end
                     
                     % j -> i
                     
                     for s = 1:S(j)
                        if rand < (TravelSR(j, i) * dt) && (S(j) ~= 0 && (sum(N) >= sum(R(i) + I(i) + S(i))))
                            S(j) = S(j) - 1;
                            S(i) = S(i) + 1;
                        end
                     end                     
                     
                     for inf = 1:I(j)
                        if rand < (TravelI(j, i) * dt) && (I(j) ~= 0 && (sum(N) >= sum(R(i) + I(i) + S(i))))
                            I(j) = I(j) - 1;
                            I(i) = I(i) + 1;
                        end
                     end
                     
                     for r = 1:R(j)
                         if rand < (TravelSR(j, i) * dt) && (R(j) ~= 0 && (sum(N) >= sum(R(i) + I(i) + S(i))))
                            R(j) = R(j) - 1;
                            R(i) = R(i) + 1;
                         end
                     end                  
                end
           end
        
           N_save(i, clock) = S(i)+I(i)+R(i);
           S_save(i, clock) = S(i);
           I_save(i, clock) = I(i);
           R_save(i, clock) = R(i);
        end
    end
    
    [maxI, maxC] = max(I_save(:));
    daysToTestRate(k, 1) = k * 0.01;
    daysToTestRate(k, 2) = maxI;
    infectedToTestRate(k, 1) = k * 0.01;
    infectedToTestRate(k, 2) = maxC;
   
    
end

%plot(daysToTestRate(:, 1), daysToTestRate(:, 2))
%plot(infectedToTestRate(:, 1), infectedToTestRate(:, 2))
    
    

    
  

