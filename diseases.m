clear all; clf;

numCities = 4;
time_simulated = 365; %number of days
clock_max = 365 * 4; %divide number of days into quarter-day intervals
dt = time_simulated / clock_max;


S_save = zeros(numCities, clock_max);
I_save = zeros(numCities, clock_max);
R_save = zeros(numCities, clock_max);

prop_s = 0.0;
prop_i = 0.0;
prop_r = 0.0;

N = [1000 0 0 0];
S = [999 0 0 0];
I = [1 0 0 0];
R = [0 0 0 0];

a = [20 0 0 0]; %infectivity a = # of new cases per day caused by one infected person.
b = [0.05 0 0 0]; %time taken to recover per person is 1/b = 20 days, so b = 1/20

inTravel = [0 0 0 0];
outTravel = [0 0 0 0];

for clock = 1:clock_max
    t = clock * dt;
    clock
    %Allow each system to evolve before considering changes in population
    %due to traffic.
    for c = 1:numCities
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
        
        S_save(c, clock) = S(c);
        I_save(c, clock) = I(c);
        R_save(c, clock) = R(c);
    end
    
%     
%     for i = 1:numCities
%         for j = 1:numCities
%             %Count traffic entering and leaving city i
%             if (i ~= j)
%              
%                  %Aggregate population moving to i from j
%                  for k = 1:inTravel(j, i)
%                     prop_s = S(j) / N(j);
%                     prop_i = I(j) / N(j);
%                     prop_r = R(j) / N(j);
%                                     
%                     rand_num = rand;
%                     if (rand_num >= 0 && rand_num <= prop_s)
%                         %S(j) = S(j) - 1;
%                         S(i) = S(i) + 1;
%                     elseif (rand_num > prop_s && rand_num <= prop_s + prop_i)
%                         %I(j) = I(j) - 1;
%                         I(i) = I(i) + 1;
%                     elseif (rand_num > prop_s + prop_i && rand_num <= 1)
%                         %R(j) = R(j) - 1;
%                         R(i) = R(i) + 1;
%                     end
%                  end
%                  
%                  %Aggregate population moving from i to j
%                  for k = 1:outTravel(i, j)
%                     prop_s = S(i) / N(i);
%                     prop_i = I(i) / N(i);
%                     prop_r = R(i) / N(i);
%                                     
%                     rand_num = rand;
%                     if (rand_num >= 0 && rand_num <= prop_s)
%                        
%                         S(i) = S(i) - 1;
%                     elseif (rand_num > prop_s && rand_num <= prop_s + prop_i)
%                         %I(j) = I(j) + 1;
%                         I(i) = I(i) - 1;
%                     elseif (rand_num > prop_s + prop_i && rand_num <= 1)
%                         %R(j) = R(j) + 1;
%                         R(i) = R(i) - 1;
%                     end
%                  end
%             end
%         end
%     end
end

