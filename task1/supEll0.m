function [val,supVec]=supEll0(l,s,r)
    val=sqrt((l(1)^2)*r/s+r*(l(2)^2));
    supVec=[(l(1)*r/s)/val;(l(2)*r)/val];
end