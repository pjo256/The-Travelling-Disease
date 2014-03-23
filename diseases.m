% Observations:
% There is always one city whose number of infections goes down
% It's the city with the travel rates the smallest

% There are cities where the Recovery rates are going down as even
% Recovered people are moving between the cities. 

% Learning:
% && - AND

clear all; 
clf;

numCities = 4;
time_simulated = 365; %number of days
clock_max = 365; %divide number of days into quarter-day intervals
dt = time_simulated / clock_max;

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

a = [1 2 0.9 0.8]; % infectivity a = # of new cases per day caused by one infected person.
b = [0.05 0.04 0.06 0.09]; %time taken to recover per person is 1/b = 20 days, so b = 1/20

Travel = [0 40 30 5; 10 0 50 14; 9 49 0 14; 19 32 44 0];

% people coming in
% inTravel = [0 40 30 5; 10 0 25 14; 9 49 0 14; 19 32 44 0];
% people who are leaving from i, j are people coming in from i to j
% outTravel = [0 0 0 0; 50 0 50 50; 50 50 0 50; 50 50 50 0];

doneInitializing = false;

% so travel to i, i does not work
% and travel to j, j does not work
for c = 1:numCities
    for x = 1:numCities
       if c == x
          Travel(c, x) = 0;
       end
    end
end

for clock = 1:clock_max
    t = clock * dt;
    % clock
    % Allow each system to evolve before considering changes in population
    % due to traffic.
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
    
    for i = 1:numCities
        if doneInitializing
            for j = 1:numCities
                % Count traffic entering and leaving city i
                if(i ~= j)
                     % Aggregate population moving i from to j
                     if(S(i) + R(i) + I(i) >= Travel(i, j))
                         for k = 1:Travel(i, j)
                            prop_s = S(i) / N(i);
                            prop_i = I(i) / N(i);
                            prop_r = R(i) / N(i);
                            rand_num = rand;
                            if(rand_num >= 0 && (rand_num <= prop_s && S(i) ~= 0))
                                S(i) = S(i) - 1;
                                S(j) = S(j) + 1;
                            elseif(rand_num > prop_s && (rand_num <= prop_s + prop_i && I(i) ~= 0))
                                I(i) = I(i) - 1;
                                I(j) = I(j) + 1;
                            elseif(rand_num > prop_s + prop_i && (rand_num <= 1 && R(i) ~= 0))
                                R(i) = R(i) - 1;
                                R(j) = R(j) + 1;
                            end
                         end
                     end

                     % Aggregate population moving from j to i
                     if(S(j) + R(j) + I(j) >= Travel(j, i))
                         for k = 1:Travel(j, i)
                            prop_s = S(j) / N(j);
                            prop_i = I(j) / N(j);
                            prop_r = R(j) / N(j);                           
                            rand_num = rand;
                            if(rand_num >= 0 && (rand_num <= prop_s && S(j) ~= 0))
                                S(i) = S(i) + 1;
                                S(j) = S(j) - 1;
                            elseif(rand_num > prop_s && (rand_num <= prop_s + prop_i && I(j) ~= 0))
                                I(i) = I(i) + 1;
                                I(j) = I(j) - 1;
                            elseif(rand_num > prop_s + prop_i && (rand_num <= 1 && R(j) ~= 0))
                                R(i) = R(i) + 1;
                                R(j) = R(j) - 1;
                            end
                         end
                     end
                end
            end
        end
        S_save(i, clock) = S(i);
        I_save(i, clock) = I(i);
        R_save(i, clock) = R(i);
    end
end

