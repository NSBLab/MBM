<<<<<<< HEAD
function map = spectral(m)
% Returns MNI's black-purple-blue-green-yellow-red-white colour map.

if nargin < 1
    m = size(get(gcf,'colormap'),1);
end
values = [
    0.2000 0.2000 0.2000
    0.4667 0.0000 0.5333
    0.5333 0.0000 0.6000
    0.0000 0.0000 0.6667
    0.0000 0.0000 0.8667
    0.0000 0.4667 0.8667
    0.0000 0.6000 0.8667
    0.0000 0.6667 0.6667
    0.0000 0.6667 0.5333
    0.0000 0.6000 0.0000
    0.0000 0.7333 0.0000
    0.0000 0.8667 0.0000
    0.0000 1.0000 0.0000
    0.7333 1.0000 0.0000
    0.9333 0.9333 0.0000
    1.0000 0.8000 0.0000
    1.0000 0.6000 0.0000
    1.0000 0.0000 0.0000
    0.8667 0.0000 0.0000
    0.8000 0.0000 0.0000
    0.8000 0.8000 0.8000];
P   = length(values);
X0  = linspace (1,P,m);
map = interp1(1:P,values,X0);
=======
function map = spectral(m)
% Returns MNI's black-purple-blue-green-yellow-red-white colour map.

if nargin < 1
    m = size(get(gcf,'colormap'),1);
end
values = [
    0.2000 0.2000 0.2000
    0.4667 0.0000 0.5333
    0.5333 0.0000 0.6000
    0.0000 0.0000 0.6667
    0.0000 0.0000 0.8667
    0.0000 0.4667 0.8667
    0.0000 0.6000 0.8667
    0.0000 0.6667 0.6667
    0.0000 0.6667 0.5333
    0.0000 0.6000 0.0000
    0.0000 0.7333 0.0000
    0.0000 0.8667 0.0000
    0.0000 1.0000 0.0000
    0.7333 1.0000 0.0000
    0.9333 0.9333 0.0000
    1.0000 0.8000 0.0000
    1.0000 0.6000 0.0000
    1.0000 0.0000 0.0000
    0.8667 0.0000 0.0000
    0.8000 0.0000 0.0000
    0.8000 0.8000 0.8000];
P   = length(values);
X0  = linspace (1,P,m);
map = interp1(1:P,values,X0);
>>>>>>> 4de96d76c3932df0b65301ef0a8db73e89bc5fa6
