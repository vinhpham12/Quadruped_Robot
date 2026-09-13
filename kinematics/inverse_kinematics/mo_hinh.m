% 1. Nạp mô hình robot từ file URDF
robot = importrobot('C:\Users\ADMIN\Quadruped_Robot\final\urdf\final.urdf');
robot.DataFormat = 'row';

% 2. Hiển thị hình ảnh 3D đầy đủ vỏ và chi tiết của robot
figure('Name', 'Quadruped Robot 12-DOF');
show(robot, 'Visuals', 'on', 'Collisions', 'off');
view(3); grid on; axis equal;

% 3. Mở giao diện kéo thả chỉnh góc 12 servo tương tác trực tiếp
interactiveRigidBodyTree(robot);
