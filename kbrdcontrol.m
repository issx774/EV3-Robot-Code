%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title        : FSE100 Project – SPYN Disability Pick-up Car
% Version      : v1.1.4
% File Name    : kbrdcontrol.m
%
% Description  : 
%   Manual control script for the SPYN robot using keyboard input. Allows
%   directional movement (forward, backward, left, right), crane control
%   (up/down), and safe termination using 'q'. Activated on blue/green tiles.
%
% Author       : Group 8
% Last Updated : Alex Shao on April 22, 2025 (Arizona Time)
%
% Controls     :
%   - Arrow Keys: Drive robot (up, down, left, right)
%   - U         : Raise crane
%   - D         : Lower crane
%   - Q         : Quit manual mode
%
% Notes        :
%   - Called by `auto.m` when blue/green tiles are detected.
%   - Requires InitKeyboard and CloseKeyboard for keypress handling.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global key                 % Declare 'key' as a global variable to receive input
InitKeyboard();            % Initialize keyboard input system

while 1
    pause(0.1);            % Delay to prevent excessive polling
    switch key
        case 'uparrow'
            % Move forward
            brick.MoveMotor('AD', 20);
            
        case 'downarrow'
            % Move backward
            brick.MoveMotor('A', -20);
            brick.MoveMotor('D', -20);
            
        case 'leftarrow'
            % Turn left (rotate in place)
            brick.MoveMotor('A', 20);
            brick.MoveMotor('D', -20);
            
        case 'rightarrow'
            % Turn right (rotate in place)
            brick.MoveMotor('A', -20);
            brick.MoveMotor('D', 20);
            
        case 0
            % No key press – stop all motors (A, D, C) and coast
            brick.StopMotor('ADC', 'Coast');
            
        case 'u'
            % Raise crane (motor C)
            brick.MoveMotor('C', 15);
            
        case 'd'
            % Lower crane (motor C)
            brick.MoveMotor('C', -15);
            
        case 'q'
            % Quit manual control loop
            break;
    end
end

CloseKeyboard();           % Close keyboard input and clean up resources