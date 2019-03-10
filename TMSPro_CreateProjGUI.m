function varargout = TMSPro_CreateProjGUI(varargin)
% TMSPRO_CREATEPROJGUI MATLAB code for TMSPro_CreateProjGUI.fig
%      TMSPRO_CREATEPROJGUI, by itself, creates a new TMSPRO_CREATEPROJGUI or raises the existing
%      singleton*.
%
%      H = TMSPRO_CREATEPROJGUI returns the handle to a new TMSPRO_CREATEPROJGUI or the handle to
%      the existing singleton*.
%
%      TMSPRO_CREATEPROJGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TMSPRO_CREATEPROJGUI.M with the given input arguments.
%
%      TMSPRO_CREATEPROJGUI('Property','Value',...) creates a new TMSPRO_CREATEPROJGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TMSPro_CreateProjGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TMSPro_CreateProjGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TMSPro_CreateProjGUI

% Last Modified by GUIDE v2.5 10-Mar-2019 13:40:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TMSPro_CreateProjGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TMSPro_CreateProjGUI_OutputFcn, ...
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


% --- Executes just before TMSPro_CreateProjGUI is made visible.
function TMSPro_CreateProjGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TMSPro_CreateProjGUI (see VARARGIN)

[img, map, alpha] = imread('logo_transparent.png');
axes(handles.axes1);
imshow(img, map);
handles.axes1.Children.AlphaData = alpha;

% Choose default command line output for TMSPro_CreateProjGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TMSPro_CreateProjGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TMSPro_CreateProjGUI_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filen, filep] = uigetfile; % get file
ffile = fullfile(filep, filen); % get fullfile path so we can load from anywhere
handles.text11.String = filen; % display selected file to user
handles.output.UserData.inputFile = ffile; % place fullfile into output data
handles.text12.ForegroundColor = [0 1 0]; % change color of status to green
handles.text12.String = char(hex2dec('2713')); % change status to 'checked'
if isready(handles)
    handles.text14.ForegroundColor = [0 1 0]; % change color of status to green
    handles.text14.String = char(hex2dec('2713')); % change status to 'checked'
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filen, filep] = uiputfile;
ffile = fullfile(filep, filen);
if strcmp(ffile(end-3:end), '.mat')
    handles.output.UserData.outputFile = ffile; % set output data
    handles.text16.String = filen; % display file to user
    handles.text13.ForegroundColor = [0 1 0]; % change color of status to green
    handles.text13.String = char(hex2dec('2713')); % change status to 'checked'
else
    warn = sprintf('Make sure that your file ends with a .mat extension!');
    warning(warn);
end
if isready(handles)
    handles.text14.ForegroundColor = [0 1 0]; % change color of status to green
    handles.text14.String = char(hex2dec('2713')); % change status to 'checked'
end

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
