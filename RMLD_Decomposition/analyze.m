
function analyze(funcs)
    more off;

    % Number of non-separable groups for each function in CEC'2013 benchmark suite
     
    for f = funcs
        filename = sprintf('./results/f%02d.mat', f);
        load(filename);
        s=[];
        mat = zeros(length(nonseps), 20);
        drawline('=');
        fprintf('Function F: %02d\n', f);
        fprintf('FEs used: %d\n', FEs);
        fprintf('epsilon used: %d\n', epsilon);
        fprintf('Number of separables variables: %d\n', length (seps));
        fprintf('Number of non-separables groups: %d\n', length (nonseps));
    
        filename1 = sprintf('./cec2013/datafiles/f%02d.mat', f);
        filename2 = sprintf('./cec2013/datafiles/f%02d_opm.mat', f);
        flag = false;
        if(exist(filename1))
            load(filename1);
            flag = true;
        elseif(exist(filename2))
            load(filename2);
            flag = true;
        end
       
        printheader();

        for i=[1:1:length(nonseps)]
            fprintf('Size of G%02d: %3d  |  ', i, length (nonseps{i}));
            if(flag)
                ldim = 1;
                for g=1:length(s)
                    captured = length(intersect(p(ldim:ldim+s(g)-1), nonseps{i}));
                    ldim=ldim+s(g);
                    fprintf(' %4d', captured);
                    mat(i, g) = captured;
                end
            end
            fprintf('\n');
        end

        mat2 = mat;
        [temp I] = max(mat, [], 1);
        [sorted II] = sort(temp, 'descend');
        masks = zeros(size(mat));
        for k = 1:min(size(mat))
            mask = zeros(1, length(sorted));
            mask(II(k)) = 1;
            masks(I(II(k)), :) = mask;
            %point = [I(k) II(k)];
            mat(I(II(k)), :) = mat(I(II(k)), :) .* mask;
            [temp I] = max(mat, [], 1);
            [sorted II] = sort(temp, 'descend');
        end
        mat = mat2 .* masks;
        [temp I] = max(mat, [], 1);
        if(ismember(f, [19 20]))
            gsizes = cellfun('length', nonseps);
            fprintf('Number of non-separable variables correctly grouped: %d\n', max(gsizes));
        else
            fprintf('Number of non-separable variables correctly grouped: %d\n', sum(temp(1:length(s))));
        end
        drawline('=');
    end

end
% Helper Functions ----------------------------------------------------------
function drawline(c)
    for i=1:121
        fprintf(1,c);
    end
    fprintf('\n')
end

function printheader()
    fprintf('Permutation Groups|');
    for i=1:20
        fprintf(' %4s', sprintf('P%d', i));
    end 
    fprintf('\n')
    drawline('-');
end
% End Helper Functions ------------------------------------------------------


