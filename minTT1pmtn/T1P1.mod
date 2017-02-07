/*********************************************
 * OPL 12.6.0.0 Model
 * T1P1 model from Bulbul
 * Author: sarkara1
 * Creation Date: Feb 7, 2017 at 12:37:59 PM
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

dvar int+ X[jobIndices][horizon] in 0..1;  

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

//objective function
minimize sum(j in jobIndices, k in horizon : k >= R[j]+P[j])(X[j][k]*W[j]*maxl(k-D[j],0));

//constraints
subject to{
	
	forall(k in horizon){
		sum(j in jobIndices,t in horizon: t>maxl(k,R[j]+P[j]) && t< minl(Tmax,k+P[j]-1)) X[j][t] <= 1;
	}
	
	forall(j in jobIndices){
		sum(k in horizon) X[j][k] == 1;	
	}	
	
};
