function varargout = firstordergui(varargin)
%FIRSTORDERGUI M-file for firstordergui.fig
%      FIRSTORDERGUI, by itself, creates a new FIRSTORDERGUI or raises the existing
%      singleton*.
%
%      H = FIRSTORDERGUI returns the handle to a new FIRSTORDERGUI or the handle to
%      the existing singleton*.
%
%      FIRSTORDERGUI('Property','Value',...) creates a new FIRSTORDERGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to firstordergui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FIRSTORDERGUI('CALLBACK') and FIRSTORDERGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FIRSTORDERGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help firstordergui

% Last Modified by GUIDE v2.5 04-Jul-2013 10:00:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @firstordergui_OpeningFcn, ...
    'gui_OutputFcn',  @firstordergui_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before firstordergui is made visible.
function firstordergui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for firstordergui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global coeffs;
coeffs=zeros(60,1);
global gender;
global gLoadedM;
global gLoadedF;
global gVariancesM;
global gVariancesF;
global gStddevsM;
global gStddevsF;
global secretmode;
global picnum;
picnum=1;
global silly;
silly=1;
secretmode=0;
gLoadedM=0;
gLoadedF=0;
gender=1;

global gPCAM;
global gPCAF;
global gMeanMorphM;
global gMeanMorphF;

global myVars;
myVars.displayMode=3;

global c;
c=varargin{1};


PCAModelFile=[rightPath(c,c.dirPCAModel) 'all\PCAModel.mat'];
varFile=[rightPath(c,c.dirPCAModel) 'all\variance.mat'];

load(PCAModelFile);
load(varFile);
%Now we need to make everything have less dimensions- 12 in fact.
if not(exist('PCA'))
PCA=pcTrimmed;
end

myVars.PCAsize=min(size(PCA,2),12); %Set global PCA size variable to 12 or real PCa size, whichever is smaller
PCA=PCA(:,1:min(12,myVars.PCAsize));
variance=variance(1:myVars.PCAsize)';

%load('spaces/PCAModel_M');
gPCAM=PCA;
if not(exist('MeanMorph'))
    MeanMorph=MorphMean;
end
gMeanMorphM=MeanMorph;
%load('spaces/PCAModel_F');
gPCAF=PCA;
%gPCAF(:,2) = -gPCAF(:,2); % NEW added to flip dimension in one sex to sign-match UCL face database PCA dimensions
%gPCAF(:,4) = -gPCAF(:,4); % NEW added to flip dimension in one sex to sign-match UCL face database PCA dimensions
%gMeanMorphF=MeanMorph;
%load('spaces/variance_M');

gVariancesM=variance;
gStddevsM=sqrt(variance);
%load('spaces/variance_F');
gVariancesF=variance;
gStddevsF=sqrt(variance);

set(handles.slider14,'Visible','off');

%Work out the variances of the coeffs
% load ('all/pccoefs.mat');
% variances=var(varMat);
% variances=variances(1:12);
% stddevs=sqrt(variances);
%
% multiplier=2;
%
% set(handles.slider1,'Min',-multiplier*stddevs(1));
% set(handles.slider1,'Max',multiplier*stddevs(1));
% set(handles.text1,'String',0);
%
% set(handles.slider2,'Min',-multiplier*stddevs(2));
% set(handles.slider2,'Max',multiplier*stddevs(2));
%
% set(handles.slider3,'Min',-multiplier*stddevs(3));
% set(handles.slider3,'Max',multiplier*stddevs(3));
%
% set(handles.slider4,'Min',-multiplier*stddevs(4));
% set(handles.slider4,'Max',multiplier*stddevs(4));
%
% set(handles.slider5,'Min',-multiplier*stddevs(5));
% set(handles.slider5,'Max',multiplier*stddevs(5));
%
% set(handles.slider6,'Min',-multiplier*stddevs(6));
% set(handles.slider6,'Max',multiplier*stddevs(6));
%
% set(handles.slider7,'Min',-multiplier*stddevs(7));
% set(handles.slider7,'Max',multiplier*stddevs(7));
%
% set(handles.slider8,'Min',-multiplier*stddevs(8));
% set(handles.slider8,'Max',multiplier*stddevs(8));
%
% set(handles.slider9,'Min',-multiplier*stddevs(9));
% set(handles.slider9,'Max',multiplier*stddevs(9));
%
% set(handles.slider10,'Min',-multiplier*stddevs(10));
% set(handles.slider10,'Max',multiplier*stddevs(10));
%
% set(handles.slider11,'Min',-multiplier*stddevs(11));
% set(handles.slider11,'Max',multiplier*stddevs(11));
%
% set(handles.slider12,'Min',-multiplier*stddevs(12));
% set(handles.slider12,'Max',multiplier*stddevs(12));

