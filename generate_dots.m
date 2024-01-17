NUM_SAMPLES=100;
for n = 1:200
    x = 2;
    for j = 1.0:1.0:1.0
        attr = 'name';
        attr_value = 'dots_data';
        k = num2str(j);
        file_name = ['spiral_' k '.h5'];
        hdf5write(file_name, attr, attr_value);
        
        c = 2;
        % 1 hyperbolic a=0.95 / b=1.05 / θ=0. 
        % 2 spiral pattern, a=1.05 / b=1.05 / θ=5. 
        % 3 concentric pattern, a=1 / b=1 / θ=5. 
        % 4 "starburst" pattern, a=1.05 / b=1.05 / θ=0
        type = 1;
        %need to run 3 and 4
        if type == 1
            h = 0.95;
            i = 1.05;
            m = 0;
            typename = 'hyperbolic';
        elseif type == 2
            h = 1.05;
            i = 1.05;
            m = 0.5;
            typename = 'spiral';
        elseif type == 3
            h = 1;
            i = 1;
            m = 0.5;
            typename = 'concentric';
        else
            h = 1.05;
            i = 1.05;
            m = 0;
            typename = 'starburst';
        end
        trans = 2;
        numdots = 50;
        for a = h
            for b = i
                for theta = m
                    for num_trans = [trans]
                        for num_dots = [numdots]
                            current_s = struct('a',a,'b',b,'theta',theta/pi, 'num_trans', num_trans, 'num_dots', num_dots);
                            x_array = zeros(NUM_SAMPLES, 2, num_dots*2^num_trans);
                            for i = 1:NUM_SAMPLES
                                [e, x] = dots(current_s.a,current_s.b,current_s.theta,current_s.num_trans,current_s.num_dots);
                                x_array(i,:,:) = x;
        %                         dots_s(c) = struct('e',e,'x',x_array);
                            end
                            x_dset = hdf5.h5array(x_array);
                                e_dset = hdf5.h5array(e);
                        
                            path_name = [num2str(a) '/' num2str(b) '/' num2str(theta) '/' num2str(num_trans) '/' num2str(num_dots)];
                            hdf5write(file_name, [path_name '/e'], e_dset, 'WriteMode', 'append');
                            hdf5write(file_name, [path_name '/x'], x_dset, 'WriteMode', 'append');
                            c = c+1;
        
                        end
                    end
                end
            end
        end
    end
    %%
    y = 2;
    for j = 1.0:1.0:1.0
        attr = 'name';
        attr_value = 'dots_data';
        k = num2str(j);
        file_name = ['spiral_' k '.h5'];
        hdf5write(file_name, attr, attr_value);
        
        c = 1;
        % hyperbolic a=0.95 / b=1.05 / θ=0. 
        % spiral pattern, a=1.05 / b=1.05 / θ=5. 
        % concentric pattern, a=1 / b=1 / θ=5. 
        % "starburst" pattern, a=1.05 / b=1.05 / θ=0
        for a = h
            for b = i
                for theta = m
                    for num_trans = [0]
                        for num_dots = [1000]
                            current_s = struct('a',a,'b',b,'theta',theta/pi, 'num_trans', num_trans, 'num_dots', num_dots);
                            y_array = zeros(NUM_SAMPLES, 2, num_dots*2^num_trans);
                            for i = 1:NUM_SAMPLES
                                [e, y] = dots(current_s.a,current_s.b,current_s.theta,current_s.num_trans,current_s.num_dots);
                                y_array(i,:,:) = y;
        %                         dots_s(c) = struct('e',e,'y',y_array);
                            end
                            y_dset = hdf5.h5array(y_array);
                                e_dset = hdf5.h5array(e);
                        
                            path_name = [num2str(a) '/' num2str(b) '/' num2str(theta) '/' num2str(num_trans) '/' num2str(num_dots)];
                            hdf5write(file_name, [path_name '/e'], e_dset, 'WriteMode', 'append');
                            hdf5write(file_name, [path_name '/y'], y_dset, 'WriteMode', 'append');
                            c = c+1;
        
                        end
                    end
                end
            end
        end
    end
    i=1;
    %saveas(fig, 'test.jpg')
    %if n == 10
        %figure; 
        %scatter(x(1,:),x(2,:), '.', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.01);
        %scatter(x(1,:),x(2,:), 'filled', 'MarkerFaceColor', 'k');
        title('Random Dot Interference Pattern ');
        
        
        txt=['with eigenvalues:    ' num2str(e(1)) '   and    ' num2str(e(2)) newline ...
            'a=' num2str(current_s.a) ' b=' num2str(current_s.b) ' theta=' num2str(current_s.theta) ...
            ' NumTrans=' num2str(current_s.num_trans) ' NumDots=' num2str(current_s.num_trans)];
        xlabel(txt);
        %hgexport(figure, "test.jpg")
    %end
    %p = scatter(x(1,:),x(2,:), 'filled', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.02, SizeData=10);
    if n == 1
        %figure;
    end
    p1 = scatter(x(1,:),x(2,:), 'filled', 'MarkerFaceColor', 'b', SizeData=10);
    hold on;
    p2 = scatter(y(1,:),y(2,:), 'filled', 'MarkerFaceColor', 'b', SizeData=10);
    hold off;
    %p.facealpha("flat") 
    p = gobjects(2, 1);
    p(1) = p1;
    p(2) = p2;
    
    fig = figure('visible', 'off');
    ax = axes;
    copyobj(p, ax)
    set(gca, "Visible", "off")
    %figure;
    %figname = strcat('/3r_50d_spiral/', num2str(n), ".jpg");
    foldername = strcat(num2str(trans), 'r_', num2str(numdots), 'd_', typename, '_1000dist\');
    saveas(fig, [pwd strcat('\', foldername, num2str(n), '.jpg')]); 
    
    %saveas(p, num2str(n), "jpg")
end
close;
msgbox('Your code has finished executing!', 'Execution Complete', 'modal');
beep;

%figure