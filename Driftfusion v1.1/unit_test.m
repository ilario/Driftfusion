% test pindrift and related functions
% USAGE: runtests('unit_test')

% prepare solutions and indirectly test equilibrate and genIntStructs
% functions

[sol_eq, sol_i_eq, ssol_eq, ssol_i_eq,...
    sol_eq_SR, sol_i_eq_SR, ssol_eq_SR, ssol_i_eq_SR,...
    sol_light, sol_i_light, ssol_light, ssol_i_light,...
    sol_light_SR, sol_i_light_SR, ssol_light_SR, ssol_i_light_SR] = equilibrate();

symstructs_SR = genIntStructs(ssol_i_eq_SR, ssol_i_light_SR, 100, 1e-7, 4);

% prepare tests for boundary conditions
p = ssol_i_eq_SR.params;
p.BC = 2;
ssol_i_eq_SR_BC2 = pindrift(ssol_i_eq_SR, p);
p = ssol_i_light_SR.params;
p.BC = 2;
ssol_i_light_SR_BC2 = pindrift(ssol_i_light_SR, p);
symstructs_SR_BC2 = genIntStructs(ssol_i_eq_SR_BC2, ssol_i_light_SR_BC2, 100, 1e-7, 4);

%% test thing 1

true;

%% test thing 2

true;