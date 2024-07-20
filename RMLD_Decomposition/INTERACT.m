

function [sub1,xremain,FEs]= INTERACT(fun, fun_number,sub1,sub2,p1,y1,epsilon,FEs,xremain,options)
   ub        = options.ubound;
   lb        = options.lbound;
   
   p2 = p1;
   p2(sub1)=ub.*ones(1,length(sub1));
   y2=feval(fun, p2, fun_number);
   FEs=FEs+1;
   delta1 = y1-y2;
   
   p3=p1;
   p4=p2;
   p3(sub2) =(ub+lb)/2.*ones(1,length(sub2));
   p4(sub2) = (ub+lb)/2.*ones(1,length(sub2));
   y3 = feval(fun, p3, fun_number);
   y4 = feval(fun, p4, fun_number);
   delta2 = y3 - y4;
   FEs = FEs + 2;
   
   Monotonicity = 1;
   if y2 >= y1 && y3 >= y1
       if y4 >= y3 && y4 >= y2
           Monotonicity = 0;
       end
   end
   if y2 < y1 && y3 < y1
       if y4 < y3 && y4 < y2
           Monotonicity = 0;
       end
   end
   
   
   if abs(delta1-delta2)>epsilon && Monotonicity == 1
       if length(sub2)==1
           sub1=union(sub1,sub2);
       else
           k=floor(length(sub2)/2);
           sub2_1=sub2(1:k);
           sub2_2=sub2(k+1:end);       
           [sub1_1,xremain,FEs]= INTERACT(fun, fun_number,sub1,sub2_1,p1,y1,epsilon,FEs,xremain,options);
           [sub1_2,xremain,FEs]=INTERACT(fun, fun_number,sub1,sub2_2,p1,y1,epsilon,FEs,xremain,options);
           sub1=union(sub1_1,sub1_2);
       end
   else
       xremain=[xremain,sub2];
   end

   
 