set(handles.slider1,'Value',0.5);
set(handles.slider2,'Value',0.5);
set(handles.slider3,'Value',0.5);
set(handles.slider4,'Value',0.5);
set(handles.slider5,'Value',0.5);
set(handles.slider6,'Value',0.5);
set(handles.slider7,'Value',0.5);
set(handles.slider8,'Value',0.5);
set(handles.slider9,'Value',0.5);
set(handles.slider10,'Value',0.5);
set(handles.slider11,'Value',0.5);
set(handles.slider12,'Value',0.5);

set(handles.text1,'String','0');
set(handles.text2,'String','0');
set(handles.text3,'String','0');
set(handles.text4,'String','0');
set(handles.text5,'String','0');
set(handles.text6,'String','0');
set(handles.text7,'String','0');
set(handles.text8,'String','0');
set(handles.text9,'String','0');
set(handles.text10,'String','0');
set(handles.text11,'String','0');
set(handles.text12,'String','0');

axes(handles.axes2);
logo=imread('logo.bmp');
imshow(logo);

axes(handles.axes3);
logotop=imread('logotop.bmp');
imshow(logotop);

set(handles.text13,'String','Gender: male');
faceRedraw(hObject, eventdata, handles,0);



% UIWAIT makes firstordergui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = firstordergui_OutputFcn(hObject, eventdata, handles)
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

