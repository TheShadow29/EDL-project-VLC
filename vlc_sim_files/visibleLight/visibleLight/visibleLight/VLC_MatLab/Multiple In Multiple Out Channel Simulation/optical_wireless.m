%coded by Xiao Long (University of Cambridge) and LC Png (Nanyang Technological University)
function varargout = optical_wireless(varargin)
% OPTICAL_WIRELESS M-file for optical_wireless.fig
%      OPTICAL_WIRELESS, by itself, creates a new OPTICAL_WIRELESS or raises the existing
%      singleton*.
%
%      H = OPTICAL_WIRELESS returns the handle to a new OPTICAL_WIRELESS or the handle to
%      the existing singleton*.
%
%      OPTICAL_WIRELESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTICAL_WIRELESS.M with the given input arguments.
%
%      OPTICAL_WIRELESS('Property','Value',...) creates a new OPTICAL_WIRELESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before optical_wireless_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optical_wireless_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optical_wireless

% Last Modified by GUIDE v2.5 30-Sep-2011 10:43:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @optical_wireless_OpeningFcn, ...
    'gui_OutputFcn',  @optical_wireless_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before optical_wireless is made visible.
function optical_wireless_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optical_wireless (see VARARGIN)

% Choose default command line output for optical_wireless
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes optical_wireless wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = optical_wireless_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%obtains the slider value from the slider component
global sliderValueX sliderValueY
sliderValueY = get(handles.slider4,'Value');
sliderValueX = get(handles.slider3,'Value');
Xpoint = sliderValueX;
Ypoint = sliderValueY;

sliderValue = get(handles.slider1,'Value');
hd = 1.5;
%puts the slider value into the edit text component

set(handles.edit1,'String', num2str(sliderValue));
set(handles.edit4,'String', num2str(sliderValueX));
set(handles.edit5,'String', num2str(sliderValueY));
%%%%%%%%%%%CIRCLE%%%%%%%%%%
p = 0; %(centre the circle 0,0)
%RADIUS = r;
RADIUS = tand(sliderValue)*1.5; %1.5 is the height between TX & RX



%axes1 plot
%%%%%%%Build a circle%%%%%%%
dist_apart_x = 0.5;
dist_apart_y = 0.5;
%Light 1

[X1,Y1]=circle([p,p],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

%Light 2

[X1,Y1]=circle([p+dist_apart_x,p],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

%Light 3

[X1,Y1]=circle([p,p-dist_apart_y],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p-dist_apart_y],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p-dist_apart_y],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p-dist_apart_y],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

%Light 4

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold off

%RECEIVER LOCATION-----------------------
%Xpoint = -0.4;
%Ypoint = 0.2;


%--------------------------------


light1_x = abs(Xpoint-p);
light1_y = abs(Ypoint-p);

if light1_x == 0
    light1_hypotenuse = sqrt(light1_y.^2+hd.^2);
    angle1 = acosd(hd./light1_hypotenuse);
    delay1 = light1_hypotenuse./3E8;
elseif light1_y == 0
    light1_hypotenuse = sqrt(light1_x.^2+hd.^2);
    angle1 = acosd(hd./light1_hypotenuse);
    delay1 = light1_hypotenuse./3E8;
else
    flat1_hypotenuse = sqrt(light1_x.^2+light1_y.^2);
    light1_hypotenuse = sqrt(flat1_hypotenuse.^2+hd.^2);
    angle1 = acosd(hd./light1_hypotenuse);
    delay1 = light1_hypotenuse./3E8;
end
    

light2_x = abs(Xpoint-dist_apart_x);
light2_y = abs(Ypoint-p);

if light2_x == 0
    light2_hypotenuse = sqrt(light2_y.^2+hd.^2);
    angle2 = acosd(hd/light2_hypotenuse);
    delay2 = light2_hypotenuse/3E8;
elseif light2_y == 0
    light2_hypotenuse = sqrt(light2_x.^2+hd.^2);
    angle2 = acosd(hd/light2_hypotenuse);
    delay2 = light2_hypotenuse/3E8;
else
    flat2_hypotenuse = sqrt(light2_x.^2+light2_y.^2);
    light2_hypotenuse = sqrt(flat2_hypotenuse.^2+hd.^2);
    angle2 = acosd(hd./light2_hypotenuse);
    delay2 = light2_hypotenuse./3E8;
end


light3_x = abs(Xpoint-p);
light3_y = abs(Ypoint-dist_apart_y);

if light3_x == 0
    light3_hypotenuse = sqrt(light3_y.^2+hd.^2);
    angle3 = acosd(hd./light3_hypotenuse);
    delay3 = light3_hypotenuse./3E8;
elseif light3_y == 0
    light3_hypotenuse = sqrt(light3_x.^2+hd.^2);
    angle3 = acosd(hd./light3_hypotenuse);
    delay3 = light3_hypotenuse./3E8;
