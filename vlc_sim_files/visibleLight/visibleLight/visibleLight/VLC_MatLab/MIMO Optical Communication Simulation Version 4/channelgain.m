%coded by Xiao Long (University of Cambridge) and LC Png (Nanyang Technological University)
function gain= channelgain(xlocation, ylocation, phi, space) 

% ---------------------------------ENTER PARAMETERS------------------------------------ %
% -------For 2 Prx_los------------------------------- %
% Transmitter Semi-angle, angle of irradiance in half (Radian)
%phi
% FOV (field of view) of detector in half (Radian) 
psi_c = (20*pi)/180;
% Power emitted by LED (W)
PLED = 0.1;
% Detector area, ARX (or photodiode active area) (Meter^2)
ARX = 7.8E-7;
% Distance between tx and rx (Meter)
heightLED = 1.48;

% --------For 3 Prx_diff----------------------------- %
% Room Size and reflectivity % (Meter)
L = 5;
W = 5;
H = 3;
n_floor = 0.15;
n_wall = 0.7;
n_ceiling = 0.8;
% --------For 4 Prx_total---------------------------- %
% Photodetect Concentrator refractive index %
n_conc = 1.46;
% Gain of len %
Tf = 10.0;
%----------------------------- END OF PARAMETERS -------------------------------------%

xydist = sqrt((xlocation).^2 + (ylocation).^2);
hdist = sqrt(xydist.^2 + heightLED.^2);
incidence = atand(xydist.* heightLED ^(-1));

% 2. For Prx_los %
m = -log(2)/log(cos(phi)); % Order of Lambertian emission %
Ro = ((m+1)/(2*pi))*cos(phi)^m; % Lambertian radiant intensity %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HLOS = (ARX./hdist.^2).*cos( (incidence*pi) /180)*Ro;  % Channel transfer function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Prx_los = PLED * HLOS; % Received power of LOS ( Watt )%

% 3. For Prx_diff %
Aroom = L * W * 2 + L * H * 2 + W * H * 2; % Whole room surface area %
Floor_area = L * W;
Wall1_area = L * H * 4;
Wall2_area = W * H * 2;
Ceiling_area = L * W; % Surface's areas (Meter^2)%
rho = (1 / Aroom) * (Floor_area * n_floor + ...
    Wall1_area * n_wall  + ...
    Ceiling_area * n_ceiling ); % Average relectivity %
I1 = PLED / Aroom * rho; % Optical intensity ( Watt/Meter^2 )%
I_total = I1 / ( 1 - rho ); % Total optical intensity %
% Received power of diffusion (Watt)%
Prx_diff = PLED / ( Aroom ) * rho / ( 1 - rho ) * ARX;

% 4. For Prx_total %
g = n_conc^2 / (sin(psi_c)^2); % PD Concentrator Gain %
% Received total power (W) %
Prx_total = ( Prx_los + Prx_diff ) * Tf * g; 

% 4. For Gain %
gain=Prx_total/PLED;

end
