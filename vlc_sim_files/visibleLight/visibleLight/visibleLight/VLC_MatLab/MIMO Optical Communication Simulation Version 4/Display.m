% Long Xiao (University of Cambridge) and 
% Lih Chieh Png (Nanyang Technological University, Singapore University of Technology and Design)

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

% Last Modified by GUIDE v2.5 18-Oct-2011 18:59:14

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%  s   t   a   r  t   %%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%START%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%______Slider 1______%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global space
global phi
global switch1
global switch2
global switch3
global switch4

phi = get(handles.slider2,'Value');
space = get(handles.slider1,'Value');
set(handles.edit31,'String',space);
phi =(phi/180 * pi);

%---------------------ENTER PARAMETERS------------------------%
% Distance between tx and rx ( Meter )
heightLED = 1.48;

% Speed of Light
c = 300E6; 
% Time
t = 0:0.01:4;
% Radius of light cone
radius = heightLED * tan(phi);
%---------------------END OF PARAMETERS-----------------------%
%%%%%%%%%%%%%%%%%% Meshgrid X-axis and Y-axis %%%%%%%%%%%%%%%
% Incidence angles of receiver according to X-Y axis % 
[X,Y] = meshgrid(-4:0.2:4); 
xydist = sqrt((X-space).^2 + (Y-space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2);
incidence = atand(xydist.* heightLED ^(-1));
%%%%%%%%%%%%%%%%%% End Mesh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Received Power P1 2 3 4 in mW at each X-Y location%%%%%%
%%%%%%%%%%%P1
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location %
P1=P*switch1;
xydist = sqrt((X+space).^2 + (Y+space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
%%%%%%%%%%%P2
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P2=P*switch2;
%%%%%%%%%%%P3
xydist = sqrt((X-space).^2 + (Y+space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P3=P*switch3; 
%%%%%%%%%%%P4
xydist = sqrt((X+space).^2 + (Y-space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P4=P*switch4;
%%%%%%%%%%%P TOTAL
P=P1+P2+P3+P4;
%%%%%%%%%%%%%%%%%%%%%%%END RxSNR Function TOTAL POWER%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%Plot Circle %%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(handles.axes1)
[X1,Y1]=circle([space/2,space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axis([-4 4 -4 4])
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top view of LED light coverage')
hold on

[X1,Y1]=circle([space/2,-space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
hold on

[X1,Y1]=circle([-space/2,space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
hold on

[X1,Y1]=circle([-space/2,-space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
hold off
%%%%%%%%%%%%%%%%%%%%%End Circle%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%Plot 3D diagram for Received Power%%%%%%%%%%%%%%%%%
axes(handles.axes2)
mesh(handles.axes2,X,Y,P,'EdgeColor','black')
axis([-4 4 -4 4 0 1.5e-4])
xlabel(handles.axes2,'Length of room [m]')
ylabel(handles.axes2,'Width of room [m]')
zlabel(handles.axes2,'Received Power in (W)')
hold off
title(handles.axes2,'3D Plot for Room Receivered Power Distribution')
%%%%%%%%%%%%%%%%%%%%%%%%%%%END 3D graph%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END SLIDE 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SLIDE 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%______________%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global phi
global space
global incidence

global switch1
global switch2
global switch3
global switch4

phi = get(handles.slider2,'Value');
space = get(handles.slider1, 'Value');

set(handles.edit,'String', num2str(phi));
phi =(phi/180 * pi);
%-------------------------------------------------------

%---------------------ENTER PARAMETERS------------------------%
% Distance between tx and rx ( Meter )
heightLED = 1.48;

% Speed of Light
c = 300E6; 
% Time
t = 0:0.01:4;
% Radius of light cone
radius = heightLED * tan(phi);
%---------------------END OF PARAMETERS-----------------------%
%%%%%%%%%%%%%%%%%% Meshgrid X-axis and Y-axis %%%%%%%%%%%%%%%
% Incidence angles of receiver according to X-Y axis % 
[X,Y] = meshgrid(-4:0.2:4); 
xydist = sqrt((X-space).^2 + (Y-space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2);
incidence = atand(xydist.* heightLED ^(-1));
%%%%%%%%%%%%%%%%%% End Mesh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%Plot Circle%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(handles.axes1)
[X1,Y1]=circle([space/2,space/2],radius,150);
plot(handles.axes1,X1,Y1,'+')
axis([-4 4 -4 4])
xlabel(handles.axes1,'Length of surface [m]')
ylabel(handles.axes1,'Breadth of surface [m]')
title('Top View of LEDs')
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

%%%%%%%%%%%%%%%% Received Power P1 2 3 4 in mW at each X-Y location%%%%%%
%%%%%%%%%%%P1
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location %
P1=P*switch1;
xydist = sqrt((X+space).^2 + (Y+space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
%%%%%%%%%%%P2
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P2=P*switch2;
%%%%%%%%%%%P3
xydist = sqrt((X-space).^2 + (Y+space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P3=P*switch3; 
%%%%%%%%%%%P4
xydist = sqrt((X+space).^2 + (Y-space).^2);
hdist = sqrt(xydist.^2 + heightLED.^2); 
incidence = atand(xydist.* heightLED ^(-1));
[P, PO, Z, impulset, impulsetd, impulsef, impulsefd]=RxSNR(incidence,hdist,t,phi); % SNR in dB at each X-Y location % 
P4=P*switch4;
%%%%%%%%%%%P TOTAL
P=P1+P2+P3+P4;
%%%%%%%%%%%%%%%%%%%%%%%END RxSNR TOTAL RECEIVED POWER%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%Plot 3D diagram for Received Power%%%%%%%%%%%%%%%%%
axes(handles.axes2)
mesh(handles.axes2,X,Y,P,'EdgeColor','black')
axis([-4 4 -4 4 0 1.5e-4])
xlabel(handles.axes2,'Length of room [m]')
ylabel(handles.axes2,'Width of room [m]')
zlabel(handles.axes2,'Received Power in (W)')
hold off
title(handles.axes2,'3D Plot for Room Receivered Power Distribution')
%%%%%%%%%%%%%%%%%%%%%%%%%%%END 3D graph%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%END SLIDER 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



%%__________________________________________POPUPMENU1_____________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SWITCH 1,2,3,4   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
val = get(hObject, 'Value');
global switch1
switch str{val}
case '0' % User selects peaks.
   switch1 = 0
case '1' % User selects membrane.
   switch1 = 1
end
% Save the handles structure.
guidata(hObject,handles)
% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
val = get(hObject, 'Value');
global switch4
switch str{val}
case '0' % User selects peaks.
   switch4 = 0
case '1' % User selects membrane.
   switch4 = 1
end
% Save the handles structure.
guidata(hObject,handles)
% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
val = get(hObject, 'Value');
global switch3
switch str{val}
case '0' % User selects peaks.
   switch3 = 0
case '1' % User selects membrane.
   switch3 = 1
end
% Save the handles structure.
guidata(hObject,handles)
% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
val = get(hObject, 'Value');
global switch2
switch str{val}
case '0' % User selects peaks.
   switch2 = 0
case '1' % User selects membrane.
   switch2 = 1
end
% Save the handles structure.
guidata(hObject,handles)
% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END SWITCH 1,2,3,4   %%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%edit%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%______________________________ EDIT TEXT__________________________

function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit as text
%        str2double(get(hObject,'String')) returns contents of edit as a double
% --- Executes during object creation, after setting all properties.
function edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%______________________________ END EDIT TEXT__________________________




%%__________________________________________SLIDER3 MOVE Y_____________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Y-AXIS  %%%%%%%%%%%%%%%%%%%%%
% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global xlocation
global ylocation
global R_space %receiver space
global space %light space
global phi
global switch1
global switch2
global switch3
global switch4

global R_space

%R_space = 0.5;
xlocation = get(handles.slider4,'Value');
ylocation = get(handles.slider3,'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%% + plot %%%%%%%%%%%%%%%%%%%%%%%%%
axes(handles.axes1)
plot(handles.axes1,xlocation-R_space,ylocation-R_space,'+')
title('Top View of Detectors')
axis([-4 4 -4 4])
hold on
plot(handles.axes1,xlocation+R_space,ylocation-R_space,'+')
hold on
plot(handles.axes1,xlocation-R_space,ylocation+R_space,'+')
hold on
plot(handles.axes1,xlocation+R_space,ylocation+R_space,'+')
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%% END "+" plot %%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% GAIN VALUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h11=channelgain(xlocation-R_space-space,ylocation+R_space+space,phi,space);
h12=channelgain(xlocation+R_space-space,ylocation+R_space+space,phi,space);
h13=channelgain(xlocation+R_space-space,ylocation-R_space+space,phi,space);
h14=channelgain(xlocation-R_space-space,ylocation-R_space+space,phi,space);

h21=channelgain(xlocation-R_space+space,ylocation+R_space+space,phi,space);
h22=channelgain(xlocation+R_space+space,ylocation+R_space+space,phi,space);
h23=channelgain(xlocation+R_space+space,ylocation-R_space+space,phi,space);
h24=channelgain(xlocation-R_space+space,ylocation-R_space+space,phi,space);

h31=channelgain(xlocation-R_space+space,ylocation+R_space-space,phi,space);
h32=channelgain(xlocation+R_space+space,ylocation+R_space-space,phi,space);
h33=channelgain(xlocation+R_space+space,ylocation-R_space-space,phi,space);
h34=channelgain(xlocation-R_space+space,ylocation-R_space-space,phi,space);

h41=channelgain(xlocation-R_space-space,ylocation+R_space-space,phi,space);
h42=channelgain(xlocation+R_space-space,ylocation+R_space-space,phi,space);
h43=channelgain(xlocation+R_space-space,ylocation-R_space-space,phi,space);
h44=channelgain(xlocation-R_space-space,ylocation-R_space-space,phi,space);
%%%%%%%%%%%%%%%%%%%%%%%%%% END GAIN VALUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h=[h11,h12,h13,h14;h11,h22,h23,h24;h31,h32,h33,h34;h41,h42,h43,h44];

det(h);

set(handles.edit7,'String',h11);
set(handles.edit8,'String',h12);
set(handles.edit9,'String',h13);
set(handles.edit10,'String',h14);

set(handles.edit11,'String',h21);
set(handles.edit12,'String',h22);
set(handles.edit13,'String',h23);
set(handles.edit14,'String',h24);

set(handles.edit15,'String',h31);
set(handles.edit16,'String',h32);
set(handles.edit17,'String',h33);
set(handles.edit18,'String',h34);

set(handles.edit19,'String',h41);
set(handles.edit20,'String',h42);
set(handles.edit21,'String',h43);
set(handles.edit22,'String',h44);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ptx = [switch1*0.1,switch3*0.1,switch4*0.1,switch2*0.1];

Prx = Ptx * h;
set(handles.edit23,'String',Prx(1));
set(handles.edit24,'String',Prx(2));
set(handles.edit25,'String',Prx(3));
set(handles.edit26,'String',Prx(4));


DATArx =int8( Prx * inv(h) *10 );
set(handles.edit27,'String',DATArx(1));
set(handles.edit28,'String',DATArx(2));
set(handles.edit29,'String',DATArx(3));
set(handles.edit30,'String',DATArx(4));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inv(h)
%inv(h)*h

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





%%__________________________________________SLIDER4 MOVE X_____________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   X-AXIS  %%%%%%%%%%%%%%%%%%%%%

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global xlocation
global ylocation
global R_space %receiver space
global space %light space
global phi

global switch1
global switch2
global switch3
global switch4
global R_space


%R_space = 0.5;
xlocation = get(handles.slider4,'Value');
ylocation = get(handles.slider3,'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%% + plot %%%%%%%%%%%%%%%%%%%%%%%%%
axes(handles.axes1)
plot(handles.axes1,xlocation-R_space,ylocation-R_space,'+')
title('Top view of detectors')
axis([-4 4 -4 4])
hold on
plot(handles.axes1,xlocation+R_space,ylocation-R_space,'+')
hold on
plot(handles.axes1,xlocation-R_space,ylocation+R_space,'+')
hold on
plot(handles.axes1,xlocation+R_space,ylocation+R_space,'+')
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%% END "+" plot %%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% GAIN VALUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h11=channelgain(xlocation-R_space-space,ylocation+R_space+space,phi,space);
h12=channelgain(xlocation+R_space-space,ylocation+R_space+space,phi,space);
h13=channelgain(xlocation+R_space-space,ylocation-R_space+space,phi,space);
h14=channelgain(xlocation-R_space-space,ylocation-R_space+space,phi,space);

h21=channelgain(xlocation-R_space+space,ylocation+R_space+space,phi,space);
h22=channelgain(xlocation+R_space+space,ylocation+R_space+space,phi,space);
h23=channelgain(xlocation+R_space+space,ylocation-R_space+space,phi,space);
h24=channelgain(xlocation-R_space+space,ylocation-R_space+space,phi,space);

h31=channelgain(xlocation-R_space+space,ylocation+R_space-space,phi,space);
h32=channelgain(xlocation+R_space+space,ylocation+R_space-space,phi,space);
h33=channelgain(xlocation+R_space+space,ylocation-R_space-space,phi,space);
h34=channelgain(xlocation-R_space+space,ylocation-R_space-space,phi,space);

h41=channelgain(xlocation-R_space-space,ylocation+R_space-space,phi,space);
h42=channelgain(xlocation+R_space-space,ylocation+R_space-space,phi,space);
h43=channelgain(xlocation+R_space-space,ylocation-R_space-space,phi,space);
h44=channelgain(xlocation-R_space-space,ylocation-R_space-space,phi,space);
%%%%%%%%%%%%%%%%%%%%%%%%%% END GAIN VALUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h=[h11,h12,h13,h14;h11,h22,h23,h24;h31,h32,h33,h34;h41,h42,h43,h44;]

det(h)

set(handles.edit7,'String',h11);
set(handles.edit8,'String',h12);
set(handles.edit9,'String',h13);
set(handles.edit10,'String',h14);

set(handles.edit11,'String',h21);
set(handles.edit12,'String',h22);
set(handles.edit13,'String',h23);
set(handles.edit14,'String',h24);

set(handles.edit15,'String',h31);
set(handles.edit16,'String',h32);
set(handles.edit17,'String',h33);
set(handles.edit18,'String',h34);

set(handles.edit19,'String',h41);
set(handles.edit20,'String',h42);
set(handles.edit21,'String',h43);
set(handles.edit22,'String',h44);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ptx = [switch1*0.1,switch3*0.1,switch4*0.1,switch2*0.1];

Prx = Ptx * h
set(handles.edit23,'String',Prx(1));
set(handles.edit24,'String',Prx(2));
set(handles.edit25,'String',Prx(3));
set(handles.edit26,'String',Prx(4));


DATArx =int8( Prx * inv(h) *10 );
set(handles.edit27,'String',DATArx(1));
set(handles.edit28,'String',DATArx(2));
set(handles.edit29,'String',DATArx(3));
set(handles.edit30,'String',DATArx(4));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global R_space
R_space = get(handles.slider6,'Value')
set(handles.edit32,'String',R_space);
R_space = R_space / 2
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


