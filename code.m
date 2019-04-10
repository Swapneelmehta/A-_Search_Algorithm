clearvars
clc

% Call the input files for edges and nodes here
edges=csvread('edges.csv',6,0,[6,0,23,2]);
nodes=csvread('nodes.csv',8,0,[8,0,19,3]);

% Initializing the costs and open and closed lists
past_cost = zeros(size(nodes,1),1); 
past_cost(2:end) = inf;
cost_to_go = nodes(:,end);
est_cost = past_cost + cost_to_go;
parent_node = zeros(size(nodes,1),1);
open_sorted = [1,est_cost(1)];
closed_sorted = [];

%Initialization of path which will be our output 
path = []; 
goal_node = nodes(end,1); 
current = []; 
T_f=isempty(open_sorted);

% Condition setting to end the loop when we reach to the initial node
while T_f==~1 
    current = open_sorted(1,1);
    open_sorted(open_sorted(:,1) == current,:) = [];
    closed_sorted = [closed_sorted; current];
    if current == goal_node  
       path_node = goal_node;
       while path_node ~= 1
             path = [path, path_node];
             path_node = parent_node(path_node);
       end
       path = rot90(rot90(([path, 1])));
       break
    end
    
    % Add the edges which gets selected in the path
    connected = edges(edges(:,2) == current,1);
    cost_connected = edges(edges(:,2) == current,end);
    
    % Going back with all the paths to check the minimum cost path
    for i = 1:length(connected)
        if isempty(find(closed_sorted == connected(i), 1))
           tentative_past_cost = past_cost(current) + cost_connected(i);
           if tentative_past_cost < past_cost(connected(i))
              past_cost(connected(i)) = tentative_past_cost;
              parent_node(connected(i)) = current;
              est_cost(connected(i)) = past_cost(connected(i)) + cost_to_go(connected(i));
              open_sorted = [open_sorted;connected(i), est_cost(connected(i))];
              open_sorted = sortrows(open_sorted, 2);
           end
        end
    end
end

csvwrite('path.csv',path);  % This creates our output file
fprintf('The optimal path found is \n')
disp(path)