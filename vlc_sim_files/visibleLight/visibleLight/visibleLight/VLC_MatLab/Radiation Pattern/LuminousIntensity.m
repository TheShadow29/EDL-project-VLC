%coded by Xiao Long (University of Cambridge) and LC Png (Nanyang Technological University)

clear all 
clc

%---------------------ENTER PARAMETERS------------------------%
% Distance between tx and rx ( Meter )
heightLED = 1.48;
% Transmitter Semi-angle, angle of irradiance in half (Radian)
phi = (7.5*pi)/180;
%---------------------END OF PARAMETERS-----------------------%


% 3D Meshgrid X-axis and Y-axis %
radius = heightLED * tan(phi);
[X,Y] = meshgrid(-radius:0.01:radius); 

xydist = sqrt((X).^2 + (Y).^2);
hdist = sqrt(xydist.^2 + heightLED.^2);
% Incidence angles of receiver according to X-Y axis % 
incidence1 = atand(xydist.* heightLED ^(-1));
incidence = (incidence1*pi) /180;

% m is the order of Lambertian emission
m = -log(2)/log(cos(phi)); % Order of Lambertian emission %

% I0 is the center luminous intensity of an LED
I0 = 24;

% Dd is the distance btw LED and PD(meter)
Dd=1.48;

% the luminous intensity in angle
I=I0/cos(phi)^m;

%horizontal luminance
E_hor=I./hdist.^2.*cos(incidence);

%Plot 3D luminance
figure(1)
mesh(X,Y,E_hor,'EdgeColor','black')
xlabel('Length [m]')
ylabel('Width [m]')
zlabel('Luminous Intensity [cd]')

%Plot Normal distribution
mu = (max(max(E_hor))+(min(min(E_hor))))/2;
s = (max(max(X))-min(min(X)))/1;

f = (1./(s*sqrt(2*pi))) .* exp(((E_hor-mu).^2)./(2*(s.^2))); 
%f = normpdf(E_hor, mean, standarddev);
figure(2)
mesh(X,Y,f)

xlabel('Length [m]')
ylabel('Width [m]')
zlabel('Normal Distribution')

