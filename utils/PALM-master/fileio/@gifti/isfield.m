<<<<<<< HEAD
function tf = isfield(this,field)
% Isfield method for GIfTI objects
% FORMAT tf = isfield(this,field)
% this   -  GIfTI object
% field  -  string of cell array
% tf     -  logical array
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin
% $Id: isfield.m 6507 2015-07-24 16:48:02Z guillaume $

tf = ismember(field, fieldnames(this));
=======
function tf = isfield(this,field)
% Isfield method for GIfTI objects
% FORMAT tf = isfield(this,field)
% this   -  GIfTI object
% field  -  string of cell array
% tf     -  logical array
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin
% $Id: isfield.m 6507 2015-07-24 16:48:02Z guillaume $

tf = ismember(field, fieldnames(this));
>>>>>>> 4de96d76c3932df0b65301ef0a8db73e89bc5fa6
