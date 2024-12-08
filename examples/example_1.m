%% Symbolic MSA: 2D Trusses - Example 1

NodeCoords = [  0  0 ; % Node 1 (x, y)
                L  L ; % Node 2 (x, y), etc
              3*L  0 ]; 
ElemMatSec = [EA; EA]; % EA of each Element
ElemCon = [1 2 ; % Connectivity of Element 1
           2 3 ]; % Connectivity of Element 2
Supports = [1 1; % [0 0] Means Free
            0 0; % [1 0] or [0 1] means Roller (y-Roller or x-Roller)
            1 1]; % [1 1] Means Pinned Support
PointLoads = [ 0  0; % Point load on Node 1: Fx and Fy
               0 -P; % Point load on Node 2: Fx and Fy
               0  0] ; % Point load on Node 3: Fx and Fy
