function prev_ind=find_prev_time(t_cur,tVec)
    
    prev_ind=find((tVec-t_cur)>0,1)-1;
end