function [ShortestPath,TotalCost] = MyDijkstra(NetworkTopology, Source, Destination)
%==============================================================
% shortestPath: the list of nodes in the shortestPath from source to destination;
% totalCost: the total cost of the  shortestPath;
% n: the number of nodes in the network;
% Source: source node index;
% Destination: destination node index;
% NetworkTopology: a network of N nodes represented by the NxN matrix.
% Example of NetworkTopology: NSF TOPOLOGY with 14 nodes
% 0     1     1     0     0     0     0     1     0     0     0     0     0     0
% 1     0     1     1     0     0     0     0     0     0     0     0     0     0
% 1     1     0     0     0     1     0     0     0     0     0     0     0     0
% 0     1     0     0     1     0     0     0     0     0     1     0     0     0
% 0     0     0     1     0     1     1     0     0     0     0     0     0     0
% 0     0     1     0     1     0     0     0     0     1     0     0     1     0
% 0     0     0     0     1     0     0     1     0     0     0     0     0     0
% 1     0     0     0     0     0     1     0     1     0     0     0     0     0
% 0     0     0     0     0     0     0     1     0     1     0     1     0     1
% 0     0     0     0     0     1     0     0     1     0     0     0     0     0
% 0     0     0     1     0     0     0     0     0     0     0     1     0     1
% 0     0     0     0     0     0     0     0     1     0     1     0     1     0
% 0     0     0     0     0     1     0     0     0     0     0     1     0     1
% 0     0     0     0     0     0     0     0     1     0     1     0     1     0
% visited: a set of visited nodes
% distance: a 1xN vector containing the distance from the source node to
% all other nodes in the network
% previous: a 1xN vector containing the parent node of each node in the
% network

%==============================================================
n = size(NetworkTopology,1);
visited(1:n) = 0;
distance(1:n) = inf;
previous(1:n) = n+1;
distance(Source) = 0;
for i = 1:n
    for j = 1:n
        if NetworkTopology(i,j)==0
            NetworkTopology(i,j)=inf; % to make sure the algorithm does not choose paths with cost 0 over paths with cost 1
        end
    end
end
while sum(visited)~=n % as long as all nodes are not visited
    candidate=[];
    for i = 1:n
        if visited(i) ==0
            candidate = [candidate distance(i)]; % add all nodes and their initial distances to the source to the list
        else
            candidate = [candidate inf];
        end
    end
    [t, u] = min(candidate); % start from node with the shortest distance to the source
    visited(u)=1; % mark it as visited
    for i=1:n % for each neighbour of the node u
        if(distance(u)+NetworkTopology(u,i))<distance(i) % if a shorter distance is found
            distance(i)=distance(u)+NetworkTopology(u,i); % update the distance
            previous(i)=u; % update the parent node through which a shorter distance is found
        end
    end
end
ShortestPath = [Destination];
while ShortestPath(1) ~= Source % as long as the source node is not in the path
    if previous(ShortestPath(1))<=n % to ensure the node has been visited in this path
        ShortestPath=[previous(ShortestPath(1)) ShortestPath]; % add the node to the path
    else
        error;
    end
end
TotalCost = distance(Destination); % the updated distance of the destination from the source
        
end