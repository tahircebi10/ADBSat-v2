function [ matOut ] = ADBSatImport( modIn, pathOut, verb )
%ADBSATIMPORT Creates a file .mat containing a structure with the following fields
%     XData     : 3xN matrix X coordinates of the vertices (triangular)
%     YData     : 3xN matrix Y coordinates of the vertices (triangular)
%     ZData     : 3xN matrix Z coordinates of the vertices (triangular)
%     Areas     : Areas of the triangular faces  
%     SurfN     : Surface normals 
%     BariC     : Surfaces baricenters 
%      Lref     : Refrence longitude
%
% Inputs:
%       fileIn  : Input filename string should include either .stl or .obj extension
%       verb    : Verbose flag
%
% Outputs:
%       matOut : Full path to the output MAT file   
%
% Author: David Mostaza-Prieto
% The University of Manchester
% November 2012
%
%--- Copyright notice ---%
% Copyright (C) 2021 The University of Manchester
% Written by David Mostaza Prieto,  Nicholas H. Crisp, Luciana Sinpetru and Sabrina Livadiotti
%
% This file is part of the ADBSat toolkit.
%
% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or (at
% your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License along
% with this program. If not, see <http://www.gnu.org/licenses/>.
%------------- BEGIN CODE --------------
modIn= 'D:\Users\Tahir\Thesis\ADBSat\inou\stl_files\sphere_100mm.STL';
pathOut= 'D:\Users\Tahir\Thesis\ADBSat\inou\results';
verb = true;
[modPath,modName,ext] = fileparts(modIn); % Path to the .obj or .stl file

% Check if the input file is STL, and convert it to OBJ if needed
 if strcmpi(ext, '.stl')
    % Define the output path for the converted OBJ file
    objpath = fullfile(modPath, [modName, '.obj']);
        
    % Define the full path to the Python script
    pythonScriptPath = 'D:\Users\Tahir\Thesis\ADBSat-v2\convert_stl_to_obj.py';
        
    % Prepare and execute the command to run the Python script
    command = sprintf('python "%s" "%s" "%s"', pythonScriptPath, modIn, objpath);
    status = system(command); % Run the Python script to convert STL to OBJ
        
    % Check if the conversion was successful
    if status ~= 0
        error('Failed to convert STL to OBJ using the Python script.');
    end
else
    % Use the OBJ path directly if the file is already in OBJ format
    objpath = fullfile(modPath, [modName, '.obj']);
end

% Process the OBJ file as before
matOut = importobjtri(objpath, pathOut, modName, verb);

% Optional visualization if verbose mode is enabled
if verb
    plotNormals(matOut); % Plot the surface with normals for visual verification
end
