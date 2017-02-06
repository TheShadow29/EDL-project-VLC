%coded by Xiao Long (University of Cambridge) and LC Png (Nanyang Technological University)
clear all;
clc
%---------------------ENTER PARAMETERS------------------------%
% Distance between tx and rx ( Meter )
heightLED = 1.48;
% Transmitter Semi-angle, angle of irradiance in half (Radian)
phi = (7.5*pi)/180;
% Speed of Light
c = 300E6; 
% Time
t = 0:0.01:4;
%---------------------END OF PARAMETERS-----------------------%


% 3D Meshgrid X-axis and Y-axis %
radius = heightLED * tan(phi);
[X,Y] = meshgrid(-radius:.02:radius); 
xydist = sqrt((X).^2 + (Y).^2);
hdist = sqrt(xydist.^2 + heightLED.^2);


%%%%%%%%%%%%%%%%% 2D Meshgrid L-axis %%%%%%%%%%%%%%%%%%%%%
L = -radius:.02:radius
hdist_2d = sqrt(L.^2 + heightLED.^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Incidence angles of receiver according to X-Y axis % 
incidence = atand(xydist.* heightLED ^(-1));


%%%%%%%%%%%%%%%%%% 2D Meshgrid L-axis %%%%%%%%%%%%%%%%%%%%
incidence_2d = atand(L.* heightLED ^(-1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Call Function RxSNR %
[HLOS, P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t); % SNR in dB at each X-Y location %
 % Received Power in mW at each X-Y location %

%-----------Plot the 3D diagram for SNR distribution WITH LEN--------%


figure(1)
mesh(X,Y,Z,'EdgeColor','black')
xlabel('Length of room [m]')
ylabel('Width of room [m]')
zlabel('SNR [db]')
hold on
title('3D Plot for Room SNR Distribution WITH Lens')


%-----Plot the 3D diagram for Total Rececived Power distribution-----%

figure(8)
mesh(X,Y,HLOS,'EdgeColor','black')
xlabel('Length [m]')
ylabel('Width [m]')
zlabel('Channel Gain')
title('3D Graph for Channel Gain Distribution')




%-----Rececived Power with len-----%
figure(2)
mesh(X,Y,P,'EdgeColor','black')
xlabel('Length of room [m]')
ylabel('Width of room [m]')
zlabel('Power [W]')
hold on
title('3D Plot for Received Power Distribution')


%-----Rececived Power without lens-----%
figure(3)
mesh(X,Y,PO,'EdgeColor','black')
xlabel('Length of room [m]')
ylabel('Width of room [m]')
zlabel('Power [W]')
hold on
title('3D Plot for Received Power Distribution WITHOUT lens')

%-----MEASUREMENT VALUE, Rececived Power with lens-----%
figure(4)
x = [-0.2:0.2/3:0.2];
current = [4.88 9.9 16.3 24.4 16.3 9.9 4.88];
y = (current/0.55)*(10^-6);
p = polyfit(x,y,2);

x2 = -0.2:0.01:0.2;
y2 = polyval(p,x2);
plot(x,y,'o',x2,y2)
ylabel('Received Power (W)')
xlabel('Surface length (m)')
title('Measured Total Received Power (W)')

hold on


%-----Impluse Plots-----%

%----------Time Domain---------%
figure(6)
plot(t,impulset,'black')

xlabel('Time (ns)')
ylabel('Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on
plot(t,impulsetd,'-.b')
h = legend('LOS','Diffused');
set(h,'Interpreter','none')

title('y(t)=x(t)*h(t)')
hold off

%----------Frequence Domain---------%
figure(7)
plot(1./t,impulsef,'black')
xlabel('Frequency (Hz) [10^8]') %axis according to the speed of light [3E8 m/s]
ylabel('Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on
plot(1./t,real(impulsefd),'-.b')
h = legend('LOS','diffused');
xlabel('Frequency (Hz) [10^8]')
ylabel('Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold off


%%%%%%%%%%%%%%% 2D Meshgrid L-axis %%%%%%%%%%%%%%%%%%%%%%%
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence_2d,hdist_2d,t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----Matlab Value, Rececived Power with Lens-----%
figure(5)
plot(L,P)
xlabel('Radius of Cone')
ylabel('Received Power (W)')
title('2D Plot for Received Power WITH lens')
