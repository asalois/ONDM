function plot_it(t, x, To, k)
% plot a 2d vector
    figure()
    hold on
    for i = 1:size(x,1)
        plot(t,abs(x(i,(1:length(t)))) )
    end
    formatSpec = 'Gaussian Pulse w/ To = %5.4f in Time Domain\n';
    ttl = sprintf(formatSpec,To);
    title(ttl);
    xlabel('Time (t)')
    ylabel('X(t)')
    formatSpec = 'to_%d';
    name =  sprintf(formatSpec,k);
    hold off
    saveas(gcf,name,'png');
    
    figure()
    hold on
    for i = 1:size(x,1)
        plot(t,angle(x(i,(1:length(t)))) )
    end
    formatSpec = 'Gaussian Pulse w/ To = %5.4f in Time Domain\n';
    ttl = sprintf(formatSpec,To);
    title(ttl);
    xlabel('Time (t)')
    ylabel('X(t)')
    formatSpec = 'toangle_%d';
    name =  sprintf(formatSpec,k);
    hold off
    saveas(gcf,name,'png');
end

