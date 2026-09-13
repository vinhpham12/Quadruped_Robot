clear;
clc;
close all;

%% ==========================================
%  1. KÍCH THƯỚC HÌNH HỌC (mm)
% ==========================================
L0 = 50;   % Nửa chiều dài thân (khoảng cách từ tâm đến trước/sau)
L1 = 30;   % Nửa chiều rộng thân (khoảng cách từ tâm sang trái/phải)
L3 = 50;   % Chiều dài đùi (Thigh)
L4 = 50;   % Chiều dài cẳng chân (Shank)

%% ==========================================
%  2. GÓC OFFSET KHỚP THEO QUY TẮC BÀN TAY PHẢI
% ==========================================
% Quay +pi/2 (+90 deg) quanh trục Z1 (+Y) để đưa trục X1 hướng thẳng đứng xuống đất (-Z)
theta1_offset = pi/2;
theta2_offset = 0;
theta3_offset = 0;

%% ==========================================
%  3. KHAI BÁO ĐỘNG HỌC 4 CHÂN (mDH Craig chuẩn hoá 4 góc)
% ==========================================

% --- 1. CHÂN TRÁI TRƯỚC (LF) ---
% Toạ độ hông: X = +L1, Y = +L0
LF(1) = Link([0,  L0,  L1, -pi/2, 0], 'modified');
LF(2) = Link([0,   0,   0,  pi/2, 0], 'modified'); % Z2 hướng sang trái (+X)
LF(3) = Link([0,   0,  L3,     0, 0], 'modified');
LF(1).offset = theta1_offset;
LF(2).offset = theta2_offset;
LF(3).offset = theta3_offset;
LF(1).qlim = [-pi pi]; LF(2).qlim = [-pi pi]; LF(3).qlim = [-pi pi];
robotLF = SerialLink(LF, 'name', 'LF');
robotLF.tool = transl(L4, 0, 0);

% --- 2. CHÂN PHẢI TRƯỚC (RF) ---
% Toạ độ hông: X = -L1, Y = +L0
RF(1) = Link([0,  L0, -L1, -pi/2, 0], 'modified');
RF(2) = Link([0,   0,   0, -pi/2, 0], 'modified'); % Z2 hướng sang phải (-X)
RF(3) = Link([0,   0,  L3,     0, 0], 'modified');
RF(1).offset = theta1_offset;
RF(2).offset = theta2_offset;
RF(3).offset = theta3_offset;
RF(1).qlim = [-pi pi]; RF(2).qlim = [-pi pi]; RF(3).qlim = [-pi pi];
robotRF = SerialLink(RF, 'name', 'RF');
robotRF.tool = transl(L4, 0, 0);

% --- 3. CHÂN TRÁI SAU (LB) ---
% Toạ độ hông: X = +L1, Y = -L0
LB(1) = Link([0, -L0,  L1, -pi/2, 0], 'modified');
LB(2) = Link([0,   0,   0,  pi/2, 0], 'modified'); % Z2 hướng sang trái (+X)
LB(3) = Link([0,   0,  L3,     0, 0], 'modified');
LB(1).offset = theta1_offset;
LB(2).offset = theta2_offset;
LB(3).offset = theta3_offset;
LB(1).qlim = [-pi pi]; LB(2).qlim = [-pi pi]; LB(3).qlim = [-pi pi];
robotLB = SerialLink(LB, 'name', 'LB');
robotLB.tool = transl(L4, 0, 0);

% --- 4. CHÂN PHẢI SAU (RB) ---
% Toạ độ hông: X = -L1, Y = -L0
RB(1) = Link([0, -L0, -L1, -pi/2, 0], 'modified');
RB(2) = Link([0,   0,   0, -pi/2, 0], 'modified'); % Z2 hướng sang phải (-X)
RB(3) = Link([0,   0,  L3,     0, 0], 'modified');
RB(1).offset = theta1_offset;
RB(2).offset = theta2_offset;
RB(3).offset = theta3_offset;
RB(1).qlim = [-pi pi]; RB(2).qlim = [-pi pi]; RB(3).qlim = [-pi pi];
robotRB = SerialLink(RB, 'name', 'RB');
robotRB.tool = transl(L4, 0, 0);

%% ==========================================
%  4. GÓC KHỞI TẠO CÁC KHỚP
% ==========================================
% [Góc đứng thẳng mặc định]
q_straight = deg2rad([0 0 0]);
qLF = q_straight;
qRF = q_straight;
qLB = q_straight;
qRB = q_straight;

