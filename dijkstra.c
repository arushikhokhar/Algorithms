#include<stdio.h>
#include<stdlib.h>

# define MAX 10
# define INF 99999

void dijkstra(int graph[MAX][MAX], int v, int start);

int main()
{
	int graph[MAX][MAX],v, start;
	int i, j;

	printf("Enter number of vertices (v): ");
	scanf("%d",&v);

	printf("Enter the graph nodes: \n");
	for(i=0; i<v; i++)
	{
		for(j=0; j<v; j++)
		{
			scanf("%d",&graph[i][j]);
		}
	}

	printf("Enter starting node: \n");
	scanf("%d",&start);

	dijkstra(graph, v, start);
}

void dijkstra(int graph[MAX][MAX], int v, int start)
{
	int cost[MAX][MAX];              //The edge weights, INF if the node is not directly linked to the node being processed (user will enter 0 in that case)
	int dist[MAX];      //Stores the shortest distance required to reach from the start node to that node
	int processed[MAX];              //Hold true or false, whether a node has been processed(true) or not(false)
	int prev[MAX];                   // Stores the node previous to the current node (will be used to make the graph of shortest distance)

	int i, j, count, min_dist, next;

    //The edge weights array

	for(i=0; i<v; i++)
	{
		for(j=0; j<v; j++)
		{
			if(graph[i][j]==0)
			{
				cost[i][j]=INF;
			}
			else
			{
				cost[i][j]=graph[i][j];
			}
		}
	}

	// The prev node and processed array

	for(i=0; i<v; i++)
	{
		dist[i] = cost[start][i];
		prev[i] = start;
		processed[i] = 0;
	}

	dist[start] = 0;
	processed[start] = 1;
	count = 1;

	while(count < (v-1))
	{
		min_dist = INF;
		for(i = 0; i < v; i++)
		{
			if(dist[i]<min_dist && !processed[i])
			{
				min_dist = dist[i];
				next=i;
			}
		}

		processed[next] = 1;
		for(i = 0; i < v; i++)
		{
			if(!processed[i])
			{
				if((min_dist + cost[next][i]) < dist[i])
				{
					dist[i]= (min_dist + cost[next][i]);
					prev[i]=next;
				}
			}
		}

		count++;
	}

	for(i = 0; i < v; i++)
	{
		if(i != start)
		{
			printf("The distance of %d from %d is %d", i, start, dist[i]);
			printf("Path is %d",i);

			j=i;

			do
			{
				j = prev[j];
				printf("->%d", j);
			}while(j != start);
		}
		printf("\n");
	}
}
