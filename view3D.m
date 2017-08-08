function view3D(volume, units, labels)
% 3D volume viewer from XTK

if nargin < 2 || isempty(units)
    units = ones(3, 1);
end

if nargin < 3 || isempty(labels)
    labels = zeros(size(volume));
end
assert(isequal(size(labels), size(volume)));

% Get the path to this function
scriptDir = fileparts(mfilename('fullpath'));

assert(ndims(volume) == 3)

% Check for old temporary files
volumePath = fullfile(scriptDir, 'volume.nii');
labelPath = fullfile(scriptDir, 'labels.nii');
if exist(volumePath, 'file')
    delete(volumePath);
end
if exist(labelPath, 'file')
    delete(labelPath);
end

% Write the volume and labels to a temporary file
imWrite3D(volumePath, volume, units);
imWrite3D(labelPath, labels, units);
    
% % Take the boundary of the segmentation
% boundary = bwperim(labels, 6);
% idx = find(boundary);
% [I, J, K] = ind2sub(size(boundary), idx);
% 
% % Take the alpha shape and triangulate the boundary
% shp = alphaShape(I, J, K);
% [tetra, P] = alphaTriangulation(shp);
% 
% % Write the mesh to a temporary file
% meshPath = fullfile(scriptDir, 'mesh.vtk');
% vtkWrite(meshPath, 'polydata', tertrahedron, P(1), P(2), P(3), tetra)

% Run the viewer
htmlPath = fullfile(scriptDir, 'index.html');
system(['firefox ' htmlPath]);

end