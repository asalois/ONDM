function u = rotation_matrix(theta)
% This creates a rotation matrix that is unitary
    u = [cos(theta) sin(theta); -sin(theta) cos(theta)];
end