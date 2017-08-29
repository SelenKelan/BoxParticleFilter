function varargout = simple(varargin)
% SIMPLE MATLAB code for simple.fig
%      SIMPLE, by itself, creates a new SIMPLE or raises the existing
%      singleton*.
%
%      H = SIMPLE returns the handle to a new SIMPLE or the handle to
%      the existing singleton*.
%
%      SIMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLE.M with the given input arguments.
%
%      SIMPLE('Property','Value',...) creates a new SIMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simple_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simple

% Last Modified by GUIDE v2.5 28-Aug-2017 18:11:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simple_OpeningFcn, ...
                   'gui_OutputFcn',  @simple_OutputFcn, ...
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


% --- Executes just before simple is made visible.
function simple_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simple (see VARARGIN)
handles.calc=false;
handles.robotson=false;
handles.wallson=false;
handles.boxeson=false;
handles.landmarkson=false;
handles.chgwalls=false;
handles.slider=0.2;
global rolling;
rolling=false;
NP = 1024;
% environement
envimat=2*ones(sqrt(NP),sqrt(NP));
envimat(:,1:4)=1;
envimat(1:4,:)=1;
envimat(:,end-3:end)=1;
envimat(end-3:end,:)=1;
handles.envimat=envimat;
handles.threshold=0.4;
handles.state=zeros(100,400,3);
handles.state(:,:,1)=1;
handles.state=insertText(handles.state,[0 0],'No Simulation','FontSize',50,'BoxOpacity',0);
axes(handles.axes2);
imshow(handles.state);
axes(handles.axes1);
axis([-10 20 -10 20]);axis square;
% Choose default command line output for simple
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simple wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simple_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.state=zeros(100,400,3);
handles.state(:,:,1)=1;
handles.state(:,:,2)=0.5;
handles.state=insertText(handles.state,[0 0],'Working','FontSize',50,'BoxOpacity',0);
axes(handles.axes2);
cla;
imshow(handles.state);
drawnow;
tn=handles.slider;
threshold=handles.threshold;
envimat=handles.envimat;
mainforgui
handles.state=zeros(100,400,3);
handles.state(:,:,2)=1;
handles.state=insertText(handles.state,[0 0],'Ready','FontSize',50,'BoxOpacity',0);
axes(handles.axes2);
cla;
imshow(handles.state);
drawnow;
handles.x_tank_list=x_tank_list;
handles.xm_tank_list=xm_tank_list;
handles.xc_tank_list=xc_tank_list;
handles.N=N;
handles.envimat=envimat;
handles.mats=mats;
handles.hit=hit;
handles.Boxes=Boxes;
handles.calc=true;
handles.S=S;
guidata(hObject, handles);




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)*
if handles.calc
    
    axes(handles.axes1);
    [enrow,encol]=find(handles.envimat==1);
    axis on;axis xy;
    for k=1:handles.N
        cla;
            axis([-10 20 -10 20]);axis square; hold on;
            
            if handles.wallson
                for i=1:length(enrow)
                    plot(handles.Boxes{enrow(i),encol(i)},'black','black',1);
                end
            end
            if handles.boxeson
                [row,col]=find(handles.mats{k});
                for i=1:length(row)
                    plot(handles.Boxes{row(i),col(i)},'green','green',1);
                end
                [row,col]=find(handles.hit{k});
                for i=1:length(row)
                    plot(handles.Boxes{row(i),col(i)},'red','red',1);
                end
            end

            if handles.robotson
                draw_tank(handles.x_tank_list(:,k),'blue',0.2);
                draw_tank(handles.xm_tank_list(:,k),'red',0.2);
                draw_tank(handles.xc_tank_list(:,k),'black',0.2);
            end
            if handles.landmarkson
                scatter(handles.S(:,1),handles.S(:,2));
            end
            
            drawnow;
    end
else
     axes(handles.axes1);
     cla;
     axis on;axis xy;axis([-10 20 -10 20]);axis square; hold on;
end
    


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.robotson=get(hObject,'Value');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.boxeson=get(hObject,'Value');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.wallson=get(hObject,'Value');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.slider=get(hObject,'Value');
guidata(hObject, handles);
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rolling;
rolling=true;
axes(handles.axes1);
while rolling    
    cla;
    axis image;
%     [enrow,encol]=find(handles.envimat==1);
%     for i=1:length(enrow)
%         plot(handles.Boxes{enrow(i),encol(i)},'black','black',1);
%     end
    imshow(handles.envimat,[1,2]);
    %set(gcf,'Position',get(0,'Screensize'));
    hFH=imfreehand();
    % binaryimage=hFH.createMask();
    xy=hFH.getPosition;
    xy=unique(ceil(xy),'rows','first');
    disp(xy);
    handles.envimat(xy(:,2),xy(:,1))=1;
    
    
end
cla;
axis on;axis xy;axis([-10 20 -10 20]);axis square; hold on;
guidata(hObject, handles);
    


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.envimat(:)=2;
axes(handles.axes1);
cla;
axis image;
imshow(handles.envimat,[1,2]);
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rolling;
rolling=false;
guidata(hObject, handles);


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.landmarkson=get(hObject,'Value');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.threshold=get(hObject,'Value');
guidata(hObject, handles);
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
