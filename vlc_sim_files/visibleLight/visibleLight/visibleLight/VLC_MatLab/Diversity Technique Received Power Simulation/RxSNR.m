%coded by Xiao Long (University of Cambridge) and LC Png (Nanyang Technological University)
function [Prx_total, Prx_total_nolen, SNRdB, impulse_response_t, impulse_response_tdiff, impulse_response_f, impulse_response_fdiff ]= RxSNR(incidence,hdist,t,phiphi) 

% ---------------------------------ENTER PARAMETERS------------------------------------ %
% -------For 2 Prx_los------------------------------- %
% Transmitter Semi-angle, angle of irradiance in half (Radian)
phi = (2*phiphi*pi)/180;
% Power emitted by LED (W)
PLED = 0.2;
% FOV (field of view) of detector in half (Radian) 
psi_c = (phiphi*pi)/180;
% Detector area, ARX (or photodiode active area) (Meter^2)
ARX = 7.8E-7;
% Distance between tx and rx (Meter)
% heightLED = 1.48;

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
% --------For 5 SNR---------------------------------- %
% Noise-bandwidth factor %
I2 = 0.562;
% Data rate (Bit per second)
Rb = 115200;
% Ambient light power (Ampere) %
Iamb = 7E-8;
% Photodiode responsivity (A/W )%
R = 0.55;
% Electron charge (C)
q = 1.60E-19;
% Amplifier bandwidth (Hz)%
Ba = 4.5E6;
% Amplifier noise density (Ampere/Hz^0.5)%
Iamf = 5e-12 ;
%----------------------------- END OF PARAMETERS -------------------------------------%


% 2. For Prx_los %

m = -log(2)/log(cos(phi)); % Order of Lambertian emission %
Ro = [(m+1)/(2*pi)]*cos(phi)^m; % Lambertian radiant intensity %
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
Prx_total = ( Prx_los + Prx_diff ) * Tf * g; % With len %
Prx_total_nolen = ( Prx_los + Prx_diff ) * g; % Without len %
Prx_diff_total = Prx_diff *Tf*g; % Total received by diffusion %


% 5. For SNR %

Bn = I2 * Rb; % Noise-bandwidth (Sec^-1)%
Pamb = Iamb / R; % Ambient light power (W) %
% Shot-noise variance ( Ampere^2 )%
omega_shot = 2 * q * R * (Prx_total + Pamb) * Bn; 
% Amplifier noise variance ( Ampere^2 )%
omega_amplifier = Iamf^2 * Ba; 
% Total noise variance ( Ampere^2 )%
omega_total = omega_amplifier + omega_shot; 
% SNR %
SNR = (( R * Prx_total ).^2)./ omega_total; 

SNRdB = 20 * log10(SNR); % SNR in dB %



% 5. For impulse_response %

Prx_max = max(max(Prx_total));

timefunction = t.*exp(-2.*t);
diffusedtimefunction = t.*exp(-2.*(t+2));
frequencyfunction = 1./(2 + (1./t)).^2;
diffusedfreqfunction = 1./(exp(4).*(2 + (1./t)*1i).^2);

impulse_response_t = conv(Prx_max,timefunction)*0.01;
impulse_response_tdiff = conv(Prx_diff_total,diffusedtimefunction)*0.01;
impulse_response_f = Prx_max.*frequencyfunction;
impulse_response_fdiff = Prx_diff_total.*diffusedfreqfunction;



end
