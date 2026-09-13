clc;
close all;
clear;

%% Tự động nạp Robotics Toolbox nếu chưa có trong path
if exist('SerialLink', 'class') == 0
    if exist('D:/Matlab/rvctools/startup_rvc.m', 'file')
        run('D:/Matlab/rvctools/startup_rvc.m');
    end
end

%% Kích thước hình học (mm)
L0 = 50;
L1 = 30;
L3 = 50;
L4 = 50;

%% Góc offset từ bảng mDH
theta1_offset = pi/2;
theta2_offset = 0;
theta3_offset = 0;

%% Khai báo 3 khớp quay cho 1 chân (Chân Trái Trước - LF theo chuẩn bảng mDH)
LF(1) = Link([0,  L0,  L1, -pi/2, 0], 'modified');
LF(2) = Link([0,   0,   0,  pi/2, 0], 'modified');
LF(3) = Link([0,   0,  L3,     0, 0], 'modified');

%% Đặt theta offset
LF(1).offset = theta1_offset;
LF(2).offset = theta2_offset;
LF(3).offset = theta3_offset;

%% Giới hạn góc khớp
LF(1).qlim = [-pi pi];
LF(2).qlim = [-pi pi];
LF(3).qlim = [-pi pi];

%% Tạo robot
robotLF = SerialLink(LF, 'name', 'LEG_LF');

%% Đoạn cố định từ frame cuối đến bàn chân
robotLF.tool = transl(L4, 0, 0);

%% Góc khởi tạo
q = deg2rad([0 0 0]);

%% Hiển thị robot
figure;
robotLF.plot(q, ...
    'workspace', [-150 150 -150 150 -150 150], ...
    'scale', 0.5);

grid on;
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
view(3);

%% Bảng chỉnh góc tương tác
robotLF.teach(q);