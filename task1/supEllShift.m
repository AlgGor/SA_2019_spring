function [val,supVec]=supEllShift(lVec,s,r,p,q)
    [~,supVec]=supEll0(lVec,s,r);
    supVec=supVec+[p;q];
    val=dot(supVec,lVec);
end