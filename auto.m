%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title        : FSE100 Project – SPYN Disability Pick-up Car
% Version      : v1.1.4
% File Name    : auto.m
%
% Description  : 
%   Autonomous assistive vehicle developed for object pick-up support. 
%   It navigates using forward motion, detects colored tiles (red for stop, 
%   blue/green for manual override), and uses touch and ultrasonic sensors 
%   to detect and avoid obstacles.
%
% Author       : Group 8
% Last Updated : Alex Shao on April 22, 2025 (Arizona Time)
%                - Updated logic for angle turning with migration from turning
%                  over a sepcific time span to agular rotation by angle for
%                  exact 90 degree turns
%
% Hardware     : LEGO EV3 Brick
% Sensors Used : 
%   - Touch Sensor (Port 2)
%   - Color Sensor (Port 3)
%   - Ultrasonic Sensor (Port 1)
%
% Motors Used  : 
%   - Motor A (Left drive motor)
%   - Motor D (Right drive motor)
%
% Notes        :
%   - Manual control triggered via blue/green tiles using external script.
%   - Turns implemented using MoveMotorAngleRel for smoother rotation.
%   - Uses precise thresholding for distance-based path correction.
%
% Dependencies :
%   - Requires 'kbrdcontrol.m' script for manual override
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

af =  67.8; % Motor A: Forward speed for left motor
df = 70;    % Motor D: Forward speed for right motor
ab = -20;   % Motor A: Left motor speed for backing up
db = -23.5; % Motor D: Right motor speed for backing up
threshold = 45; %Ultrasonic distance threshold for obstacle detection

brick.SetColorMode(3, 2); % Set color sensor (Port 3) to detect color codes

while 1 % initiate infinite loop
   brick.MoveMotor('A', af); % Move forward using predefined speed
   brick.MoveMotor('D', df);
  
   % Get Sensor Readings
   touch = brick.TouchPressed(2);       % Touch sensor (Port 2) reading
   color = brick.ColorCode(3);          % Color sensor (Port 3) reading
   distance = brick.UltrasonicDist(1);  % Ultrasonic sensor (Port 1) reading
  
   % Color Decisions
   if color == 5                         % Red tile detection
    %    disp(color);                     % Display color code
       disp('red');
       brick.StopMotor('AD', 'Brake');  % Brake to prevent deviation
       pause(2);                        % Wait for 2 seconds
       brick.MoveMotor('AD', af);       % Resume forward motion
       pause(0.5);
   elseif color >= 2 && color <= 4      % Blue or green tile detection
       disp('blue/green/yellow');              % Allow manual override
       disp(color);
       run('manual');              % Execute manual control script
       brick.MoveMotor('A', af);        % Resume forward motion after manual
       brick.MoveMotor('D', df);
       pause(6);                        % Short delay before resuming full automation
   end

   % Obstacle Avoidance Based on Ultrasonic Sensor
   if distance > threshold              % Detected wide open space in front
       pause(0.7);                      % Allow vehicle to fully pass the obstacle
       brick.StopMotor('AD', 'Brake');  % Stop motors
       brick.MoveMotorAngleRel('A', 50, -450, 'Coast'); % Turn right using left motor rotation
       pause(2.3);                      % Wait for turn to complete
       brick.StopMotor('A', 'Brake');   % Stop turning
       brick.MoveMotor('A', af);        % Resume forward motion
       brick.MoveMotor('D', df);
       pause(2);
   end

   % Touch Sensor – Frontal Collision Logic
   if ~isnan(touch) && touch            % If touch sensor triggered
       disp('touched');
       disp('Front wall encountered, backing up to turn right');
       brick.StopMotor('AD');           % Stop both motors
       distance = brick.UltrasonicDist(1); % Get distance again (possibly for right-side wall)
       brick.MoveMotor('A', ab);        % Reverse left motor
       brick.MoveMotor('D', db);        % Reverse right motor
       pause(2.4);                      % Time to back away from wall
       brick.StopMotor('AD', 'Brake');  % Stop after backing up

       % Recheck and react based on right-side distance
       if distance < threshold          % If there’s no wall on the right
           brick.MoveMotorAngleRel('D', 62, -450, 'Coast'); % Turn left using right motor
           pause(2.5);
           brick.StopMotor('D', 'Brake');
           brick.MoveMotor('AD', af);   % Resume forward
           pause(2);
       % the logic below might not be useful
       else                             % If wall is still on the right
           pause(2);                    % Wait briefly
           brick.MoveMotorAngleRel('D', 62, -450, 'Coast'); % Still turn left to escape
           pause(2.5);
           brick.StopMotor('A', 'Brake');
           brick.MoveMotor('A', af);    % Resume forward motion
           brick.MoveMotor('D', df);
           pause(2);
       end
   end
end