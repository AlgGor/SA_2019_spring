function  [vVec_out,mVec_out, psi_1_Vec_out,psi_2_Vec_out]=out_of_fuel(v_cur, m_cur, psi_1_cur,psi_2_cur,g,l,tVec,r,N)
    
    tspan=tVec(r:N);
%     disp(tspan);

    [~,solVec]=ode45(@(t,varVec) norm_mode_eq(t,varVec,g,l,0),tspan,[v_cur, m_cur, psi_1_cur,psi_2_cur]);

    if r==(N-1)
        solVec=cat(1,solVec(1,:),solVec(end,:));
    end

    vVec_out=solVec(2:end,1);
    mVec_out=solVec(2:end,2);
    psi_1_Vec_out=solVec(2:end,3);
    psi_2_Vec_out=solVec(2:end,4);
    
end