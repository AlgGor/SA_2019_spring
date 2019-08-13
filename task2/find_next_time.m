function next_ind=find_next_time(t_cur,tVec)
    next_ind=find((tVec-t_cur)>0,1);
end