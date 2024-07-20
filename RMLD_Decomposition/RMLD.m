

function [seps, nongroups, FEs,epsilon] = RMLD(fun, fun_number, options)
   ub        = options.ubound;
   lb        = options.lbound;
   dim       = options.dim;
   seps      = [];
   nongroups = {};
   FEs       = 0;
   NP=10;
   alpha     = 10^-12; 
   
   x         = (ub-lb).*rand(NP,dim)+lb;
   epsilon   = alpha*min(abs(feval(fun, x, fun_number)));
   FEs       = FEs+NP;
   
   p1  = lb * ones(1,dim);
   y1  = feval(fun, p1, fun_number);
   FEs = FEs+1;
    
   xremain = 1:1:dim;
    
   sub1 = xremain(1);
   sub2 = xremain(2:end);
    
   while size(xremain,2)>0 
       xremain=[];
       [sub1_a,xremain,FEs]=INTERACT(fun,fun_number,sub1,sub2,p1,y1,epsilon,FEs,xremain,options);
        
       if length(sub1_a)==length(sub1)
           if length(sub1)==1
              seps=[seps;sub1];
           else
              nongroups = {nongroups{1:end},sub1};
           end 
           if length(xremain)>1
               sub1=xremain(1);
               sub2=xremain(2:end);
           else
               seps=[seps;xremain(1)];
               break;
           end
            
       else
           sub1=sub1_a;
           sub2=xremain;
           if size(xremain,2)==0
               nongroups = {nongroups{1:end}, sub1};
               break;
           end
       end         
   end
end 