% (Tuỳ chọn: Nếu muốn tư thế đứng khuỵu gối tự nhiên, bỏ comment 4 dòng dưới):
% qLF = deg2rad([0,  30, -60]);
% qLB = deg2rad([0,  30, -60]);
% qRF = deg2rad([0, -30,  60]);
% qRB = deg2rad([0, -30,  60]);

%% ==========================================
%  5. HIỂN THỊ MÔ PHỎNG VÀ VẼ KHUNG BASE HÌNH QUE
% ==========================================
figure('Color', 'w', 'Name', 'Mô phỏng Quadruped Robot 4 Chân (Phương án A)');
hold on;
grid on;
axis equal;

% Cấu hình hiển thị của Robotics Toolbox
plot_opts = {'workspace', [-160 160 -160 160 -150 80], ...
             'scale', 0.45, ...
             'floorlevel', -120, ...
             'nobase', 'noshadow'};

% Vẽ 4 chân robot
robotLF.plot(qLF, plot_opts{:});
robotRF.plot(qRF, plot_opts{:});
robotLB.plot(qLB, plot_opts{:});
robotRB.plot(qRB, plot_opts{:});

%% ==========================================
%  6. VẼ KHUNG THÂN VÀ HỆ TRỤC GỐC {0}
% ==========================================
% 1. Trục dọc thân ở giữa (nối từ giữa sau -L0 đến giữa trước +L0 qua gốc {0})
plot3([0 0], [-L0 L0], [0 0], 'r-', 'LineWidth', 3);

% 2. Thanh ngang phía trước (nối RF sang LF tại Y = +L0)
plot3([-L1 L1], [L0 L0], [0 0], 'r-', 'LineWidth', 3);

% 3. Thanh ngang phía sau (nối RB sang LB tại Y = -L0)
plot3([-L1 L1], [-L0 -L0], [0 0], 'r-', 'LineWidth', 3);

% 4. Khung viền 2 bên sườn (nối trước ra sau)
plot3([L1 L1], [-L0 L0], [0 0], 'r--', 'LineWidth', 1.8);
plot3([-L1 -L1], [-L0 L0], [0 0], 'r--', 'LineWidth', 1.8);

% 5. Đánh dấu các khớp hông và tâm thân {0}
plot3(0, 0, 0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 7); % Tâm {0}
plot3([L1, -L1, L1, -L1], [L0, L0, -L0, -L0], [0, 0, 0, 0], ...
      'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6);

% 6. Vẽ hệ trục toạ độ gốc {0} tại tâm thân robot (X0, Y0, Z0)
arrow_len = 25;
quiver3(0, 0, 0, arrow_len, 0, 0, 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5); % X0 (Trái)
quiver3(0, 0, 0, 0, arrow_len, 0, 'g', 'LineWidth', 2, 'MaxHeadSize', 0.5); % Y0 (Trước)
quiver3(0, 0, 0, 0, 0, arrow_len, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5); % Z0 (Lên)

% Chú thích nhãn các trục và tên chân
text(arrow_len + 3, 0, 0, 'X_0 (Left)', 'Color', 'b', 'FontWeight', 'bold', 'FontSize', 10);
text(0, arrow_len + 3, 0, 'Y_0 (Front)', 'Color', 'g', 'FontWeight', 'bold', 'FontSize', 10);
text(0, 0, arrow_len + 3, 'Z_0 (Up)', 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 10);

text(L1 + 5, L0 + 5, 0, 'LF', 'FontWeight', 'bold', 'Color', [0.8 0 0]);
text(-L1 - 15, L0 + 5, 0, 'RF', 'FontWeight', 'bold', 'Color', [0.8 0 0]);
text(L1 + 5, -L0 - 5, 0, 'LB', 'FontWeight', 'bold', 'Color', [0.8 0 0]);
text(-L1 - 15, -L0 - 5, 0, 'RB', 'FontWeight', 'bold', 'Color', [0.8 0 0]);

xlabel('X (Trái - Phải) [mm]');
ylabel('Y (Sau - Trước) [mm]');
zlabel('Z (Cao) [mm]');
title('Mô phỏng Quadruped Robot 4 Chân 12-DOF (Phương án A)');

xlim([-160 160]);
ylim([-160 160]);
zlim([-150 80]);

view([135 25]); % Góc nhìn 3D rõ nét
