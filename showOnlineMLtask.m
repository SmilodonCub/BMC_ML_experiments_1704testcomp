function [  ] = showOnlineMLtask( fig, xEye, yEye, vel )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    subplot(1,2,1);
    plot(xEye, yEye);
    subplot(1,2,2);
    plot(vel);

end

