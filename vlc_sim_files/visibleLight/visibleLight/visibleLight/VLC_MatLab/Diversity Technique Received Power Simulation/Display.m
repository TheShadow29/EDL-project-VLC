%coded by Xiao Long (University of Cambridge) and LC Png (Nanyang Technological University)
function varargout = Display(varargin)
% DISPLAY M-file for Display.fig
%      DISPLAY, by itself, creates a new DISPLAY or raises the existing
%      singleton*.
%
%      H = DISPLAY returns the handle to a new DISPLAY or the handle to
%      the existing singleton*.
%
%      DISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAY.M with the given input arguments.
%
%      DISPLAY('Property','Value',...) creates a new DISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Display_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Display_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Display

% Last Modified by GUIDE v2.5 17-Mar-2012 11:12:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Display_OpeningFcn, ...
                   'gui_OutputFcn',  @Display_OutputFcn, ...
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before Display is made visible.
function Display_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Display (see VARARGIN)

% Choose default command line output for Display
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Display wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Display_OutputFcn(hObject, eventdata, handles) 
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

global space
global phi

%phi = get(handles.slider2,'Value');
space = get(handles.slider1,'Value');
%space = sliderValue
%-------------------------------------------------------

%---------------------ENTER PARAMETERS------------------------%
% Distance between tx and rx ( Meter )
heightLED = 1.48;
% Transmitter Semi-angle, angle of irradiance in half (Radian)
%phi = (7.5*pi)/180;

% Speed of Light
c = 300E6; 
% Time
t = 0:0.01:4;
%---------------------END OF PARAMETERS-----------------------%

% 3D Meshgrid X-axis and Y-axis %
radius = heightLED * tan(phi);
[X,Y] = meshgrid(-4:0.2:4); 

xydist = sqrt((X+space).^2 + (Y+space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2);
% Incidence angles of receiver according to X-Y axis % 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location %
 % Received Power in mW at each X-Y location %
P1=P;

xydist = sqrt((X+space).^2 + (Y-space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P2=P;

xydist = sqrt((X-space).^2 + (Y+space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P3=P; 

xydist = sqrt((X-space).^2 + (Y-space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P4=P;

P=P1+P2+P3+P4;


%%%%%%%%%%%%%%%%%%%%%Plot Circle%%%%%%%%%%%%%%%%%%%%%%%%%%%
[X1,Y1]=circle([space/2,space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([space/2,-space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
hold on

[X1,Y1]=circle([-space/2,space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
hold on

[X1,Y1]=circle([-space/2,-space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
hold off
%%%%%%%%%%%%%%%%%%%%%End Circle%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%3D diagram for Received Power WITH LENS%%%%%%%%%%%%%%%%%

mesh(handles.axes2,X,Y,P,'EdgeColor','black')
xlabel(handles.axes2,'Length of room [m]')
ylabel(handles.axes2,'Width of room [m]')
zlabel(handles.axes2,'Received Power in (W)')

title(handles.axes2,'3D Plot for Room Receivered Power Distribution with Lens')
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
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
set(hObject,'value',1.5);
set(hObject,'max',3);
set(hObject,'min',0);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global phi
global space

phi = get(handles.slider2,'Value');
%space = get(handles.slider1,'Value');

%-------------------------------------------------------

%---------------------ENTER PARAMETERS------------------------%
% Distance between tx and rx ( Meter )
heightLED = 1.48;
% Transmitter Semi-angle, angle of irradiance in half (Radian)
%phi = (7.5*pi)/180;

% Speed of Light
c = 300E6; 
% Time
t = 0:0.01:4;
%---------------------END OF PARAMETERS-----------------------%

% 3D Meshgrid X-axis and Y-axis %
radius = heightLED * tan(phi);
[X,Y] = meshgrid(-4:0.2:4); 

xydist = sqrt((X+space).^2 + (Y+space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2);
% Incidence angles of receiver according to X-Y axis % 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location %
 % Received Power in mW at each X-Y location %
P1=P;

xydist = sqrt((X+space).^2 + (Y-space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P2=P;

xydist = sqrt((X-space).^2 + (Y+space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P3=P; 

xydist = sqrt((X-space).^2 + (Y-space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P4=P;

P=P1+P2+P3+P4;


%%%%%%%%%%%%%%%%%%%%%Plot Circle%%%%%%%%%%%%%%%%%%%%%%%%%%%
[X1,Y1]=circle([space/2,space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([space/2,-space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
hold on

[X1,Y1]=circle([-space/2,space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
hold on

[X1,Y1]=circle([-space/2,-space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axes(handles.axes1)
hold off
%%%%%%%%%%%%%%%%%%%%%End Circle%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%3D diagram for Received Power WITH LENS%%%%%%%%%%%%%%%%%

mesh(handles.axes2,X,Y,P,'EdgeColor','black')
xlabel(handles.axes2,'Length of room [m]')
ylabel(handles.axes2,'Width of room [m]')
zlabel(handles.axes2,'Received Power in (W)')

title(handles.axes2,'3D Plot for Room Receivered Power Distribution with Lens')
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'value',15);
set(hObject,'max',40);
set(hObject,'min',2);
