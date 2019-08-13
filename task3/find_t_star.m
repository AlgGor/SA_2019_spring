function [value,isterminal,direction] = find_t_star(t,xVec)
    value = xVec(2);     % detect height = 0
    isterminal = 1;   % stop the integration
    direction = 0;   % negative direction
end