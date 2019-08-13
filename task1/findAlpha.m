function alpha=findAlpha(xyVec,p,q)
%         xyVec(1)=xyVec(1)-p;
%         xyVec(2)=xyVec(2)-q;
        if xyVec(1)==0
            alpha=pi-sign(xyVec(2))*pi/2;
        else
            m_tg=xyVec(2)/xyVec(1);
            if m_tg>=0
                alpha=atan(m_tg);
                if xyVec(2)<0 
                    alpha=pi+abs(alpha);
                end
            else
                alpha=atan(m_tg);
                if xyVec(1)>0 
                    alpha=2*pi+alpha;
                else
                    alpha=pi+alpha;
                end
            end
        end
        
end    