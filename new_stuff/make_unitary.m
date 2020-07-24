function [m] = make_unitary()
% Makes 2x2 special unitary matrix that is complex
%   Detailed explanation goes here
    phy = rand(1) + rand(1)*i;
    m = [cos(phy) sin(phy); -sin(phy) cos(phy)];
end

