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
meshPath = fullfile(scriptDir, 'mesh.vtk');
if exist(volumePath, 'file')
    delete(volumePath);
end
if exist(labelPath, 'file')
    delete(labelPath);
end
if exist(meshPath, 'file')
    delete(meshPath);
end

% Write the volume and labels to a temporary file
imWrite3D(volumePath, volume, units);
imWrite3D(labelPath, labels, units);

% Optionally create a mesh of the segmentation
if any(labels(:))
    
    % Get the coordinates
    idx = find(labels);
    [I, J, K] = ind2sub(size(labels), idx);    
    I = I * units(1);
    J = J * units(2);
    K = K * units(3);
    
    % Subtract the center for XTK
    center = size(volume) .* units' / 2;
    I = I - center(1);
    J = J - center(2);
    K = K - center(3);
    
    % Take the alpha shape and triangulate the boundary
    shp = alphaShape(I, J, K);
    tri = boundaryFacets(shp);
    assert(max(tri(:)) == length(I));
    
    % Write the mesh to a temporary file
    vtkwrite(meshPath, 'polydata', 'triangle', I, J, K, tri)

%      fv = isosurface(labels, 0.5);
%      I = fv.vertices(1, :);
%      J = fv.vertices(2, :);
%      K = fv.vertices(3, :);
%      vtkwrite(meshPath, 'polydata', 'triangle', I, J, K, fv.faces)
end

% Run the viewer
htmlPath = fullfile(scriptDir, 'index.html');
system(['firefox ' htmlPath]);

end