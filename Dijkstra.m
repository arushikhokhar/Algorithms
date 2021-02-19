input_map=false(20);
input_map(1:5,9)=true;
input_map(6:9,3)=true;
input_map(7:12,7)=true;
start_coords=[1,2];
dest_coords=[19,20];
n=true;
cmap = [1 1 1; ...
        0 0 0; ...
        1 0 0; ...
        0 0 1; ...
        0 1 0; ...
        1 1 0; ...
	0.5 0.5 0.5];

colormap(cmap);

% variable to control if the map is being visualized on every
% iteration
drawMapEveryTime = true;

[nrows, ncols] = size(input_map);

% map - a table that keeps track of the state of each grid cell
map = zeros(nrows,ncols);

map(~input_map) = 1;   % Mark free cells
map(input_map)  = 2;   % Mark obstacle cells

% Generate linear indices of start and dest nodes
start_node = sub2ind(size(map), start_coords(1), start_coords(2));
dest_node  = sub2ind(size(map), dest_coords(1),  dest_coords(2));

map(start_node) = 5;
map(dest_node)  = 6;

% Initialize distance array
distanceFromStart = Inf(nrows,ncols);

% For each grid cell this array holds the index of its parent
parent = zeros(nrows,ncols);

distanceFromStart(start_node) = 0;

% keep track of number of nodes expanded 
numExpanded = 0;

% Main Loop
while true
    
    % Draw current map
    map(start_node) = 5;
    map(dest_node) = 6;
    
    % make drawMapEveryTime = true if you want to see how the 
    % nodes are expanded on the grid. 
    if (drawMapEveryTime)
        image(1.5, 1.5, map);
        grid on;
        axis image;
        drawnow;
    end
    
    % Find the node with the minimum distance
    [min_dist, current] = min(distanceFromStart(:));
    
    if ((current == dest_node) || isinf(min_dist))
        break;
    end;
    
    % Update map
    map(current) = 3;         % mark current node as visited
    distanceFromStart(current) = Inf; % remove this node from further consideration
    
    % Compute row, column coordinates of current node
    [i, j] = ind2sub(size(distanceFromStart), current);
    
   % ********************************************************************* 
    % YOUR CODE BETWEEN THESE LINES OF STARS
    
    % Visit each neighbor of the current node and update the map, distances
    % and parent tables appropriately.
    neighbors = [i-1 j;i+1 j;i j-1;i j+1];
    if(i == 1 && j == 1)
        neighbors(1,:) = ''; neighbors(2,:) = '';
    elseif(i == 1 && j < ncols)
        neighbors(1,:) = '';
    elseif(j == 1 && i < nrows)
        neighbors(3,:) = '';
    elseif(i == nrows && j == 1)
        neighbors(2:3,:) = '';
    elseif(i == nrows && j < ncols)
        neighbors(2,:) = '';
    elseif(i == 1 && j == ncols)
        neighbors(1,:) = ''; neighbors(3,:) = '';
    elseif(i < nrows && j == ncols)
        neighbors(4,:) = '';
    elseif(i == nrows && j == ncols)
        neighbors(2,:) = ''; neighbors(3,:) = '';
    end
    neigh = sub2ind(size(map), neighbors(:,1), neighbors(:,2));
    for i=1:length(neigh)
        if(map(neigh(i))==1 || map(neigh(i))==4 || map(neigh(i))==6 && map(neigh(1))~=2)
            if(distanceFromStart(neigh(i)) > min_dist + 1)
                distanceFromStart(neigh(i)) = min_dist + 1;
                map(neigh(i)) = 4;
                if(neigh(i)~=start_node)
                    parent(neigh(i)) = current;
                end
            end
        end
    end
    if(map(current)==3)
        numExpanded = numExpanded + 1;
    end
    %*********************************************************************
end

%% Construct route from start to dest by following the parent links
if (isinf(distanceFromStart(dest_node)))
    route = [];
else
    route = [dest_node];
    numExpanded
    while (parent(route(1)) ~= 0)
        route = [parent(route(1)), route];
    end
        % Snippet of code used to visualize the map and the path
    for k = 2:length(route) - 1        
        map(route(k)) = 7;
        pause(0.1);
        image(1.5, 1.5, map);
        grid on;
        axis image;
    end
end
