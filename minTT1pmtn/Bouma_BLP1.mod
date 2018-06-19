/*********************************************
 * OPL 12.6.0.0 Model
 * This BLP Model is for solving 1|pmin;P=Pj;Rj|Sum(WjCj) problems
 * Reference:  
 * All Minimal and Maximal Open Single Machine Scheduling Problems are Pseudo-Polynomially Solvable
 * Master's Thesis of Bouma, H.W., 2017. Chapter 5 	
 * Author: sarkara1
 * Creation Date: Mar 4, 2017 at 2:41:36 PM
 *********************************************/

 //counts		
 int n = ...;	//number of jobs
 int p = ...;	//equal processing time
 int tt = n * p;
 int inf = 10000;	
 
 //ranges
 range N = 1..n; 
 range K = 1..p;
 range T = 1..tt;
 
 //job parameters
 int r[N] = ...;	//release date
 int d[N] = ...;	//due date
 int w[N] = ...;	//weights
 
 //weights
 int W[N][K][T]; 
 
 //subset of horizon
 int I[N][K][0..n-1];
 
// //non-model variables
// int schedule[T];
// {int} J = {i|i in N};
// int Jsize;
 
 dvar float+ x[N][K][T] in 0..1;
 
 execute preprocess{
 
 	//populate W
 	for(var j in N){
 		for(var k in K){
 			for(var t in T){
 				if((k < p) && (t <= tt - p + k) &&  (tt >= r[j]+p)){
 				 	W[j][k][t] = 0;			
 				}
 				else if(k == p && t >= r[j] + p){
 					W[j][k][t] = w[j] * t;  				
 				}		 			
 				else{
					W[j][k][t] = inf;  				 				
 				}
 			}	 		
 		}
 	}
 
 	//populate I
 	for(var a in N){
 	 	for(var b in K){
	 	 	for(var c = 0; c <= a-1; c++){
	 	 		if(b == p && a == n){
	 	 		 	I[a][b][c] = 0; 		
	 	 		}
	 	 		else{
	 	 		 	I[a][b][c] = b + c * p;	 		
	 	 		}	 	 	
	 	 	}	 	
 	 	}
 	}
 }
 
 minimize sum(j in N, k in K, t in T) W[j][k][t] * x[j][k][t];
 
 subject to{
 
 	c501:
	forall(j in N){
		forall(k in K){
			sum(t in T) x[j][k][t] >= 1;		
		}
	}
	
	c502:
	forall(t in T){
		sum(j in N, k in K) x[j][k][t] == 1;	
	}		
  
    c503:
  	forall(j in N){
		forall(k in 1..p-1){
			sum(t in I[j][k][0]..I[j][k][j-1]) x[j][k][t] - sum(t in I[j][k][0]..I[j][k][j-1]) x[j][k+1][t+1] >= 0;	
		}
	}
	
 }
  	
execute postprocess{
	write("Calculating the schedule\n");
	
	write("Schedule -> \n")
	for(var t in T){
		write("T"+t+" :");
		//decide which job part is selected 
		for(var n in N){
			for(var k in K){
				if(x[n][k][t] > 0){
					write(n+"/"+k+"/"+x[n][k][t]+"\t");		
				}	
			}		
		}
		write("\n");
	}
		
}	