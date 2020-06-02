function [table] = makeTable(laser_power, span, step, comp, alpha1, alpha2, aeff1, aeff2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
table = combvec(laser_power, span, 0:step:span, comp, alpha1, alpha2, aeff1, aeff2);
end

