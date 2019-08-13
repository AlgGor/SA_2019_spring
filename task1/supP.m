%% sup func for P
function [val,supVec]=supP(l,a,b)
 
    function [val,supVec]=f1(l)
        l1=l(1);
        l2=l(2);
        val=(4*a*b*l2.^2+l1.^2)/(4*a*abs(l2));
        supVec=[l1/(2*abs(l2)*a);sign(l2)*(4*a*b*l2.^2-l1.^2)/(4*a*l2.^2)];
    end    
        
    function [val,supVec]=f2(l)
        l1=l(1);
        val=sqrt(b/a)*abs(l1);
        supVec=[sqrt(b/a)*sign(l1);0];
    end
        
        
    if (2*sqrt(a*b)*abs(l(2))>=abs(l(1)))
        [val,supVec]=f1(l);
    else
        [val,supVec]=f2(l);
    end

end