set(handles.text1,'String',num2str(get(handles.slider1,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'String',num2str(get(handles.slider2,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
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


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text3,'String',num2str(get(handles.slider3,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
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


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text4,'String',num2str(get(handles.slider4,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
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


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text5,'String',num2str(get(handles.slider5,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text6,'String',num2str(get(handles.slider6,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
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


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text7,'String',num2str(get(handles.slider7,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text8,'String',num2str(get(handles.slider8,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text9,'String',num2str(get(handles.slider9,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text10,'String',num2str(get(handles.slider10,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text11,'String',num2str(get(handles.slider11,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider12_Callback(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text12,'String',num2str(get(handles.slider12,'Value')*200-100,3));
faceRedraw(hObject, eventdata, handles,0);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
handles
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
faceRedraw(hObject, eventdata, handles,0);




% GENDER CHANGE FUNCTION IS HERE
% ---------------------------------------------------------------

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global coeffs;
global gender;
global gStddevsM;
global gStddevsF;
if gender==1 %Switching from male to female
    gender=0; set(handles.text13,'String','Gender: female');
    clear coeffs;
    
    coeffs(1)=get(handles.slider1,'Value');
    coeffs(2)=get(handles.slider2,'Value');
    coeffs(3)=get(handles.slider3,'Value');
    coeffs(4)=get(handles.slider4,'Value');
    coeffs(5)=get(handles.slider5,'Value');
    coeffs(6)=get(handles.slider6,'Value');
    coeffs(7)=get(handles.slider7,'Value');
    coeffs(8)=get(handles.slider8,'Value');
    coeffs(9)=get(handles.slider9,'Value');
    coeffs(10)=get(handles.slider10,'Value');
    coeffs(11)=get(handles.slider11,'Value');
    coeffs(12)=get(handles.slider12,'Value');
    
    %Convert slider values to male-coeffs
    % OLD
%     imshow(guigenfaceFEM(coeffs,0));
    
% NEW

femaleCoeffs=GetFemaleCoeffs(hObject, eventdata, handles, coeffs);    
    for i = 1:12
        
        if femaleCoeffs(i) > 1;
            femaleCoeffs(i) = 1;
        elseif femaleCoeffs(i) < 0;
            femaleCoeffs(i) = 0;
        end
    end
    
    imshow(guigenfaceFEM(femaleCoeffs,0));
    
    %Set slider values
    
    set(handles.slider1,'Value',femaleCoeffs(1));
    set(handles.slider2,'Value',femaleCoeffs(2));
    set(handles.slider3,'Value',femaleCoeffs(3));
    set(handles.slider4,'Value',femaleCoeffs(4));
    set(handles.slider5,'Value',femaleCoeffs(5));
    set(handles.slider6,'Value',femaleCoeffs(6));
    set(handles.slider7,'Value',femaleCoeffs(7));
    set(handles.slider8,'Value',femaleCoeffs(8));
    set(handles.slider9,'Value',femaleCoeffs(9));
    set(handles.slider10,'Value',femaleCoeffs(10));
    set(handles.slider11,'Value',femaleCoeffs(11));
    set(handles.slider12,'Value',femaleCoeffs(12));
    
    set(handles.text1,'String',num2str(femaleCoeffs(1)*200-100,3));
    set(handles.text2,'String',num2str(femaleCoeffs(2)*200-100,3));
    set(handles.text3,'String',num2str(femaleCoeffs(3)*200-100,3));
    set(handles.text4,'String',num2str(femaleCoeffs(4)*200-100,3));
    set(handles.text5,'String',num2str(femaleCoeffs(5)*200-100,3));
    set(handles.text6,'String',num2str(femaleCoeffs(6)*200-100,3));
    set(handles.text7,'String',num2str(femaleCoeffs(7)*200-100,3));
    set(handles.text8,'String',num2str(femaleCoeffs(8)*200-100,3));
    set(handles.text9,'String',num2str(femaleCoeffs(9)*200-100,3));
    set(handles.text10,'String',num2str(femaleCoeffs(10)*200-100,3));
    set(handles.text11,'String',num2str(femaleCoeffs(11)*200-100,3));
    set(handles.text12,'String',num2str(femaleCoeffs(12)*200-100,3));






    
    
    
elseif gender==0 %Switching from female to male
    gender=1; set(handles.text13,'String','Gender: male');
    %Get the coeffs
    clear coeffs;
    
    coeffs(1)=get(handles.slider1,'Value');
    coeffs(2)=get(handles.slider2,'Value');
    coeffs(3)=get(handles.slider3,'Value');
    coeffs(4)=get(handles.slider4,'Value');
    coeffs(5)=get(handles.slider5,'Value');
    coeffs(6)=get(handles.slider6,'Value');
    coeffs(7)=get(handles.slider7,'Value');
    coeffs(8)=get(handles.slider8,'Value');
    coeffs(9)=get(handles.slider9,'Value');
    coeffs(10)=get(handles.slider10,'Value');
    coeffs(11)=get(handles.slider11,'Value');
    coeffs(12)=get(handles.slider12,'Value');
    
    %Convert slider values to female-coeffs
    
%     imshow(guigenface(coeffs,0));
    
    % NEW
    
maleCoeffs=GetMaleCoeffs(hObject, eventdata, handles, coeffs);
    
    for i = 1:12
        if maleCoeffs(i) > 1;
            maleCoeffs(i) = 1;
        elseif maleCoeffs(i) < 0;
            maleCoeffs(i) = 0;
        end
    end
    
    imshow(guigenface(maleCoeffs,0));
    
    %Set slider values
    
    set(handles.slider1,'Value',maleCoeffs(1));
    set(handles.slider2,'Value',maleCoeffs(2));
    set(handles.slider3,'Value',maleCoeffs(3));
    set(handles.slider4,'Value',maleCoeffs(4));
    set(handles.slider5,'Value',maleCoeffs(5));
    set(handles.slider6,'Value',maleCoeffs(6));
    set(handles.slider7,'Value',maleCoeffs(7));
    set(handles.slider8,'Value',maleCoeffs(8));
    set(handles.slider9,'Value',maleCoeffs(9));
    set(handles.slider10,'Value',maleCoeffs(10));
    set(handles.slider11,'Value',maleCoeffs(11));
    set(handles.slider12,'Value',maleCoeffs(12));
    
    set(handles.text1,'String',num2str(maleCoeffs(1)*200-100,3));
    set(handles.text2,'String',num2str(maleCoeffs(2)*200-100,3));
    set(handles.text3,'String',num2str(maleCoeffs(3)*200-100,3));
    set(handles.text4,'String',num2str(maleCoeffs(4)*200-100,3));
    set(handles.text5,'String',num2str(maleCoeffs(5)*200-100,3));
    set(handles.text6,'String',num2str(maleCoeffs(6)*200-100,3));
    set(handles.text7,'String',num2str(maleCoeffs(7)*200-100,3));
    set(handles.text8,'String',num2str(maleCoeffs(8)*200-100,3));
    set(handles.text9,'String',num2str(maleCoeffs(9)*200-100,3));
    set(handles.text10,'String',num2str(maleCoeffs(10)*200-100,3));
    set(handles.text11,'String',num2str(maleCoeffs(11)*200-100,3));
    set(handles.text12,'String',num2str(maleCoeffs(12)*200-100,3));
    
    
    
end

% THIS IS THE ANTIFACE BUTTON!-----------------------------------

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global coeffs;
global gender;
clear coeffs;

coeffs(1)=get(handles.slider1,'Value');
coeffs(2)=get(handles.slider2,'Value');
coeffs(3)=get(handles.slider3,'Value');
coeffs(4)=get(handles.slider4,'Value');
coeffs(5)=get(handles.slider5,'Value');
coeffs(6)=get(handles.slider6,'Value');
coeffs(7)=get(handles.slider7,'Value');
coeffs(8)=get(handles.slider8,'Value');
coeffs(9)=get(handles.slider9,'Value');
coeffs(10)=get(handles.slider10,'Value');
coeffs(11)=get(handles.slider11,'Value');
coeffs(12)=get(handles.slider12,'Value');

coeffs=(-(coeffs-0.5))+0.5;

set(handles.text1,'String',num2str(coeffs(1)*200-100,3));
set(handles.text2,'String',num2str(coeffs(2)*200-100,3));
set(handles.text3,'String',num2str(coeffs(3)*200-100,3));
set(handles.text4,'String',num2str(coeffs(4)*200-100,3));
set(handles.text5,'String',num2str(coeffs(5)*200-100,3));
set(handles.text6,'String',num2str(coeffs(6)*200-100,3));
set(handles.text7,'String',num2str(coeffs(7)*200-100,3));
set(handles.text8,'String',num2str(coeffs(8)*200-100,3));
set(handles.text9,'String',num2str(coeffs(9)*200-100,3));
set(handles.text10,'String',num2str(coeffs(10)*200-100,3));
set(handles.text11,'String',num2str(coeffs(11)*200-100,3));

set(handles.slider1,'Value',coeffs(1));
set(handles.slider2,'Value',coeffs(2));
set(handles.slider3,'Value',coeffs(3));
set(handles.slider4,'Value',coeffs(4));
set(handles.slider5,'Value',coeffs(5));
set(handles.slider6,'Value',coeffs(6));
set(handles.slider7,'Value',coeffs(7));
set(handles.slider8,'Value',coeffs(8));
set(handles.slider9,'Value',coeffs(9));
set(handles.slider10,'Value',coeffs(10));
set(handles.slider11,'Value',coeffs(11));
set(handles.slider12,'Value',coeffs(12));

if gender==1
    imshow(guigenface(coeffs',0));
else
    imshow(guigenfaceFEM(coeffs',0));
end
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
faceRedraw(hObject, eventdata, handles,0);
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

function faceRedraw(hObject,eventdata,handles,antiface)

axes(handles.axes1);
load('c');
global config;
global coeffs;
global myVars;
global gender;
clear coeffs;

coeffs(1)=get(handles.slider1,'Value');
coeffs(2)=get(handles.slider2,'Value');
coeffs(3)=get(handles.slider3,'Value');
coeffs(4)=get(handles.slider4,'Value');
coeffs(5)=get(handles.slider5,'Value');
coeffs(6)=get(handles.slider6,'Value');
coeffs(7)=get(handles.slider7,'Value');
coeffs(8)=get(handles.slider8,'Value');
coeffs(9)=get(handles.slider9,'Value');
coeffs(10)=get(handles.slider10,'Value');
coeffs(11)=get(handles.slider11,'Value');
coeffs(12)=get(handles.slider12,'Value');

if myVars.displayMode ~=2 %This is a hack because warp mode (2) doesn't return an image from guigenface, it plots it into the figure
if gender==1
    imshow(guigenface(coeffs',0));
else
    imshow(guigenfaceFEM(coeffs',0));
end
else
   % clf
    if gender==1
    guigenface(coeffs',0);
else
    guigenfaceFEM(coeffs',0);
    end
end



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB


% handles    structure with handles and user data (see GUIDATA)
set(handles.slider1,'Value',0.5);
set(handles.slider2,'Value',0.5);
set(handles.slider3,'Value',0.5);
set(handles.slider4,'Value',0.5);
set(handles.slider5,'Value',0.5);
set(handles.slider6,'Value',0.5);
set(handles.slider7,'Value',0.5);
set(handles.slider8,'Value',0.5);
set(handles.slider9,'Value',0.5);
set(handles.slider10,'Value',0.5);
set(handles.slider11,'Value',0.5);
set(handles.slider12,'Value',0.5);
faceRedraw(hObject, eventdata, handles,0);

set(handles.text1,'String','0');
set(handles.text2,'String','0');
set(handles.text3,'String','0');
set(handles.text4,'String','0');
set(handles.text5,'String','0');
set(handles.text6,'String','0');
set(handles.text7,'String','0');
set(handles.text8,'String','0');
set(handles.text9,'String','0');
set(handles.text10,'String','0');
set(handles.text11,'String','0');
set(handles.text12,'String','0');


function maleCoeffs=GetMaleCoeffs(hObject, eventdata, handles, coeffs)


global gMeanMorphF;
global gPCAF;
global gPCAM;
global gStddevsM;



%Get the female morph vector


coeffs = coeffs - 0.5; % NEW;

MFR=gPCAF*coeffs'; %' is NEW
%MF=MFR+gMeanMorphF;
%Multiply this by the male PCA descriptor



maleCoeffs=gPCAM'*(MFR*1.75);

maleCoeffs=maleCoeffs+0.5; % NEW

% for i=1:size(maleCoeffs,1)
%     if abs(maleCoeffs(i))>gStddevsM(i)
%         maleCoeffs(i)=gStddevsM(i)*sign(maleCoeffs(i));
%     end;
% end





function femaleCoeffs=GetFemaleCoeffs(hObject, eventdata, handles, coeffs)

global gMeanMorphF;
global gPCAF;
global gPCAM;
global gStddevsM;



%Get the male morph vector

coeffs = coeffs - 0.5; % NEW;

MMR=gPCAM*coeffs'; % centre and ' are NEW;
%MF=MFR+gMeanMorphF;
%Multiply this by the female PCA descriptor



femaleCoeffs=gPCAF'*(MMR*1.75);

femaleCoeffs=femaleCoeffs+0.5; % NEW


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3

%------------------THIS IS THE RANDOM FACE BUTTON-------------



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
global gender;
global myVars;
global config;
axes(handles.axes1);
randsliders=rand(12,1);

coeffs=randsliders;

set(handles.text1,'String',num2str(coeffs(1)*200-100,3));
set(handles.text2,'String',num2str(coeffs(2)*200-100,3));
set(handles.text3,'String',num2str(coeffs(3)*200-100,3));
set(handles.text4,'String',num2str(coeffs(4)*200-100,3));
set(handles.text5,'String',num2str(coeffs(5)*200-100,3));
set(handles.text6,'String',num2str(coeffs(6)*200-100,3));
set(handles.text7,'String',num2str(coeffs(7)*200-100,3));
set(handles.text8,'String',num2str(coeffs(8)*200-100,3));
set(handles.text9,'String',num2str(coeffs(9)*200-100,3));
set(handles.text10,'String',num2str(coeffs(10)*200-100,3));
set(handles.text11,'String',num2str(coeffs(11)*200-100,3));
set(handles.text12,'String',num2str(coeffs(12)*200-100,3));

set(handles.slider1,'Value',coeffs(1));
set(handles.slider2,'Value',coeffs(2));
set(handles.slider3,'Value',coeffs(3));
set(handles.slider4,'Value',coeffs(4));
set(handles.slider5,'Value',coeffs(5));
set(handles.slider6,'Value',coeffs(6));
set(handles.slider7,'Value',coeffs(7));
set(handles.slider8,'Value',coeffs(8));
set(handles.slider9,'Value',coeffs(9));
set(handles.slider10,'Value',coeffs(10));
set(handles.slider11,'Value',coeffs(11));
set(handles.slider12,'Value',coeffs(12));


if myVars.displayMode ~=2 %This is a hack because warp mode (2) doesn't return an image from guigenface, it plots it into the figure
if gender==1
    imshow(guigenface(coeffs',0));
else
    imshow(guigenfaceFEM(coeffs',0));
end
else
   % clf
    if gender==1
    guigenface(coeffs',0);
else
    guigenfaceFEM(coeffs',0);
end
end
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider14_Callback(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global silly;
global gender;
silly=(get(handles.slider12,'Value')+0.1)*20;
axes(handles.axes1);
if gender==1
    imshow(guigenface(coeffs',antiface));
else
    imshow(guigenfaceFEM(coeffs',antiface));
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%SECRET BUTTON
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
global secretmode;
global silly;
if secretmode
    secretmode=0;
   set(handles.slider14,'Visible','off');
   silly=1;
else
    secretmode=1;
    
    silly=7;
    
end

% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
axes(handles.axes1);
global coeffs;
global gender;
clear coeffs;
coeffs(1)=get(handles.slider1,'Value');
coeffs(2)=get(handles.slider2,'Value');
coeffs(3)=get(handles.slider3,'Value');
coeffs(4)=get(handles.slider4,'Value');
coeffs(5)=get(handles.slider5,'Value');
coeffs(6)=get(handles.slider6,'Value');
coeffs(7)=get(handles.slider7,'Value');
coeffs(8)=get(handles.slider8,'Value');
coeffs(9)=get(handles.slider9,'Value');
coeffs(10)=get(handles.slider10,'Value');
coeffs(11)=get(handles.slider11,'Value');
coeffs(12)=get(handles.slider12,'Value');
global picnum;
savedcoeffs(picnum,1)=str2num(get(handles.text1,'String'));
savedcoeffs(picnum,2)=str2num(get(handles.text2,'String'));
savedcoeffs(picnum,3)=str2num(get(handles.text3,'String'));
savedcoeffs(picnum,4)=str2num(get(handles.text4,'String'));
savedcoeffs(picnum,5)=str2num(get(handles.text5,'String'));
savedcoeffs(picnum,6)=str2num(get(handles.text6,'String'));
savedcoeffs(picnum,7)=str2num(get(handles.text7,'String'));
savedcoeffs(picnum,8)=str2num(get(handles.text8,'String'));
savedcoeffs(picnum,9)=str2num(get(handles.text9,'String'));
savedcoeffs(picnum,10)=str2num(get(handles.text10,'String'));
savedcoeffs(picnum,11)=str2num(get(handles.text11,'String'));
savedcoeffs(picnum,12)=str2num(get(handles.text12,'String'));

save('out\savedcoeffs', 'savedcoeffs');

if gender==1
    imwrite(guigenface(coeffs',0),['out\' num2str(picnum) '.jpg']);
else
    imwrite(guigenfaceFEM(coeffs',0),['out\' num2str(picnum) '.jpg']);
end




picnum=picnum+1;
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider15_Callback(hObject, eventdata, handles)

%This is the caricaturing callback

% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

newCaric=get(handles.slider15,'Value')*10;

global silly;

    
    silly=newCaric;
    


set(handles.text29,'String',num2str(newCaric));
faceRedraw(hObject, eventdata, handles,0);


% --- Executes during object creation, after setting all properties.
function slider15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myVars;
myVars.displayMode=1;
faceRedraw(hObject, eventdata, handles,0);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myVars;
myVars.displayMode=2;
myVars.axesHandle=handles.axes1;
faceRedraw(hObject, eventdata, handles,0);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myVars;
myVars.displayMode=3;
faceRedraw(hObject, eventdata, handles,0);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myVars;
imwrite(myVars.face,'C:\Users\PaLS\Desktop\identikitImage.bmp','bmp');


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
