%% Symbolic MSA: 2D Trusses - Example 5

NodeCoords = [  0	0;
				L	0;
				L	H;
				2*L	H;
				2*L	2*H;
				3*L	2*H;
				4*L	2*H;
				4*L	H;
				5*L	H;
				5*L	0;
				6*L	0];

ElemMatSec = [EA; EA; EA; EA; EA; EA; EA; EA; EA; EA; EA; EA; EA; EA; EA; EA; EA; EA];
ElemCon = [ 1	2;
			1	3;
			2	3;
			2	4;
			3	4;
			3	5;
			4	5;
			4	6;
			5	6;
			6	7;
			6	8;
			7	8;
			7	9;
			8	9;
			8	10;
			9	10;
			10	11;
			9	11];

Supports = [  1	1;
				0	0;
				0	0;
				0	0;
				0	0;
				0	0;
				0	0;
				0	0;
				0	0;
				0	0;
				1	1];
				
PointLoads =[  0	0;
				0	0;
				0	0;
				0	0;
				0	0;
				0	-P;
				0	0;
				0	0;
				0	0;
				0	0;
				0	0];
