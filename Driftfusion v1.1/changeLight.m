function struct_Int = changeLight(struct, newInt, tmax)
%CHANGELIGHT - Stabilize solutions at a new light intensity
%
% Syntax:  struct_Int = changeLight(struct, newInt, tmax)
%
% Inputs:
%   STRUCT - a solution struct as created by PINDRIFT.
%   NEWINT - the requested light intensity
%   TMAX - the initial stabilization time, can be zero for an automatic
%     guess
%
% Outputs:
%   STRUCT_INT - a solution struct at NEWINT light intensity
%
% Example:
%   changeLight(ssol_i_light, 1e-3, 5)
%     take the solution ssol_i_light and stabilize to a new light intensity
%     of 0.001, use as stabilization time 5 seconds
%   changeLight(ssol_i_light, 1e-3, 0)
%     as above, but estimate a good time for stabilization
%
% Other m-files required: pindrift, verifyStabilization
% Subfunctions: none
% MAT-files required: none
%
% See also genIntStructs, pindrift.

% Author: Ilario Gelmetti, Ph.D. student, perovskite photovoltaics
% Institute of Chemical Research of Catalonia (ICIQ)
% Research Group Prof. Emilio Palomares
% email address: iochesonome@gmail.com
% Supervised by: Dr. Phil Calado, Dr. Piers Barnes, Prof. Jenny Nelson
% Imperial College London
% October 2017; Last revision: January 2018

%------------- BEGIN CODE --------------

p = struct.params;
p.pulseon = 0;
p.tmesh_type = 2;
p.t0 = 1e-10;
p.tpoints = 30;
struct_Int = struct;

% set an initial time for stabilization tmax
if tmax
    tmax_temp = tmax;
else % if tmax was zero, estimate a good one
    if p.mui
        tmax_temp = 2^(-log10(p.mui)) / 10 + 2^(-log10(p.mue_i));
    else
        tmax_temp = 2^(-log10(p.mue_i));
    end
end
p.tmax = tmax_temp;

% warnings about stability are not needed in the first steps
warning('off', 'pindrift:verifyStabilization'); 

% change light intensity in small steps
steps = 1 + ceil(abs(log10(newInt / p.Int)));

% if the step is just one, then newInt is the output of logspace function
Int_array = logspace(log10(p.Int), log10(newInt), steps);

%% change light in steps
% not needed to reach a good stabilized solution in
% each step, so stabilization is not verified here
% skip first value in the array as is the initial Int
for i = 2:length(Int_array)
    disp([mfilename ' - Go from light intensity ' num2str(p.Int) ' to ' num2str(Int_array(i)) ' over ' num2str(p.tmax) ' s'])
    p.Int = Int_array(i); % set new light intensity
    struct_Int = pindrift(struct_Int, p);
end

%% stabilize
while ~verifyStabilization(struct_Int.sol, struct_Int.t, 1e-8) % check stability in a strict way
    p.tmax = tmax_temp;
    disp([mfilename ' - Stabilizing over ' num2str(p.tmax) ' s']);
    struct_Int = pindrift(struct_Int, p);
    tmax_temp = p.tmax * 10; % this change gets saved in sol_Int only if another cycle is performed
end

% warnings about stability can be useful again
warning('on', 'pindrift:verifyStabilization');

% just repeat the last one, for sake of paranoia yeee
disp([mfilename ' - Stabilizing over ' num2str(p.tmax) ' s']);
struct_Int = pindrift(struct_Int, p);

%------------- END OF CODE --------------
