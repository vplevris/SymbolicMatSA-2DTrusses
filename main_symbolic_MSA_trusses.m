% Deriving Analytical Solutions Using Symbolic Matrix Structural Analysis:
% Part 2 – Plane Trusses
% Version 1.0 - 18 November 2024
% By Vagelis Plevris - vplevris@gmail.com

clear all, close all, clc

addpath('examples') % The folder containing the 5 examples

syms L H EA P real % Define some useful symbolic variables

assume(L,"positive")
assume(H,"positive")

example_1 % Example to run - Five examples are available
% Change this to run another input file

NumNodes = size(NodeCoords,1);  % Number of Nodes
NumElements = size(ElemCon,1); % Number of Elements
NumDOFs = 2*NumNodes; % Number of Degrees of Freedom (total)
Ktot = sym(zeros(NumDOFs));  % Total Stiffness Matrix

for i=1:NumElements % Form the Total Stiffness Matrix Ktot
    Node_i = ElemCon(i,1); % Start Node i
    Node_j = ElemCon(i,2); % End Node j
    xi = NodeCoords(Node_i, 1); yi = NodeCoords(Node_i, 2);
    xj = NodeCoords(Node_j, 1); yj = NodeCoords(Node_j, 2);
    Li = sqrt((xj-xi)^2+(yj-yi)^2); % Length of Element
    EAi = ElemMatSec(i); % EA of Element
    ki = EAi/Li * [ 1 -1 ; % Local stiffness matrix of Element (2x2)
                   -1  1 ];
    c=(xj-xi)/Li; s=(yj-yi)/Li; 
    Ti = [c s 0 0 ; % Transformation matrix of Element (2x4)
          0 0 c s ];
    kiGlob = Ti'*ki*Ti; % Global stiffness matrix of Element (4x4)
    Ktot(2*Node_i-1:2*Node_i,2*Node_i-1:2*Node_i) = Ktot(2*Node_i-1:2*Node_i,2*Node_i-1:2*Node_i) + kiGlob(1:2,1:2);
    Ktot(2*Node_j-1:2*Node_j,2*Node_j-1:2*Node_j) = Ktot(2*Node_j-1:2*Node_j,2*Node_j-1:2*Node_j) + kiGlob(3:4,3:4);
    Ktot(2*Node_i-1:2*Node_i,2*Node_j-1:2*Node_j) = Ktot(2*Node_i-1:2*Node_i,2*Node_j-1:2*Node_j) + kiGlob(1:2,3:4);
    Ktot(2*Node_j-1:2*Node_j,2*Node_i-1:2*Node_i) = Ktot(2*Node_j-1:2*Node_j,2*Node_i-1:2*Node_i) + kiGlob(3:4,1:2);
end

Ptot = sym(zeros(NumDOFs,1)); % Total vector of external forces P - Initialize
Ptot = reshape(PointLoads',NumDOFs,1);

SupportsR = reshape(Supports',NumDOFs,1); % Vector of Supports [0 or 1], Reshaped
indicesFree = find(~SupportsR); % IDs of the Free DOFs
indicesConstrained = find(SupportsR); % IDs of the Constrained DOFs

Kff = Ktot(indicesFree, indicesFree); % Kff Corresponding to the Free (Active) DOFs
Pf = Ptot(indicesFree); % The External Forces on the Free DOFs
Uf = inv(Kff)*Pf; % The Displacements of the Free DOFs

Utot = sym(zeros(NumDOFs,1)); % Total Displacements (All DOFs) - Initialize
Utot(indicesFree) = Uf; % Add contributions from Uf (Displacements of the Free DOFs)

Ftot = Ktot*Utot; % All forces, including all external loads and all support reactions

% Special Case: Add to Reactions Any External Forces Directly on Supported DOFs (if any)
ForcesOnSupports = zeros(size(PointLoads)); % Initialize the Matrix
ForcesOnSupports(Supports == 1) = PointLoads(Supports == 1); % Add Forces Directly on Supports
ForcesOnSupportsVec = reshape(ForcesOnSupports', NumDOFs, 1); % Reshape as Vector
Ftot = Ftot - ForcesOnSupportsVec; % Subtract to Take them Into Account for Equilibrium

FReactions = Ftot(indicesConstrained); % Final Support Reactions only, on the Constrained DOFs

ElemForces = sym(zeros(NumElements,2)); % Initialize the Matrix with Element Forces

for i=1:NumElements;
    Node_i = ElemCon(i,1); % Start Node i
    Node_j = ElemCon(i,2); % End Node j
    xi = NodeCoords(Node_i, 1); yi = NodeCoords(Node_i, 2);
    xj = NodeCoords(Node_j, 1); yj = NodeCoords(Node_j, 2);
    Li = sqrt((xj-xi)^2+(yj-yi)^2); % Length of Element
    EAi = ElemMatSec(i); % EA of Element
    ki = EAi/Li * [ 1 -1 ; % Local stiffness matrix of Element (2x2)
                  -1  1 ];
    c=(xj-xi)/Li; s=(yj-yi)/Li; 
    Ti = [c s 0 0 ; % Transformation matrix of Element (2x4)
          0 0 c s ];
    kiGlob = Ti'*ki*Ti; % Global stiffness matrix of Element (4x4)
    UigGlob(1:2,:) = Utot(2*Node_i-1:2*Node_i); % Global displacements of the specific Element at Node i
    UigGlob(3:4,:) = Utot(2*Node_j-1:2*Node_j); % Global displacements of the specific Element at Node j
    FiGlob = kiGlob*UigGlob; % Global Element Forces
    FiLocal = Ti * FiGlob; % Local Element Forces
    ElemForces(i,:) = FiLocal'; % For recording the Element Forces
end

%% Analysis Complete, Report the Analysis Results
UNodes = reshape(Utot,2,NumNodes)'; % Reshape to get NumNodes Rows and 2 columns
UNodes_Final = simplify(UNodes) % Simplify the Expressions
FReactions_Final = simplify(FReactions) % Simplify the Expressions
ElemForces_Final = simplify(ElemForces(:,2)) % Simplify the Expressions

%% For validation of the results, provide numeric values for specific inputs
% We use units m and kN for all inputs, and outputs will follow
% You can use any other consistent system of units
NumericInputs = [6 8 2e4 100] % For variables: [L H EA P]

UNodes_Final_Numeric = double(subs(UNodes_Final, [L,H,EA,P], NumericInputs))
FReactions_Final_Numeric = double(subs(FReactions_Final, [L,H,EA,P], NumericInputs))
ElemForces_Final_Numeric = double(subs(ElemForces_Final, [L,H,EA,P], NumericInputs))
