function [fiber] = make_fiber(w, modes, fiber_sections,delay)
% Makes a fiber matrix
%   multiplies each section and output a modes x modes transfer matrix
    m = diag([exp(-j*w*delay(1)) exp(-j*w*delay(2))]); % factor in each delay
    f = repmat(m,[1 1 fiber_sections]); % copy delay to each section
    fiber = f(:,:,1); % first fiber section
    u = make_unitary();
    for slice = 2:fiber_sections
        fiber = fiber*u*f(:,:,slice); % combine each section to one matrix
    end
end