else
    flat3_hypotenuse = sqrt(light3_x.^2+light3_y.^2);
    light3_hypotenuse = sqrt(flat3_hypotenuse.^2+hd.^2);
    angle3 = acosd(hd./light3_hypotenuse);
    delay3 = light3_hypotenuse./3E8;
end


light4_x = abs(Xpoint-dist_apart_x)
light4_y = abs(Ypoint-dist_apart_y)

if light4_x == 0
    light4_hypotenuse = sqrt(light4_y.^2+hd.^2);
    angle4 = acosd(hd./light4_hypotenuse);
    delay4 = light4_hypotenuse./3E8;
elseif light4_y == 0
    light4_hypotenuse = sqrt(light4_x.^2+hd.^2);
    angle4 = acosd(hd./light4_hypotenuse);
    delay4 = light4_hypotenuse./3E8;
else
    flat4_hypotenuse = sqrt(light4_x.^2+light4_y.^2);
    light4_hypotenuse = sqrt(flat4_hypotenuse.^2+hd.^2);
    angle4 = acosd(hd./light4_hypotenuse);
    delay4 = light4_hypotenuse./3E8;
end

% if angle1<2||angle2<2||angle3<2||angle4<2
%     angle1=2;
%     angle2=2;
%     angle3=2;
%     angle4=2;
% end;
%guidata(hObject, handles);
%axes2 plot
c = 300E6; %speed of light
t = 0:0.01:4; %time

