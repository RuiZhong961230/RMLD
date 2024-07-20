clear all;

func = [1:15];
for i = func
    func_num = i;
    t1 = [13 14];
    t2 = [1 4 7 8 11 12 15];
    t3 = [2 5 9];

    if (ismember(func_num, t1))
        D=905;
        lb = -100;
        ub = 100;
    elseif (ismember(func_num, t2))
        D=1000;
        lb = -100;
        ub = 100;
    elseif (ismember(func_num, t3))
        D=1000;
        lb = -5;
        ub = 5;
    else
        D=1000;
        lb = -32;
        ub = 32;
    end

    opts.lbound  = lb;
    opts.ubound  = ub;
    opts.dim     = D;
    %opts.epsilon = 1e-3;

    addpath('cec2013');
    addpath('cec2013/datafiles');
    global initial_flag;
    initial_flag = 0;
    
    [seps, nonseps, FEs,epsilon] = RMLD('benchmark_func', func_num, opts);

    filename = sprintf('./results/f%02d', func_num);
    save (filename, 'seps', 'nonseps', 'FEs', 'epsilon','-v7');
end

