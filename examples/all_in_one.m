% COMPLETE AERODYNAMIC ANALYSIS PIPELINE
% Combines all functionalities of ADBSat (Import, GSI, Merge, Solar, Normals)
% Author: miyawaki
% Date: 22.12..2024
% COMPLETE AERODYNAMIC AND GSI ANALYSIS WITH ADBSAT (WITHOUT IMPORT)
% This script assumes the model has already been imported.

clear; clc;

%% USER INPUTS AND INITIALIZATION
% Define model name and paths
modName = 'quasi-spherical'; % Model name (change as needed)
ADBSat_path = ADBSat_dynpath; % Path to ADBSat installation
modOut = fullfile(ADBSat_path, 'inou', 'obj_files', [modName, '.mat']); % Path to pre-imported .mat model
resOut = fullfile(ADBSat_path, 'inou', 'results');
tempOut = fullfile(ADBSat_path, 'temp'); % Temporary output folder

% Environmental conditions
alt = 200; % Altitude in km
inc = 51.6; % Inclination in degrees
env = [alt * 1e3, inc / 2, 0, 106, 0, 65, 65, ones(1, 7) * 3, 0]; % Environment parameters

% Aerodynamic angles
aoa = -45:5:45; % Angle of Attack in degrees
aos = -45:5:45; % Angle of Sideslip in degrees

% Model parameters
shadow = 1; % Enable shadow analysis
inparam.gsi_model = 'DRIA'; % GSI model
inparam.alpha = 1; % Accommodation coefficient
inparam.Tw = 300; % Wall temperature in Kelvin
solar = 1; % Enable solar analysis
inparam.sol_cR = 0.15; % Specular Reflectivity
inparam.sol_cD = 0.25; % Diffuse Reflectivity

% Other settings
verb = 1; % Verbose output
del = 1; % Delete temporary files after execution

%% STEP 1: CALCULATE AERODYNAMIC COEFFICIENTS
disp('Step 1: Calculating aerodynamic coefficients...');
pathOut = ADBSatFcn(modOut, resOut, inparam, aoa, aos, shadow, solar, env, del, verb);

%% STEP 2: CALCULATE SURFACE NORMALS AND PLOT
disp('Step 2: Calculating and visualizing surface normals...');
load(modOut, 'model'); % Load the pre-imported model

if exist('model', 'var') % Check if the model variable exists
    [normals, areas, barycentres] = surfaceNormals(model.vertices, model.faces);

    figure;
    quiver3(barycentres(:, 1), barycentres(:, 2), barycentres(:, 3), ...
        normals(:, 1), normals(:, 2), normals(:, 3));
    title('Surface Normals');
    xlabel('X'); ylabel('Y'); zlabel('Z');
    grid on;
else
    warning('Model variable not found in the .mat file. Skipping surface normals visualization.');
end

%% STEP 3: MERGE RESULTS
disp('Step 3: Merging aerodynamic database...');
mergedPath = mergeAEDB(resOut, modName, del);

%% STEP 4: PLOT RESULTS (Drag Coefficient Example)
disp('Step 4: Plotting aerodynamic results...');
load(mergedPath, 'aedb');

figure;
contourf((aedb.aos) .* (180 / pi), aedb.aoa .* (180 / pi), aedb.aero.Cf_wX);
colorbar;
xlabel('Angle of Sideslip (°)');
ylabel('Angle of Attack (°)');
title('Drag Force Coefficient (Cf_wX)');

%% STEP 5: FINAL DATA SAVE
disp('Step 5: Saving final aerodynamic database...');
finalPath = fullfile(ADBSat_path, 'results', [modName, '_final.mat']);
save(finalPath, 'aedb', '-v7.3');
disp(['Analysis complete. Results saved to: ', finalPath]);
