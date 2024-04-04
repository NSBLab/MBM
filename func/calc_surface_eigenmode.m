function [V,D,A,B] = calc_surface_eigenmode(verts, faces, k, sigma, lump)
%% CALCSURFACEEIGENMODE Calculates surface eigenmodes of a triangularised mesh
%% Examples
%   [x,y] = meshgrid(-10:10); z=x.^2+y.^2; f=delaunay(x(:),y(:)); v=[x(:),y(:),z(:)]; evecs=calc_surface_eigenmode(v,f,9); figure; for ii = 1:9; nexttile; patch('Vertices',v,'Faces',f,'FaceColor','interp','FaceVertexCData',evecs(:,ii)); view(3); end;    
%   [v,f] = sphereMesh(40); evecs = calc_surface_eigenmode(v,f,25); figure; for ii = 1:25; nexttile; patch('Vertices', v, 'Faces', f, 'FaceColor', 'interp', 'FaceVertexCData', evecs(:,ii), 'EdgeColor', 'none'); view(3); axis('equal','tight','off'); end;  
% 
% 
%% Input Arguments
% `verts - xyz coordinates of surface (V×3 matrix)`
%  
% `faces - triangulation of surface (F×3 matrix)`
%
% `k - number of modes to calculate (10 (default) | positive integer scalar)` 
%
% `sigma - target eigenvalue (-0.01 (default) | scalar)` Return the `k`
% eigenmodes whose eigenvalues are closest to `sigma`. 
%
% `lump - flag to enable lumping (false (default) | true)`
%
%
%% Output Arguments
% `V - eigenvectors (V×k matrix)`
% 
% `D - eigenvalues (k×1 matrix)`
% 
% `A - stiffness matrix (V×V matrix)`
% 
% `B - mass matrix (V×V matrix)`
% 
% 
%% TODO
% * docs
% 
% 
%% Authors
% Mehul Gajwani, Monash University, 2024
% 
% 


%% Prelims
if nargin < 3 || isempty(k);        k = 10;         end
if nargin < 4 || isempty(sigma);    sigma = -0.01;  end
if nargin < 5 || isempty(lump);     lump = false;   end


%% Copied from LaPy
t1 = faces(:,1);
t2 = faces(:,2);
t3 = faces(:,3);

v1 = verts(t1,:);
v2 = verts(t2,:);
v3 = verts(t3,:);

v2mv1 = v2 - v1;
v3mv2 = v3 - v2;
v1mv3 = v1 - v3;

cr = cross(v3mv2, v1mv3);
vol = 2 * sqrt(sum(cr .* cr, 2));

a12 = sum(v3mv2 .* v1mv3, 2) ./ vol;
a23 = sum(v1mv3 .* v2mv1, 2) ./ vol;
a31 = sum(v2mv1 .* v3mv2, 2) ./ vol;

a11 = -a12 - a31;
a22 = -a12 - a23;
a33 = -a31 - a23;

local_a = [a12; a12; a23; a23; a31; a31; a11; a22; a33];
i = [t1; t2; t2; t3; t3; t1; t1; t2; t3];
j = [t2; t1; t3; t2; t1; t3; t1; t2; t3];

a = sparse(i,j,double(local_a));

if ~lump
    b_ii = vol / 24;
    b_ij = vol / 48;
    local_b = [repmat(b_ij, 6, 1); repmat(b_ii, 3, 1)];
    b = sparse(i, j, double(local_b));
else
    b_ii = vol / 12;
    local_b = repmat(b_ii,3,1);
    i = [t1; t2; t3];
    b = sparse(i,i,double(local_b));
end


%% Outputs
A = a;
B = b;

[V,D] = eigs(A,B,k,sigma);
D = diag(D);


%%
% V(:,1) = sqrt(1/sum(B, "all")); % set first emode to be constant

for ii = 2:width(V) % set sign of first non-zero element to be positive
    v = V(:,ii);    % convention for aligning modes
    s = sign(v(find(v,1)));
    if s == -1; V(:,ii) = v * s; end
end

% Vinv = V.' * B;

end
