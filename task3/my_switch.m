function [value,isterminal,direction] = my_switch(t,x_psiVec)
    value = x_psiVec(4);     % detect height = 0
    isterminal = 1;   % stop the integration
    direction = 0;   % negative direction
end