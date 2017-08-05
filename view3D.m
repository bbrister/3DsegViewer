function view3D(volume, units, labels)
% 3D volume viewer from XTK

if nargin < 2 || isempty(units)
    units = ones(3, 1);
end

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

% Write the volume to a temporary file
imWrite3D(volumePath, volume, units);

% If a segmentation is provided, triangulate and write it to a file
if nargin >= 3 && ~isempty(labels)
    
    assert(isequal(size(labels), size(volume)));
    
    imWrite3D(labelPath, labels, units);
%     % Take the boundary of the segmentation
%     boundary = bwperim(seg, 6);
%     idx = find(boundary);
%     [I, J, K] = ind2sub(size(boundary), idx);
%     
%     % Triangulate the boundary
%     dt = delaunayTriangulation(I, J, K);
%     
%     % Write the mesh to a temporary file
%     meshPath = fullfile(scriptDir, 'mesh.vtk');
end

% Run the viewer
htmlPath = fullfile(scriptDir, 'index.html');
system(['firefox ' htmlPath]);

end