%[text] # 하드웨어 배포 코드
IPADRR = '10.179.103.135';
!ping 10.179.103.135
%%
%[text] ## Test the Closed Loop PID Controller
%[text] Once you have designed a controller for the bicopter, the next step is to implement it onto the Arduino. Download and open the **"Bicopter\_ClosedLoop\_PID.slx"** Simulink model.Inside the PID block we use C.Kp, C.Ki, and C.Kd. Once the previous step has been completed, the model will use these values.  The TCP status signal is used as  reset trigger so that the controller starts from zero initial conditions when data is sent. Follow the same steps as **Task 2** (connect USB cable, set COM pots, and define your Wi-Fi network settings) in the closed-loop Simulink model  and then program the board using **Build, Deploy & Star**t button. Most likely the COM port and IP address will be the same.  Remove USB cable and turn the power switch to **ON**.   Once again, connect to the Arduino TCP server using the following command, but be sure to check that the IP address is the same as before, or update as needed.
%[text] The compliation will provide the IP address in the Diagnostic Viewer of the Simunlink model. If needed, update  the variable `IPADRR='192.168.84.188'` with your device's IP address.
%[text] Next, we can define an input array, which is the desired angle of the close-loop control. The example below generates a reference singal with 0 radians, 0.3 radians and -0.3 radians inclination. 
dur = 2500;
% Generate setpoint signal
Input = zeros(dur,1);
Input(501:1000) = 0.3;
Input(1501:2000) = -0.3;
%[text] Run the following code to connect to the Arduino and test the controller. **Make sure to** **keep clear from the propellers before running the following sequence!!!**
%pause(10); % wait time after after powering (starting the server in the bi-copter). This time is needed to broadcast the IP address
tcp = tcpclient(IPADRR,25000)  % Generally the IP address remains unchanged
write(tcp,0,'single');
pause(1.5);
flush(tcp);
write(tcp,Input,'single');
tic
en = 0;
while en == 0
    dat = read(tcp,4,'double');
    en = dat(4);
end
D = read(tcp,4*dur,'double');
Output = D(1:4:end);
Control = D(2:4:end);
SP = D(3:4:end);
en = D(4:4:end);
T_f = toc;
clear tcp

figure
Time = 0:0.01:0.01*(dur-1);
plot(Time, SP);
hold on
plot(Time, Output);
% lsim(feedback(C*G,1),SP,Time);
legend('Desired Angle','Measured Angle');hold off

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
