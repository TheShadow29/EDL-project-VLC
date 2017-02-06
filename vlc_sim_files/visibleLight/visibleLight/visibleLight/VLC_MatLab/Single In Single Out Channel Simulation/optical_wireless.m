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

% Last Modified by GUIDE v2.5 12-Sep-2011 17:00:10

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
sliderValue = get(handles.slider1,'Value');

%puts the slider value into the edit text component
set(handles.edit1,'String', num2str(sliderValue));
%%%%%%%%%%%CIRCLE%%%%%%%%%%
p = 0; %(centre the circle 0,0)
%RADIUS = r;
RADIUS = tand(sliderValue)*1.5; %1.5 is the height between TX & RX


%axes1 plot
%%%%%%%Build a circle%%%%%%%

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
hold off

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
%

[zprx,Xa,Ya,Za,impulset,impulsef,impulsed,diffusedfreqres] = illuminance(irradiance,incidence,LED_VA,PD_FOV,t);
mesh(handles.axes2,Xa,Ya,Za,'EdgeColor','black')
axes(handles.axes2)
xlabel(handles.axes2,'Length of surface [m]')
ylabel(handles.axes2,'Width of surface [m]')
zlabel(handles.axes2,texlabel('Received Power [20*log_{10}]'))
title('Total Received Power [dB]')

[zprx,Xa,Ya,Za,impulset,impulsef,impulsed,diffusedfreqres] = illuminance(irradiance,incidence,LED_VA,PD_FOV,t);
mesh(handles.axes6,Xa,Ya,zprx,'EdgeColor','black')
axes(handles.axes6)
xlabel(handles.axes6,'Length of surface [m]')
ylabel(handles.axes6,'Width of surface [m]')
zlabel(handles.axes6,texlabel('SNR [20*log_{10}]'))
title('SNR Distribution [dB]')

plot(handles.axes3,t,impulset,'black')
axes(handles.axes3)
xlabel(handles.axes3,'Time (ns)')
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold on
plot(handles.axes3,t,impulsed,'-.b')
axes(handles.axes3)
h = legend('LOS','diffused',1);
set(h,'Interpreter','none')
xlabel(handles.axes3,texlabel('Time (10^{-8} s)')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes3,'Output Signal y(t)')
title('y(t)=x(t)*h(t)')
hold off

plot(handles.axes4,1./t,impulsef,'black')
axes(handles.axes4)
xlabel(handles.axes4,texlabel('Frequency (Hz) [10^8]')) %axis according to the speed of light [3E8 m/s]
ylabel(handles.axes4,'Output Signal Y(w)')
title('Y(w)=X(w)H(w)')
hold on
plot(handles.axes4,1./t,real(diffusedfreqres),'-.b')
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
