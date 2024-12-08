%% Symbolic MSA: 2D Trusses - Example 3

NodeCoords = [  0  0 ;
                L  0 ;
              2*L  0 ;
			  L/2  H ;
			  3*L/2 H]; 
ElemMatSec = [EA; EA; EA; EA; EA; EA; EA];
ElemCon = [1 2 ;
           2 3 ;
		   4 5 ;
		   1 4 ;
		   2 4 ;
		   2 5 ;
		   3 5 ];
Supports = [1 1 ;
            0 0 ;
            1 1 ;
			0 0 ;
			0 0 ];
PointLoads = [ 0    0 ; 
               0    0 ;
               0    0 ;
			   2*P -P ;
			   0   -P ];
