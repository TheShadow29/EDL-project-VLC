%coded by Xiao Long (University of Cambridge) and LC Png (Nanyang Technological University)
function [HLOS,Zprx,X,Y,Z,impulse_response_t,impulse_response_f,impulse_response_diff,impulse_response_d] = illuminance_light2(irradiance,incidence,LED_VA,PD_FOV,t,angle1,delay1)

%For the equations, kindly refer to the paper
%L. Zeng et al., "Improvement of Data Rate by using Equalization in an Indoor Visible Light
%Communication System", 2008.
%T. Komine, "Visible Light Wireless Communications and its Fundamental
%Study", 2005.

brightness_factor=4;
%clear all; clc;
%electron charge (C)
q = 1.60E-19;
%irradiance = angle1; incidence = angle1;
%angle of irradiance (half phi)
phi = (irradiance*pi)/180;
%angle of incidence (half psi)
psi = (angle1*pi)/180;
%power emitted by LED (mW)
PLED = 30E-3*brightness_factor;
%detector area, ARX (or photodiode active area) (cm^2)
ARX = .78E-4;
%FOV (field of view) of detector, psi_c
psi_c = (PD_FOV*pi)/180;
%distance between tx and rx (m)
hd = 1.5;
%height of room
H = 3.0;

%order of Lambertian emission
m = real(-log(2)/log(cos(phi)));
%Lambertian radiant intensity (or transmitter radiant intensity)
Ro = real(((m+1)/(2*pi))*cos(phi)^m);
%transmitted power, PTX
PTX = PLED;

%t = 0:.01:5;
if angle1<=irradiance
    HLOS = (ARX/hd^2)*Ro*cos(psi);
else
    HLOS=0.0;
end
% elseif (psi>psi_c)
%     HLOS = 0.0;
% elseif (irradiance>LED_VA)
%     HLOS = 0.0;
% elseif (incidence>PD_FOV)||(irradiance>PD_FOV)
%     HLOS = 0.0;
% end;

%number of LEDs per led array - NoLEDs
NoLEDs = 1;
%total power of i LEDs in the directed path - PRXLOS
PRXLOS = NoLEDs*PTX*HLOS;


%photodiode responsitivity
response = 0.55;
%noise power of ambient light
pn = 0.07E-6/response;
%data rate 
Rb = 115200;
%noise bandwidth factor
I2 = 0.562;
Bn = Rb*I2;
%amplifier bandwidth
Ba = 4.5E6;
%amplifier noise current
iamplifier = 5E-12*Ba;

%total surface area of room - Aroom
Aroom = 5*5*2 + 5*H*2 + 5*H*2;
Floor_area = 5*5;
Wall1_area = 5*H*2;
Wall2_area = 5*H*2;
Ceiling_area = 5*5;
%average reflectivity - rho
rho = (1/Aroom)*(Floor_area*0.15 + ...
    Wall1_area*0.7  + ...
    Wall2_area*0.7  + ...
    Ceiling_area*0.8);
