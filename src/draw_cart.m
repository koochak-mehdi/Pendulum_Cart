function draw_cart(q)
clf

q1 = q(1);
q2 = q(2);

r_wheel = 1;
r_head = .3;
r_eyes = .1;
w_stab = .3;
h_stab = 3;

p0 = [q1; r_wheel; 0];        % x0 y0 z0
p2 = RotZ(q2)*[0; h_stab; 0] + p0;

%% floor
line([-8 8], [0 0], 'LineWidth',2, 'Color', 'k')

%% Arm
line([p0(1);p2(1)], [p0(2);p2(2)], 'LineWidth',10, 'Color', [.2 .4 .2]);

%% Head
rectangle('Position', [p2(1)-r_head, p2(2)-r_head, 2*r_head, 2*r_head],...
          'Curvature', [1 1],...
          'FaceColor', [.2 .3 .3]);

%% Eye
rectangle('Position', [p2(1)+(.9*r_head), p2(2)-r_eyes, 2*r_eyes, 2*r_eyes],...
          'Curvature', [1 1],...
          'FaceColor', 'r');

%% Wheel
rectangle('Position', [p0(1)-r_wheel, 0, 2*r_wheel, 2*r_wheel],...
          'Curvature', [1 1],...
          'FaceColor', [0.4660 0.6740 0.1880]);
      
%% Wheel_Masks
%center
rectangle('Position', [p0(1)-(.3*r_wheel), p0(2)-(.3*r_wheel), 2*(.3*r_wheel), 2*(.3*r_wheel)],...
          'Curvature', [1 1],...
          'FaceColor', [.2 .3 .3])
%lines
p1_wheel = p0 + RotZ(-q1/r_wheel) * [0; r_wheel; 0];
p2_wheel = p0 + RotZ(-q1/r_wheel) * RotZ(120*pi/180) * [0; r_wheel; 0];
p3_wheel = p0 + RotZ(-q1/r_wheel) * RotZ(-120*pi/180)* [0; r_wheel; 0];
line([p0(1) p1_wheel(1)], [p0(2) p1_wheel(2)], 'LineWidth', 7, 'Color', [.2 .3 .3])
line([p0(1) p2_wheel(1)], [p0(2) p2_wheel(2)], 'LineWidth', 7, 'Color', [.2 .3 .3])
line([p0(1) p3_wheel(1)], [p0(2) p3_wheel(2)], 'LineWidth', 7, 'Color', [.2 .3 .3])

xlim([-8 8])
ylim([-2 8])
pause(.02)

end

function R = RotZ(qz)
    R = [cos(qz)  -sin(qz) 0;sin(qz) cos(qz) 0; 0 0 1];
end