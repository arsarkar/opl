/*********************************************
 * OPL 12.6.0.0 Model
 * Author: sarkara1
 * Creation Date: Feb 7, 2017 at 2:33:08 PM
 *********************************************/
//variables
int N=...;				//number of jobs
range jobIndices = 1..N;
int P[jobIndices] = ...;		//processing time								
int R[jobIndices] = ...;		//ready time
int D[jobIndices] = ...;		//due dates
int W[jobIndices] = ...;		//weights

int Tmin;				//minimum starting time
int Tmax;				//maximum completion time
range horizon = Tmin..Tmax;

dvar int+ X[jobIndices][Tmin..Tmax+1] in 0..1; 

//pre calculation
execute
{
	var minR = 9999;
	for(var r in R){
		if(r<minR){
			minR = r;		
		}	
	}
	Tmin = minR + 1;
	var maxJ = 0
	for(var j in jobIndices){
		if(R[j] > D[j]){
			if(R[j]>maxJ){
				maxJ = 	R[j];	
			}			
		}
		else{
			if(D[j]>maxJ){
				maxJ = 	D[j];	
			}	
		}	
	}
	var sumP = 0;
	for(var j in jobIndices){
		sumP = sumP + P[j];	
	}
	Tmax = maxJ + sumP
};

minimize sum(j in jobIndices, k in horizon)(W[j]*maxl(k-D[j], 0)*(X[j][k]-X[j][k+1]));

subject to
{
	forall(j in jobIndices){
		sum(k in horizon)X[j][k] == P[j];		
	}

	forall(k in horizon){
		sum(j in jobIndices)X[j][k] <= 1;	
	}
	
	forall(j in jobIndices){
		sum(k in horizon)maxl((X[j][k]-X[j][k+1]), 0) == 1;		
	}
	
	forall(j in jobIndices){
		X[j][Tmax+1] == 0;		
	}
	
}