%angle of irradiance = angle of incidence 
%(refer to the diagram in "Improvement of Data Rate by using Equalization in an 
%Indoor visible Light Communication System" by L. Zeng et al.)
irradiance = sliderValue;
incidence = sliderValue;
% LED viewing angle LED_VA = (VA/2)
LED_VA = 15; 
% Field of view of PIN photodiode PD_FOV = (FOV/2)
PD_FOV = 20; 
psi_c = PD_FOV;
%
[HLOS1,Zprx1,Xa1,Ya1,Za1,impulse_response_t1,freq_response_f1,impulse_response_diff1,freq_response_d1] = illuminance_light1(irradiance,incidence,LED_VA,PD_FOV,t,angle1,delay1);
[HLOS2,Zprx2,Xa2,Ya2,Za2,impulse_response_t2,freq_response_f2,impulse_response_diff2,freq_response_d2] = illuminance_light2(irradiance,incidence,LED_VA,PD_FOV,t,angle2,delay2);
[HLOS3,Zprx3,Xa3,Ya3,Za3,impulse_response_t3,freq_response_f3,impulse_response_diff3,freq_response_d3] = illuminance_light3(irradiance,incidence,LED_VA,PD_FOV,t,angle3,delay3);
[HLOS4,Zprx4,Xa4,Ya4,Za4,impulse_response_t4,freq_response_f4,impulse_response_diff4,freq_response_d4] = illuminance_light4(irradiance,incidence,LED_VA,PD_FOV,t,angle4,delay4);

Htotal = 0.0;
HLOS_1 = 0.0;
HLOS_2 = 0.0;
HLOS_3 = 0.0;
HLOS_4 = 0.0;

% if (incidence>=0) && (incidence<=psi_c) && (irradiance<=LED_VA) 
%     HLOS_1 = HLOS1;  
%     HLOS_2 = HLOS2;  
%     HLOS_3 = HLOS3;  
%     HLOS_4 = HLOS4;  
% elseif (incidence>psi_c)
%     HLOS_1 = 0.0;
%     HLOS_2 = 0.0;  
%     HLOS_3 = 0.0;  
%     HLOS_4 = 0.0;  
% elseif (irradiance>LED_VA)
%     HLOS_1 = 0.0;
%     HLOS_2 = 0.0;  
%     HLOS_3 = 0.0;  
%     HLOS_4 = 0.0;   
% elseif (incidence>PD_FOV)||(irradiance>PD_FOV)
%     HLOS_1 = 0.0;
%     HLOS_2 = 0.0;  
%     HLOS_3 = 0.0;  
%     HLOS_4 = 0.0;  
% end;
if angle1>psi_c || angle1>LED_VA
    HLOS1=0.0;
end;
if angle2>psi_c || angle2>LED_VA
    HLOS2=0.0;
end;
if angle3>psi_c || angle3>LED_VA
    HLOS3=0.0;
end;
if angle4>psi_c || angle4>LED_VA
    HLOS4=0.0;
end;

% if angle1<=sliderValue || angle2<=sliderValue || angle3<=sliderValue ||...
%         angle4<=sliderValue
    HLOS_1 = HLOS1;
    HLOS_2 = HLOS2;
    HLOS_3 = HLOS3;
    HLOS_4 = HLOS4;
    HTotal = HLOS_1+HLOS_2+HLOS_3+HLOS_4;
% else
%     HTotal = 0.0;
% end

[zprx,Xa,Ya,Za,impulse_response,freq_response,impulse_response_diff,freq_response_d] = illuminance_lightTotal(irradiance,incidence,LED_VA,PD_FOV,t,HTotal);
%Total received power

mesh(handles.axes2,Xa1,Ya1,Zprx1,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold on
mesh(handles.axes2,Xa2,Ya2-dist_apart_y,Zprx2,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold on
mesh(handles.axes2,Xa3+dist_apart_x,Ya3,Zprx3,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold on
mesh(handles.axes2,Xa4+dist_apart_x,Ya4-dist_apart_y,Zprx4,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold off
%Total SNR

mesh(handles.axes6,Xa,Ya,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold on
mesh(handles.axes6,Xa,Ya-dist_apart_y,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold on
mesh(handles.axes6,Xa+dist_apart_x,Ya,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold on
mesh(handles.axes6,Xa+dist_apart_x,Ya-dist_apart_y,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold off

%Impulse response light 1 (LOS)

plot(handles.axes3,t,impulse_response_t1,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 1 (diffused)

plot(handles.axes3,t,impulse_response_diff1,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 2 (LOS)

plot(handles.axes3,t,impulse_response_t2,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 2 (diffused)

plot(handles.axes3,t,impulse_response_diff2,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on


%Impulse response light 3 (LOS)

plot(handles.axes3,t,impulse_response_t3,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 3 (diffused)

plot(handles.axes3,t,impulse_response_diff3,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on


%Impulse response light 4 (LOS)

plot(handles.axes3,t,impulse_response_t4,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 4 (diffused)

plot(handles.axes3,t,impulse_response_diff4,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold off






%Frequency response light 1 (LOS)

plot(handles.axes4,1./t,freq_response_f1,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 1 (diffused)

plot(handles.axes4,1./t,real(freq_response_d1),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on


%Frequency response light 2 (LOS)

plot(handles.axes4,1./t,freq_response_f2,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 3 (diffused)

plot(handles.axes4,1./t,real(freq_response_d2),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on


%Frequency response light 3 (LOS)

plot(handles.axes4,1./t,freq_response_f3,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 3 (diffused)

plot(handles.axes4,1./t,real(freq_response_d3),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on


%Frequency response light 4 (LOS)

plot(handles.axes4,1./t,freq_response_f4,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 4 (diffused)

plot(handles.axes4,1./t,real(freq_response_d4),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold off







x = [-3/3*0.2 -2/3*0.2 -1/3*0.2 -0.2*0.2 0 0.2*0.2 0.2*1/3 0.2*2/3 0.2*3/3];
y = [4.96 9.9 16.3 21.3 24.4 21.3 16.3 9.9 4.96];
y = (y/0.55)*(10^-6);
p = polyfit(x,y,3);

x2 = -.2:.01:.2;
y2 = polyval(p,x2);
%plot(handles.axes5,x,y,'o',x2,y2)
plot(handles.axes5,x,20*log10(y),'o',x2,20*log10(y2))
axes(handles.axes5)
ylabel(handles.axes5,texlabel('Received Power [20*log_{10}]'))
xlabel(handles.axes5,'Surface length [m]')
title('Measured Total Received Power [dB] at phi=7.5 deg')
h = legend('Actual Data','Polynomial Curve Fit',4);
set(h,'Interpreter','none')

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'value',2);
set(hObject,'max',30);
set(hObject,'min',2);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
%get the string for the editText component
sliderValue = get(handles.edit1,'String');

%convert from string to number if possible, otherwise returns empty
sliderValue = str2double(sliderValue);

%if user inputs something is not a number, or if the input is less than 0
%or greater than 100, then the slider value defaults to 0
if (isempty(sliderValue) || sliderValue < 0 || sliderValue > 100)
    set(handles.slider1,'Value',2);
    set(handles.edit1,'String','2');
else
    set(handles.slider1,'Value',sliderValue);
end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string',2);


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sliderValueX
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValueX = get(handles.slider3,'Value');


global sliderValueY sliderValue
sliderValueY = get(handles.slider4,'Value');
Xpoint = sliderValueX;
Ypoint = sliderValueY;

sliderValue = get(handles.slider1,'Value');
hd = 1.5;
%puts the slider value into the edit text component
set(handles.edit1,'String', num2str(sliderValue));
set(handles.edit4,'String', num2str(sliderValueX));
set(handles.edit5,'String', num2str(sliderValueY));
%%%%%%%%%%%CIRCLE%%%%%%%%%%
p = 0; %(centre the circle 0,0)
%RADIUS = r;
RADIUS = tand(sliderValue)*1.5; %1.5 is the height between TX & RX



%axes1 plot
%%%%%%%Build a circle%%%%%%%
dist_apart_x = 0.5;
dist_apart_y = 0.5;
%Light 1

[X1,Y1]=circle([p,p],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

%Light 2

[X1,Y1]=circle([p+dist_apart_x,p],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

%Light 3

[X1,Y1]=circle([p,p-dist_apart_y],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p-dist_apart_y],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p-dist_apart_y],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p-dist_apart_y],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

%Light 4

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold off

%RECEIVER LOCATION-----------------------
%Xpoint = -0.4;
%Ypoint = 0.2;


%--------------------------------


light1_x = abs(Xpoint-p);
light1_y = abs(Ypoint-p);

if light1_x == 0
    light1_hypotenuse = sqrt(light1_y.^2+hd.^2);
    angle1 = acosd(hd./light1_hypotenuse);
    delay1 = light1_hypotenuse./3E8;
elseif light1_y == 0
    light1_hypotenuse = sqrt(light1_x.^2+hd.^2);
    angle1 = acosd(hd./light1_hypotenuse);
    delay1 = light1_hypotenuse./3E8;
else
    flat1_hypotenuse = sqrt(light1_x.^2+light1_y.^2);
    light1_hypotenuse = sqrt(flat1_hypotenuse.^2+hd.^2);
    angle1 = acosd(hd./light1_hypotenuse);
    delay1 = light1_hypotenuse./3E8;
end
    

light2_x = abs(Xpoint-dist_apart_x);
light2_y = abs(Ypoint-p);

if light2_x == 0
    light2_hypotenuse = sqrt(light2_y.^2+hd.^2);
    angle2 = acosd(hd/light2_hypotenuse);
    delay2 = light2_hypotenuse/3E8;
elseif light2_y == 0
    light2_hypotenuse = sqrt(light2_x.^2+hd.^2);
    angle2 = acosd(hd/light2_hypotenuse);
    delay2 = light2_hypotenuse/3E8;
else
    flat2_hypotenuse = sqrt(light2_x.^2+light2_y.^2);
    light2_hypotenuse = sqrt(flat2_hypotenuse.^2+hd.^2);
    angle2 = acosd(hd./light2_hypotenuse);
    delay2 = light2_hypotenuse./3E8;
end


light3_x = abs(Xpoint-p);
light3_y = abs(Ypoint-dist_apart_y);

if light3_x == 0
    light3_hypotenuse = sqrt(light3_y.^2+hd.^2);
    angle3 = acosd(hd./light3_hypotenuse);
    delay3 = light3_hypotenuse./3E8;
elseif light3_y == 0
    light3_hypotenuse = sqrt(light3_x.^2+hd.^2);
    angle3 = acosd(hd./light3_hypotenuse);
    delay3 = light3_hypotenuse./3E8;
else
    flat3_hypotenuse = sqrt(light3_x.^2+light3_y.^2);
    light3_hypotenuse = sqrt(flat3_hypotenuse.^2+hd.^2);
    angle3 = acosd(hd./light3_hypotenuse);
    delay3 = light3_hypotenuse./3E8;
end


light4_x = abs(Xpoint-dist_apart_x)
light4_y = abs(Ypoint-dist_apart_y)

if light4_x == 0
    light4_hypotenuse = sqrt(light4_y.^2+hd.^2);
    angle4 = acosd(hd./light4_hypotenuse);
    delay4 = light4_hypotenuse./3E8;
elseif light4_y == 0
    light4_hypotenuse = sqrt(light4_x.^2+hd.^2);
    angle4 = acosd(hd./light4_hypotenuse);
    delay4 = light4_hypotenuse./3E8;
else
    flat4_hypotenuse = sqrt(light4_x.^2+light4_y.^2);
    light4_hypotenuse = sqrt(flat4_hypotenuse.^2+hd.^2);
    angle4 = acosd(hd./light4_hypotenuse);
    delay4 = light4_hypotenuse./3E8;
end

% if angle1<2||angle2<2||angle3<2||angle4<2
%     angle1=2;
%     angle2=2;
%     angle3=2;
%     angle4=2;
% end;
%guidata(hObject, handles);
%axes2 plot
c = 300E6; %speed of light
t = 0:0.01:4; %time

%angle of irradiance = angle of incidence 
%(refer to the diagram in "Improvement of Data Rate by using Equalization in an 
%Indoor visible Light Communication System" by L. Zeng et al.)
irradiance = sliderValue;
incidence = sliderValue;
% LED viewing angle LED_VA = (VA/2)
LED_VA = 15; 
% Field of view of PIN photodiode PD_FOV = (FOV/2)
PD_FOV = 20; 
psi_c = PD_FOV;
%
[HLOS1,Zprx1,Xa1,Ya1,Za1,impulse_response_t1,freq_response_f1,impulse_response_diff1,freq_response_d1] = illuminance_light1(irradiance,incidence,LED_VA,PD_FOV,t,angle1,delay1);
[HLOS2,Zprx2,Xa2,Ya2,Za2,impulse_response_t2,freq_response_f2,impulse_response_diff2,freq_response_d2] = illuminance_light2(irradiance,incidence,LED_VA,PD_FOV,t,angle2,delay2);
[HLOS3,Zprx3,Xa3,Ya3,Za3,impulse_response_t3,freq_response_f3,impulse_response_diff3,freq_response_d3] = illuminance_light3(irradiance,incidence,LED_VA,PD_FOV,t,angle3,delay3);
[HLOS4,Zprx4,Xa4,Ya4,Za4,impulse_response_t4,freq_response_f4,impulse_response_diff4,freq_response_d4] = illuminance_light4(irradiance,incidence,LED_VA,PD_FOV,t,angle4,delay4);

Htotal = 0.0;
HLOS_1 = 0.0;
HLOS_2 = 0.0;
HLOS_3 = 0.0;
HLOS_4 = 0.0;

% if (incidence>=0) && (incidence<=psi_c) && (irradiance<=LED_VA) 
%     HLOS_1 = HLOS1;  
%     HLOS_2 = HLOS2;  
%     HLOS_3 = HLOS3;  
%     HLOS_4 = HLOS4;  
% elseif (incidence>psi_c)
%     HLOS_1 = 0.0;
%     HLOS_2 = 0.0;  
%     HLOS_3 = 0.0;  
%     HLOS_4 = 0.0;  
% elseif (irradiance>LED_VA)
%     HLOS_1 = 0.0;
%     HLOS_2 = 0.0;  
%     HLOS_3 = 0.0;  
%     HLOS_4 = 0.0;   
% elseif (incidence>PD_FOV)||(irradiance>PD_FOV)
%     HLOS_1 = 0.0;
%     HLOS_2 = 0.0;  
%     HLOS_3 = 0.0;  
%     HLOS_4 = 0.0;  
% end;
if angle1>psi_c || angle1>LED_VA
    HLOS1=0.0;
end;
if angle2>psi_c || angle2>LED_VA
    HLOS2=0.0;
end;
if angle3>psi_c || angle3>LED_VA
    HLOS3=0.0;
end;
if angle4>psi_c || angle4>LED_VA
    HLOS4=0.0;
end;

% if angle1<=sliderValue || angle2<=sliderValue || angle3<=sliderValue ||...
%         angle4<=sliderValue
    HLOS_1 = HLOS1;
    HLOS_2 = HLOS2;
    HLOS_3 = HLOS3;
    HLOS_4 = HLOS4;
    HTotal = HLOS_1+HLOS_2+HLOS_3+HLOS_4;
% else
%     HTotal = 0.0;
% end

[zprx,Xa,Ya,Za,impulse_response,freq_response,impulse_response_diff,freq_response_d] = illuminance_lightTotal(irradiance,incidence,LED_VA,PD_FOV,t,HTotal);
%Total received power

mesh(handles.axes2,Xa1,Ya1,Zprx1,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold on
mesh(handles.axes2,Xa2,Ya2-dist_apart_y,Zprx2,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold on
mesh(handles.axes2,Xa3+dist_apart_x,Ya3,Zprx3,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold on
mesh(handles.axes2,Xa4+dist_apart_x,Ya4-dist_apart_y,Zprx4,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold off
%Total SNR

mesh(handles.axes6,Xa,Ya,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold on
mesh(handles.axes6,Xa,Ya-dist_apart_y,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold on
mesh(handles.axes6,Xa+dist_apart_x,Ya,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold on
mesh(handles.axes6,Xa+dist_apart_x,Ya-dist_apart_y,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold off

%Impulse response light 1 (LOS)

plot(handles.axes3,t,impulse_response_t1,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 1 (diffused)

plot(handles.axes3,t,impulse_response_diff1,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 2 (LOS)

plot(handles.axes3,t,impulse_response_t2,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 2 (diffused)

plot(handles.axes3,t,impulse_response_diff2,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on


%Impulse response light 3 (LOS)

plot(handles.axes3,t,impulse_response_t3,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 3 (diffused)

plot(handles.axes3,t,impulse_response_diff3,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on


%Impulse response light 4 (LOS)

plot(handles.axes3,t,impulse_response_t4,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 4 (diffused)

plot(handles.axes3,t,impulse_response_diff4,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold off






%Frequency response light 1 (LOS)

plot(handles.axes4,1./t,freq_response_f1,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 1 (diffused)

plot(handles.axes4,1./t,real(freq_response_d1),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on


%Frequency response light 2 (LOS)

plot(handles.axes4,1./t,freq_response_f2,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 3 (diffused)

plot(handles.axes4,1./t,real(freq_response_d2),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on


%Frequency response light 3 (LOS)

plot(handles.axes4,1./t,freq_response_f3,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 3 (diffused)

plot(handles.axes4,1./t,real(freq_response_d3),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on


%Frequency response light 4 (LOS)

plot(handles.axes4,1./t,freq_response_f4,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 4 (diffused)

plot(handles.axes4,1./t,real(freq_response_d4),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold off







x = [-3/3*0.2 -2/3*0.2 -1/3*0.2 -0.2*0.2 0 0.2*0.2 0.2*1/3 0.2*2/3 0.2*3/3];
y = [4.96 9.9 16.3 21.3 24.4 21.3 16.3 9.9 4.96];
y = (y/0.55)*(10^-6);
p = polyfit(x,y,3);

x2 = -.2:.01:.2;
y2 = polyval(p,x2);
%plot(handles.axes5,x,y,'o',x2,y2)
plot(handles.axes5,x,20*log10(y),'o',x2,20*log10(y2))
axes(handles.axes5)
ylabel(handles.axes5,texlabel('Received Power [20*log_{10}]'))
xlabel(handles.axes5,'Surface length [m]')
title('Measured Total Received Power [dB] at phi=7.5 deg')
h = legend('Actual Data','Polynomial Curve Fit',4);
set(h,'Interpreter','none')

guidata(hObject, handles);

%puts the slider value into the edit text component
%set(handles.edit1,'String', num2str(sliderValueX));


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'value',0.1);
set(hObject,'max',1);
set(hObject,'min',-0.4);


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sliderValueY
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValueY = get(handles.slider4,'Value');


global sliderValueX sliderValue
sliderValueX = get(handles.slider3,'Value');
Xpoint = sliderValueX;
Ypoint = sliderValueY;

sliderValue = get(handles.slider1,'Value');
hd = 1.5;
%puts the slider value into the edit text component

set(handles.edit1,'String', num2str(sliderValue));
set(handles.edit4,'String', num2str(sliderValueX));
set(handles.edit5,'String', num2str(sliderValueY));
%%%%%%%%%%%CIRCLE%%%%%%%%%%
p = 0; %(centre the circle 0,0)
%RADIUS = r;
RADIUS = tand(sliderValue)*1.5; %1.5 is the height between TX & RX



%axes1 plot
%%%%%%%Build a circle%%%%%%%
dist_apart_x = 0.5;
dist_apart_y = 0.5;
%Light 1

[X1,Y1]=circle([p,p],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

%Light 2

[X1,Y1]=circle([p+dist_apart_x,p],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

%Light 3

[X1,Y1]=circle([p,p-dist_apart_y],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p-dist_apart_y],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p-dist_apart_y],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p,p-dist_apart_y],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

%Light 4

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],RADIUS,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],(2/3)*RADIUS,100);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],(1/3)*RADIUS,60);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([p+dist_apart_x,p-dist_apart_y],(0.2/3)*RADIUS,30);
plot(handles.axes1,X1,Y1,'.')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold off

%RECEIVER LOCATION-----------------------
%Xpoint = -0.4;
%Ypoint = 0.2;


%--------------------------------


light1_x = abs(Xpoint-p);
light1_y = abs(Ypoint-p);

if light1_x == 0
    light1_hypotenuse = sqrt(light1_y.^2+hd.^2);
    angle1 = acosd(hd./light1_hypotenuse);
    delay1 = light1_hypotenuse./3E8;
elseif light1_y == 0
    light1_hypotenuse = sqrt(light1_x.^2+hd.^2);
    angle1 = acosd(hd./light1_hypotenuse);
    delay1 = light1_hypotenuse./3E8;
else
    flat1_hypotenuse = sqrt(light1_x.^2+light1_y.^2);
    light1_hypotenuse = sqrt(flat1_hypotenuse.^2+hd.^2);
    angle1 = acosd(hd./light1_hypotenuse);
    delay1 = light1_hypotenuse./3E8;
end
    

light2_x = abs(Xpoint-dist_apart_x);
light2_y = abs(Ypoint-p);

if light2_x == 0
    light2_hypotenuse = sqrt(light2_y.^2+hd.^2);
    angle2 = acosd(hd/light2_hypotenuse);
    delay2 = light2_hypotenuse/3E8;
elseif light2_y == 0
    light2_hypotenuse = sqrt(light2_x.^2+hd.^2);
    angle2 = acosd(hd/light2_hypotenuse);
    delay2 = light2_hypotenuse/3E8;
else
    flat2_hypotenuse = sqrt(light2_x.^2+light2_y.^2);
    light2_hypotenuse = sqrt(flat2_hypotenuse.^2+hd.^2);
    angle2 = acosd(hd./light2_hypotenuse);
    delay2 = light2_hypotenuse./3E8;
end


light3_x = abs(Xpoint-p);
light3_y = abs(Ypoint+dist_apart_y);

if light3_x == 0
    light3_hypotenuse = sqrt(light3_y.^2+hd.^2);
    angle3 = acosd(hd./light3_hypotenuse);
    delay3 = light3_hypotenuse./3E8;
elseif light3_y == 0
    light3_hypotenuse = sqrt(light3_x.^2+hd.^2);
    angle3 = acosd(hd./light3_hypotenuse);
    delay3 = light3_hypotenuse./3E8;
else
    flat3_hypotenuse = sqrt(light3_x.^2+light3_y.^2);
    light3_hypotenuse = sqrt(flat3_hypotenuse.^2+hd.^2);
    angle3 = acosd(hd./light3_hypotenuse);
    delay3 = light3_hypotenuse./3E8;
end


light4_x = abs(Xpoint-dist_apart_x)
light4_y = abs(Ypoint+dist_apart_y)


if light4_x == 0
    light4_hypotenuse = sqrt(light4_y.^2+hd.^2);
    angle4 = acosd(hd./light4_hypotenuse);
    delay4 = light4_hypotenuse./3E8;
elseif light4_y == 0
    light4_hypotenuse = sqrt(light4_x.^2+hd.^2);
    angle4 = acosd(hd./light4_hypotenuse);
    delay4 = light4_hypotenuse./3E8;
else
    flat4_hypotenuse = sqrt(light4_x.^2+light4_y.^2);
    light4_hypotenuse = sqrt(flat4_hypotenuse.^2+hd.^2);
    angle4 = acosd(hd./light4_hypotenuse);
    delay4 = light4_hypotenuse./3E8;
end


% if angle1<2||angle2<2||angle3<2||angle4<2
%     angle1=2;
%     angle2=2;
%     angle3=2;
%     angle4=2;
% end;
%guidata(hObject, handles);
%axes2 plot
c = 300E6; %speed of light
t = 0:0.01:4; %time

%angle of irradiance = angle of incidence 
%(refer to the diagram in "Improvement of Data Rate by using Equalization in an 
%Indoor visible Light Communication System" by L. Zeng et al.)
irradiance = sliderValue;
incidence = sliderValue;
% LED viewing angle LED_VA = (VA/2)
LED_VA = 15; 
% Field of view of PIN photodiode PD_FOV = (FOV/2)
PD_FOV = 20; 
psi_c = PD_FOV;
%
[HLOS1,Zprx1,Xa1,Ya1,Za1,impulse_response_t1,freq_response_f1,impulse_response_diff1,freq_response_d1] = illuminance_light1(irradiance,incidence,LED_VA,PD_FOV,t,angle1,delay1);
[HLOS2,Zprx2,Xa2,Ya2,Za2,impulse_response_t2,freq_response_f2,impulse_response_diff2,freq_response_d2] = illuminance_light2(irradiance,incidence,LED_VA,PD_FOV,t,angle2,delay2);
[HLOS3,Zprx3,Xa3,Ya3,Za3,impulse_response_t3,freq_response_f3,impulse_response_diff3,freq_response_d3] = illuminance_light3(irradiance,incidence,LED_VA,PD_FOV,t,angle3,delay3);
[HLOS4,Zprx4,Xa4,Ya4,Za4,impulse_response_t4,freq_response_f4,impulse_response_diff4,freq_response_d4] = illuminance_light4(irradiance,incidence,LED_VA,PD_FOV,t,angle4,delay4);

Htotal = 0.0;
HLOS_1 = 0.0;
HLOS_2 = 0.0;
HLOS_3 = 0.0;
HLOS_4 = 0.0;

% if (incidence>=0) && (incidence<=psi_c) && (irradiance<=LED_VA) 
%     HLOS_1 = HLOS1;  
%     HLOS_2 = HLOS2;  
%     HLOS_3 = HLOS3;  
%     HLOS_4 = HLOS4;  
% elseif (incidence>psi_c)
%     HLOS_1 = 0.0;
%     HLOS_2 = 0.0;  
%     HLOS_3 = 0.0;  
%     HLOS_4 = 0.0;  
% elseif (irradiance>LED_VA)
%     HLOS_1 = 0.0;
%     HLOS_2 = 0.0;  
%     HLOS_3 = 0.0;  
%     HLOS_4 = 0.0;   
% elseif (incidence>PD_FOV)||(irradiance>PD_FOV)
%     HLOS_1 = 0.0;
%     HLOS_2 = 0.0;  
%     HLOS_3 = 0.0;  
%     HLOS_4 = 0.0;  
% end;
if angle1>psi_c || angle1>LED_VA
    HLOS1=0.0;
end;
if angle2>psi_c || angle2>LED_VA
    HLOS2=0.0;
end;
if angle3>psi_c || angle3>LED_VA
    HLOS3=0.0;
end;
if angle4>psi_c || angle4>LED_VA
    HLOS4=0.0;
end;

% if angle1<=sliderValue || angle2<=sliderValue || angle3<=sliderValue ||...
%         angle4<=sliderValue
    HLOS_1 = HLOS1;
    HLOS_2 = HLOS2;
    HLOS_3 = HLOS3;
    HLOS_4 = HLOS4;
    HTotal = HLOS_1+HLOS_2+HLOS_3+HLOS_4;
% else
%     HTotal = 0.0;
% end

[zprx,Xa,Ya,Za,impulse_response,freq_response,impulse_response_diff,freq_response_d] = illuminance_lightTotal(irradiance,incidence,LED_VA,PD_FOV,t,HTotal);
%Total received power

mesh(handles.axes2,Xa1,Ya1,Zprx1,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold on
mesh(handles.axes2,Xa2,Ya2-dist_apart_y,Zprx2,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold on
mesh(handles.axes2,Xa3+dist_apart_x,Ya3,Zprx3,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold on
mesh(handles.axes2,Xa4+dist_apart_x,Ya4-dist_apart_y,Zprx4,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')
hold off
%Total SNR

mesh(handles.axes6,Xa,Ya,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold on
mesh(handles.axes6,Xa,Ya-dist_apart_y,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold on
mesh(handles.axes6,Xa+dist_apart_x,Ya,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold on
mesh(handles.axes6,Xa+dist_apart_x,Ya-dist_apart_y,Za,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')
hold off

%Impulse response light 1 (LOS)

plot(handles.axes3,t,impulse_response_t1,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 1 (diffused)

plot(handles.axes3,t,impulse_response_diff1,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 2 (LOS)

plot(handles.axes3,t,impulse_response_t2,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 2 (diffused)

plot(handles.axes3,t,impulse_response_diff2,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on


%Impulse response light 3 (LOS)

plot(handles.axes3,t,impulse_response_t3,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 3 (diffused)

plot(handles.axes3,t,impulse_response_diff3,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on


%Impulse response light 4 (LOS)

plot(handles.axes3,t,impulse_response_t4,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on

%Impulse response light 4 (diffused)

plot(handles.axes3,t,impulse_response_diff4,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold off






%Frequency response light 1 (LOS)

plot(handles.axes4,1./t,freq_response_f1,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 1 (diffused)

plot(handles.axes4,1./t,real(freq_response_d1),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on


%Frequency response light 2 (LOS)

plot(handles.axes4,1./t,freq_response_f2,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 3 (diffused)

plot(handles.axes4,1./t,real(freq_response_d2),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on


%Frequency response light 3 (LOS)

plot(handles.axes4,1./t,freq_response_f3,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 3 (diffused)

plot(handles.axes4,1./t,real(freq_response_d3),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on


%Frequency response light 4 (LOS)

plot(handles.axes4,1./t,freq_response_f4,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on

%Frequency response light 4 (diffused)

plot(handles.axes4,1./t,real(freq_response_d4),'-.b')
axes(handles.axes4)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]'))
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold off







x = [-3/3*0.2 -2/3*0.2 -1/3*0.2 -0.2*0.2 0 0.2*0.2 0.2*1/3 0.2*2/3 0.2*3/3];
y = [4.96 9.9 16.3 21.3 24.4 21.3 16.3 9.9 4.96];
y = (y/0.55)*(10^-6);
p = polyfit(x,y,3);

x2 = -.2:.01:.2;
y2 = polyval(p,x2);
%plot(handles.axes5,x,y,'o',x2,y2)
plot(handles.axes5,x,20*log10(y),'o',x2,20*log10(y2))
axes(handles.axes5)
ylabel(handles.axes5,texlabel('Received Power [20*log_{10}]'))
xlabel(handles.axes5,'Surface length [m]')
title('Measured Total Received Power [dB] at phi=7.5 deg')
h = legend('Actual Data','Polynomial Curve Fit',4);
set(h,'Interpreter','none')

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'value',0.1);
set(hObject,'max',0.4);
set(hObject,'min',-1);



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
sliderValue = get(handles.edit4,'String');

%convert from string to number if possible, otherwise returns empty
sliderValue = str2double(sliderValue);

%if user inputs something is not a number, or if the input is less than 0
%or greater than 100, then the slider value defaults to 0
if (isempty(sliderValue) || sliderValue < -0.4 || sliderValue > 1)
    set(handles.slider3,'Value',.02);
    set(handles.edit4,'String','.02');
else
    set(handles.slider3,'Value',sliderValue);
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string',.02);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
sliderValue = get(handles.edit5,'String');

%convert from string to number if possible, otherwise returns empty
sliderValue = str2double(sliderValue);

%if user inputs something is not a number, or if the input is less than 0
%or greater than 100, then the slider value defaults to 0
if (isempty(sliderValue) || sliderValue < -1 || sliderValue > 0.4)
    set(handles.slider4,'Value',.02);
    set(handles.edit5,'String','.02');
else
    set(handles.slider4,'Value',sliderValue);
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string',.02);
