%% Symbolic MSA: 2D Trusses - Example 2

NodeCoords = [  0  0 ;
                L  0 ;
			   L/2 H ]; 
ElemMatSec = [EA; EA; EA];
ElemCon = [1 2 ;
           1 3 ;
		   2 3 ];
Supports = [1 1 ; 
            0 1 ; 
			0 0 ]; 
PointLoads = [ 0  0 ; 
               0  0 ;
			   0 -P ];