%the first diffused reflection of a wide-beam optical source emits an
%intensity 'Iprime' over the whole room surface 'Aroom'.
I = rho*PRXLOS/Aroom;
Iprime = I/(1-rho);
%received diffused power 'pdiff' with the photodiode's receiving area ARX
pdiff = ARX*Iprime;
%At the receiver, light passes through the optical filter 'Tf' and 
%concentrator 'g'. 
%Tf is the transmission coefficient of the optical filter.
Tf = 1.0;
%g is the concentrator index. I used a x6 lens for the concentrator.
%g is also the concentrator gain. The refractive index of plastic is 1.46.
%(My concentrator is a general cheapo plastic lens. 
%See the list at http://interactagram.com/physics/optics/refraction/)
%*N. Kumar and N. R. Lourenco, "LED-based visible light communication
%system: a brief survey and investigation", J. Engineering and Applied 
%Sciences, vol. 5, no. 4, pp. 296-307, 2010.
ri_conc = 1.46;

if (psi>=0) && (psi<=psi_c)
    g = (ri_conc^2)/(sin(psi_c)^2);
elseif (psi>psi_c)
    g = 0.0;
end;

%so the received power prx is
prx = (PRXLOS+pdiff)*Tf*g;

timefunction = (t+delay1).*exp(-2.*(t+delay1));
diffusedtimefunction = (t+2*delay1).*exp(-2.*(t+2*delay1));
frequencyfunction = 1./(2 + (1./(t+delay1))).^2;
%diffusedfreqfunction = 1./(exp(ratio.*(2 + (1./t)*1i)).*(2 + (1./t)*1i).^2) + ratio./(exp(ratio*(2 + (1./t)*1i)).*(2 + (1./t)*1i));
%diffusedfreqfunction = exp(ratio*(2 + (1./t)*1i))./(2 + (1./t)*1i).^2 - (ratio*exp(ratio*(2 + (1./t)*1i)))./(2 + (1./t)*1i);
diffusedfreqfunction = 1./(exp(4).*(2 + (1./(t+delay1))*1i).^2);

impulse_response_t = conv(prx,timefunction)*0.01;
impulse_response_diff = conv((prx-PRXLOS),diffusedtimefunction)*0.01;
impulse_response_f = PRXLOS.*frequencyfunction;
impulse_response_d = (prx-PRXLOS).*diffusedfreqfunction;

%In fact, there is also the refractive index of the lens/glass/plastic 
%covering the photodiode to consider (whose value is about 1.0-1.5); 
%however, it is usually ignored.
%shot noise variance - omegashot
omegashot = 2*q*response*(prx+pn)*Bn;
%amplifier noise variance - omegaamplifier
omegaamplifier = iamplifier^2*Ba;
%total noise variance - omegatotal
omegatotal = omegashot+omegaamplifier;
%signal-to-noise ratio SNR
SNR = (response*prx).^2./(omegatotal);
%convert SNR unit to dB
SNRdb_prx = 20*log10(prx);
SNRdb = 20*log10(SNR);

%------------------------------------
%xbar = [-3/3*0.2 -2/3*0.2 -1/3*0.2 -0.2*0.2 0 0.2*0.2 1/3*0.2 2/3*0.2 3/3*0.2];
%ampere = [4.96 9.9 16.3 22.3 24.4 22.3 16.3 9.9 4.96];
%voltage = 5; power = 20*log10(((ampere*voltage)*response).^2./omegatotal);
% figure(3)
% plot(xbar,power)
% xlabel('Cone Diameter (m)')
% ylabel('Received Power (W)')
%------------------------------------

%get radius from height hd (between the transmitter and receiver) at
%irradiance angle phi
radius = H/tan(pi-pi/2-phi);
%set grid using radius 
[X,Y] = meshgrid(-radius:.1:radius); 
%Geometry - get hypotenuse R
%R = sqrt((X).^2 + (Y).^2)./cos(pi-pi/2-phi);
R = sqrt(X.^2 + Y.^2)./sin(pi-pi/2-phi);
%distance between each led array
%dist_apart = 1.5;

%xbar = [-3/3*0.2 -2/3*0.2 -1/3*0.2 -0.2*0.2 0 0.2*0.2 1/3*0.2 2/3*0.2 3/3*0.2];
%[X2,Y2] = meshgrid(xbar);
%R2 = sqrt((X2).^2 + (Y2).^2)./cos(pi-pi/2-phi);
%translate SNR array to the graph function fx = (sin x)/x.
%Refer to http://press.princeton.edu/books/maor/chapter_10.pdf for 
%more info on sin graphs.
%P = power.*sin(R2)./R2;

%Z = SNRdb*sin(R)./R;
Z = SNRdb.*tan(R)./R;
Zprx = SNRdb_prx.*tan(R)./R;
% mesh(X+dist_apart,Y,Z,'EdgeColor','black')
% xlabel('Length of room [m]')
% ylabel('Width of room [m]')
% zlabel('SNR [db]')
% %axis([-2.5 2.5 -2.5 2.5 0 1])
% hold on
% 
% mesh(X,Y,Z,'EdgeColor','black')
% xlabel('Length of room [m]')
% ylabel('Width of room [m]')
% zlabel('SNR [db]')
% %axis([-2.5 2.5 -2.5 2.5 0 1])
% hold on
% 
% mesh(X,Y+dist_apart,Z,'EdgeColor','black')
% xlabel('Length of room [m]')
% ylabel('Width of room [m]')
% zlabel('SNR [db]')
% %axis([-2.5 2.5 -2.5 2.5 0 1])
% hold on
% 
% mesh(X+dist_apart,Y+dist_apart,Z,'EdgeColor','black')
% xlabel('Length of room [m]')
% ylabel('Width of room [m]')
% zlabel('SNR [db]')
%axis([-2.5 2.5 -2.5 2.5 0 1])
%hold on
                                           

% x=ones(size(t));
% tx=5.01:0.01:10;
% xx=zeros(size(tx));
% x=[x xx];
% z1 = conv(HLOS,pdiff)*0.01;
% z=conv(HLOS,x)*0.01;
% figure(2)
% plot(0:.01:15,z)


%title('Communication using White-LED: SNR 3D Plot for Room Illumination')






%Free codes by Ethan L.C. Png, 
%Nanyang Technological University, 13 July 2011.