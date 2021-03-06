function varargout = TMSPro(varargin)
%TMSPRO MATLAB code file for TMSPro.fig
%      TMSPRO, by itself, creates a new TMSPRO or raises the existing
%      singleton*.
%
%      H = TMSPRO returns the handle to a new TMSPRO or the handle to
%      the existing singleton*.
%
%      TMSPRO('Property','Value',...) creates a new TMSPRO using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to TMSPro_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TMSPRO('CALLBACK') and TMSPRO('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TMSPRO.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TMSPro

% Last Modified by GUIDE v2.5 18-Mar-2019 17:38:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TMSPro_OpeningFcn, ...
                   'gui_OutputFcn',  @TMSPro_OutputFcn, ...
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


% --- Executes just before TMSPro_CreateProjGUI is made visible.
function TMSPro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TMSPro_CreateProjGUI (see VARARGIN)

% Add folder and subfolders to path
addpath(genpath(fileparts(which('TMSPro.m'))));

% Init logo
[img, map, alpha] = imread('logo_transparent.png');
axes(handles.axes1);
imshow(img, map);
handles.axes1.Children.AlphaData = alpha;

% Choose default command line output for TMSPro_CreateProjGUI
handles.output = hObject;

% Create default settings
SetDefaultSettings(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TMSPro_Intro wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TMSPro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isstruct(handles)
    % Get default command line output from handles structure
    varargout{1} = handles.output.UserData;

    % Destroy GUI
    delete(handles.figure1);
    
    % Start up Main Stage
    TMSPro_Main(varargout);
else
    varargout = {0};
end


% --- Create New Project - Create button
function pushbutton1_Callback(hObject, eventdata, handles)

if isready(handles)
    uiresume(handles.figure1);
else
    warn = sprintf('One or more fields are not correctly filled out.');
    warning(warn);
end 


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filen, filep] = uigetfile('*.mat'); % get file
if all(filen ~= 0) || all(filep ~= 0)
    ffile = fullfile(filep, filen); % get fullfile path so we can load from anywhere
    handles.pushbutton2.String = filen; % display selected file to user
    handles.pushbutton2.FontSize = 10;
    handles.output.UserData.inputFile = ffile; % place fullfile into output data
    handles.text12.ForegroundColor = [0 1 0]; % change color of status to green
    handles.text12.String = char(hex2dec('2713')); % change status to 'checked'
    if isready(handles)
        handles.text14.ForegroundColor = [0 1 0]; % change color of status to green
        handles.text14.String = char(hex2dec('2713')); % change status to 'checked'
    else
        handles.text14.ForegroundColor = [1 0 0];
        handles.text14.String = 'X';
    end
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filen, filep] = uiputfile; % open dialogue
if all(filen ~= 0) || all(filep ~= 0)
    [~,~,ext] = fileparts(filen); % get chosen filename's extension
    if strcmp(ext,'.mldatx'); filen = strrep(filen, '.mldatx', '.mat'); end % if no extension is given, make it a .mat file
    ffile = fullfile(filep, filen);
    if strcmp(ffile(end-3:end), '.mat')
        handles.output.UserData.outputFile = ffile; % set output data
        handles.pushbutton3.String = filen; % display file to user
        handles.pushbutton3.FontSize = 10;
        handles.text13.ForegroundColor = [0 1 0]; % change color of status to green
        handles.text13.String = char(hex2dec('2713')); % change status to 'checked'
    else
        handles.output.UserData.outputFile = ffile;
        handles.text14.ForegroundColor = [1 0 0];
        handles.text14.String = 'X';
        warn = sprintf('Make sure that your file ends with a .mat extension!');
        warning(warn);
    end
    if isready(handles)
        handles.text14.ForegroundColor = [0 1 0]; % change color of status to green
        handles.text14.String = char(hex2dec('2713')); % change status to 'checked'
    end
end

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filen, filep] = uigetfile('*.mat');
ffile = fullfile(filep, filen);
if all(filen ~= 0) || all(filep ~= 0)
    if checkExistingProject(ffile)
        handles.pushbutton5.String = filen;
        handles.pushbutton5.FontSize = 10;
        handles.text23.ForegroundColor = [0 1 0];
        handles.text23.String = char(hex2dec('2713'));
        handles.text25.ForegroundColor = [0 1 0];
        handles.text25.String = char(hex2dec('2713'));
        handles.output.UserData.ExistingFile = ffile;
    else
        warn = sprintf('Something went wrong checking your existing file. \nDouble check that this is the file you worked with before.\n*.mat file must contain the following variables: settings, TMS, tms');
        warning(warn);
    end
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
var = str2double(get(hObject,'String'));
if CheckSetSetting(var)
    handles.text33.String = num2str(var);
    handles.output.UserData.ArtifactFactor = var;
    
    % Update handles structure
    guidata(hObject, handles);
    
else warning('Invalid input type. Must be an integer.');
end

set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');


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


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
var = get(hObject, 'String');
var = var{1};
split = strfind(var,':');
min = str2double(var(1:split-1));
max = str2double(var(split+1:end));
if CheckRange(min, max)
    handles.text31.String = var;
    handles.output.UserData.plotlimitsx = [min max];
    
    % Update handles structure
    guidata(hObject, handles);
    
else 
    warn = sprintf('Invalid inputs. Setting must be two integers separated by a colon. \nExamples: 1:500, 5:100, 60:90');
    warning(warn);
end

set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
var = str2double(get(hObject,'String'));
if CheckSetSetting(var)
    handles.text30.String = num2str(var);
    handles.output.UserData.baselinelength = var;
    
    % Update handles structure
    guidata(hObject, handles);
    
else warning('Invalid input type. Must be an integer.');
end

set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
var = str2double(get(hObject,'String'));
if CheckSetSetting(var)
    handles.text29.String = num2str(var);
    handles.output.UserData.maxmeplength = var;
    
    % Update handles structure
    guidata(hObject, handles);
    
else warning('Invalid input type. Must be an integer.');
end

set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
var = str2double(get(hObject,'String'));
if CheckSetSetting(var)
    handles.text28.String = num2str(var);
    handles.output.UserData.artifactlength = var;
    
    % Update handles structure
    guidata(hObject, handles);
    
else warning('Invalid input type. Must be an integer.');
end

set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');


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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetDefaultSettings(handles);

% Update handles structure
guidata(hObject, handles);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
var = get(hObject, 'String');
var = var{1};
split = strfind(var,':');
min = str2double(var(1:split-1));
max = str2double(var(split+1:end));
if CheckRange(min, max)
    handles.text34.String = var;
    handles.output.UserData.plotlimitsy = [min max];
    
    % Update handles structure
    guidata(hObject, handles);
    
else 
    warn = sprintf('Invalid inputs. Setting must be two integers separated by a colon. \nExamples: 1:500, 5:100, 60:90');
    warning(warn);
end

set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
var = str2double(get(hObject,'String'));
if CheckSetSetting(var)
    handles.text35.String = num2str(var);
    handles.output.UserData.minamplitude = var;   
    
    % Update handles structure
    guidata(hObject, handles);
    
else warning('Invalid input type. Must be an integer.');
end

set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');


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
