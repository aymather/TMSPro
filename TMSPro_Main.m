function varargout = TMSPro_Main(varargin)
% TMSPRO MATLAB code for TMSPro.fig
%      TMSPRO, by itself, creates a new TMSPRO or raises the existing
%      singleton*.
%
%      H = TMSPRO returns the handle to a new TMSPRO or the handle to
%      the existing singleton*.
%
%      TMSPRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TMSPRO.M with the given input arguments.
%
%      TMSPRO('Property','Value',...) creates a new TMSPRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TMSPro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TMSPro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TMSPro

% Last Modified by GUIDE v2.5 18-Apr-2019 08:36:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TMSPro_OpeningFcn, ...
                   'gui_OutputFcn',  @TMSPro_OutputFcn, ...
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


% --- Executes just before TMSPro is made visible.
function TMSPro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TMSPro (see VARARGIN)

% Add folder and subfolders to path
addpath(genpath(fileparts(which('TMSPro.m'))));

% Init logo
[img, map, alpha] = imread('logo_transparent.png');
axes(handles.axes2);
imshow(img, map);
handles.axes2.Children.AlphaData = alpha;

% Extract inputs
input = varargin{1};
data = input{1,1};

% Init
[handles.settings, handles.TMS, handles.tms] = TMSPro_init(data);

% Turn off extra buttons
ToggleButtonDisplay(handles,0);

% Init filters
handles.TMS_temp = [];
handles = UpdateFilters(handles);

% Create a matrix that represents the current scrolling TMS matrix
handles.TMS_current = handles.TMS;

% Init export matrix
handles.export = handles.TMS;

% Show current working frame
ShowFrameOnAxis(handles);

% Choose default command line output for TMSPro
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = TMSPro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'output')
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = frameBackwards(handles);
ShowFrameOnAxis(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = frameForwards(handles);
ShowFrameOnAxis(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on figure1 or any of its controls.
% Handles Keyboard Shortcuts
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% Handles keyboard shortcuts
switch eventdata.Key
    
    case 'rightarrow'
        pushbutton3_Callback(handles.pushbutton3, eventdata, handles);
        
    case 'leftarrow'
        pushbutton2_Callback(handles.pushbutton2, eventdata, handles);
        
    case 's'
        pushbutton4_Callback(handles.pushbutton4, eventdata, handles);
        disp('Saved!');
        
    case 'q'
        figure1_CloseRequestFcn(handles.figure1, eventdata, handles);
        
    case 'g'
        pushbutton5_Callback(handles.pushbutton5, eventdata, handles);
        
    case 'r'
        pushbutton7_Callback(handles.pushbutton7, eventdata, handles); 
        
    case 'a'
        if ToggleButtonDisplay(handles)
            pushbutton10_Callback(handles.pushbutton10, eventdata, handles);
        end
        
    case 'c'
        if ToggleButtonDisplay(handles)
            pushbutton8_Callback(handles.pushbutton8, eventdata, handles);
        end
        
    case 'v'
        if ToggleButtonDisplay(handles)
            pushbutton12_Callback(handles.pushbutton12, eventdata, handles);
        end
        
    case 'x'
        pushbutton13_Callback(handles.pushbutton13, eventdata, handles);
        
    case 'k' 
        keyboard
        
end
        

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Deconstruct saveables from handles
settings = handles.settings;
TMS = handles.TMS;
tms = handles.tms;
save(settings.files.outfile, 'settings', 'TMS', 'tms');
disp('Saved!');


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save dialogue
answer = SaveDialogue;
if strcmp(answer, 'Yes')
    pushbutton4_Callback(handles.figure1, eventdata, handles);
    disp('Saved!');
end

% Hint: delete(hObject) closes the figure
delete(hObject);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
frame = str2double(get(hObject,'String'));

if frame >= 1 && frame <= handles.settings.cframes
    
    % Update currentframe and countindex
    handles.settings.currentframe = frame;
    row = handles.TMS_current(handles.settings.currentframe,:);
    handles.settings.countindex = find(all(handles.TMS_current(:,handles.settings.id.Tnum:handles.settings.id.Trej_other)==row,2));
    
    ShowFrameOnAxis(handles);

    % Update handles structure
    guidata(hObject, handles);
    
    % Reset string inside edit box
    handles.edit1.String = 'Go to Frame...';
    set(hObject, 'Enable', 'off');
    drawnow;
    set(hObject, 'Enable', 'on');
    
else warning('Not a valid frame.');
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Only do something if it is an accepted trial & has an onset/offset
if all(handles.TMS(handles.settings.currentframe,handles.settings.id.Trej_nopulse:handles.settings.id.Trej_other) == 0) && ...
    handles.TMS(handles.settings.currentframe,handles.settings.id.Taonset) ~= 0 && ...
    handles.TMS(handles.settings.currentframe,handles.settings.id.Tmoffset) ~= 0

    % Zoom in and find peaks
    FindAndPlotPeaks(handles);
    
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure1_CloseRequestFcn(handles.figure1, eventdata, handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Toggle buttons back off
ToggleButtonDisplay(handles,0);

% Show current frame on axis
ShowFrameOnAxis(handles); 


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

[peaksIndex, valleysIndex] = GetSelectedPeaksIndex(handles);
[currentPeaks, currentValleys] = PlotSelectedPeaks(handles, peaksIndex, valleysIndex);


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

[peaksIndex, valleysIndex] = GetSelectedPeaksIndex(handles);
[currentPeaks, currentValleys] = PlotSelectedPeaks(handles, peaksIndex, valleysIndex);


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


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotCurrentRecordedAmplitude(handles);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.popupmenu1,'Value',1);
set(handles.popupmenu2,'Value',1);
popupmenu1_Callback(handles.popupmenu1, eventdata, handles);
popupmenu2_Callback(handles.popupmenu2, eventdata, handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get current selected peak/valley
cPeaks = cellstr(get(handles.popupmenu1,'String'));
cValleys = cellstr(get(handles.popupmenu2,'String'));
peak = str2double(cPeaks{get(handles.popupmenu1,'Value')});
valley = str2double(cValleys{get(handles.popupmenu2,'Value')});

% Check inputs for correct format
if ~isnan(peak) && ~isnan(valley)
    
   % Make sure they want to make changes
   answer = SetNewAmpDialogue(peak,valley);
   if strcmp(answer, 'Yes')
       
       % Adjust new peak/valley to TMS matrix
       handles.TMS(handles.settings.currentframe,handles.settings.id.Tmax) = peak;
       handles.TMS(handles.settings.currentframe,handles.settings.id.Tmin) = valley;
       
       % Adjust new amplitude to TMS matrix
       handles.TMS(handles.settings.currentframe,handles.settings.id.Tmep) = abs(peak) + abs(valley);
       
       % Update filters
       handles = UpdateFilters(handles);

       % Update handles structure
       guidata(hObject, handles);
       
       % Hide buttons again
       ToggleButtonDisplay(handles,0);

       % Save
       pushbutton4_Callback(handles.pushbutton4, eventdata, handles);
       
       % Go back and show frame
       ShowFrameOnAxis(handles);

   end
end
    
    
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentTrial = handles.settings.currentframe;
if handles.pushbutton13.UserData
    
    str = RejectionConfirmationDialogue(currentTrial);
    [bool, index] = ismember(str, handles.settings.rejreasons);
    if bool; handles.TMS(currentTrial, index + 9) = 1; end
    
else
    
    % Reset TMS matrix to 0
    handles.TMS(currentTrial, handles.settings.id.Trej_nopulse:handles.settings.id.Trej_other) = 0;
    
end

% Update Filters
handles = UpdateFilters(handles);

% Set buttons off again
ToggleButtonDisplay(handles,0);

% Update handles structure
guidata(hObject, handles);

% Save
pushbutton4_Callback(handles.pushbutton4, eventdata, handles);

% Go back and show frame
ShowFrameOnAxis(handles);


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rej = handles.settings.filter_by(handles.TMS, handles.settings.id.Trej_other);
disp(rej);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

var = get(hObject, 'String');
split = strfind(var,':');
min = str2double(var(1:split-1));
max = str2double(var(split+1:end));
if CheckRange(min, max)
    
    % Set new MEP window in TMS matrix
    handles.TMS(handles.settings.currentframe, handles.settings.id.Taonset) = min;
    handles.TMS(handles.settings.currentframe, handles.settings.id.Tmoffset) = max;
    
    % Update handles structure
    guidata(hObject, handles);
    
    % Save
    pushbutton4_Callback(handles.pushbutton4, eventdata, handles);
    
    % Reset string on edit2
    handles.edit2.String = 'Min:Max';
    set(hObject, 'Enable', 'off');
    drawnow;
    set(hObject, 'Enable', 'on');
    
else 
    warn = sprintf('Invalid inputs. Setting must be two integers separated by a colon. \nExamples: 1:500, 5:100, 60:90');
    warning(warn);
end

% Re-display the current frame with new MEP offset
ShowFrameOnAxis(handles);


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


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
contents = cellstr(get(hObject,'String'));
val = contents{get(hObject,'Value')};
switch val
    
    case 'No MEP (< 0.01)'
        handles.TMS_current = handles.TMS_temp.nomep;
    case 'Baseline too noisy (>0.01)'
        handles.TMS_current = handles.TMS_temp.absbase;
    case 'No Pulse'
        handles.TMS_current = handles.TMS_temp.nopulse;
    case 'MEP maxed out (negatively)'
        handles.TMS_current = handles.TMS_temp.minex;
    case 'MEP maxed out (postively)'
        handles.TMS_current = handles.TMS_temp.maxex;
    case 'Other'
        handles.TMS_current = handles.TMS_temp.other;
    case 'Accepted'
        handles.TMS_current = handles.TMS_temp.accepted;
    case 'All'
        handles.TMS_current = handles.TMS_temp.all;
    case 'Rejected'
        handles.TMS_current = handles.TMS_temp.rejected;
        
end

% Reset the countindex and get current frame
handles = resetCountIndex(handles);

% Unset focus
set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');

% Update handles structure
guidata(hObject, handles);

% Show frame
ShowFrameOnAxis(handles);


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

% Update handles structure
guidata(hObject, handles);
    

% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get export file
[filen, filep] = uiputfile;
if all(filen ~= 0) || all(filep ~= 0)
    
    [~,~,ext] = fileparts(filen); % get chosen filename's extension
    if strcmp(ext,'.mldatx'); filen = strrep(filen, '.mldatx', '.mat'); end
    ffile = fullfile(filep, filen);

    % Unwrap data to save in export file
    settings = handles.settings;
    TMS = handles.export;
    tms = handles.tms;

    % Save
    save(ffile, 'settings', 'TMS', 'tms');
    
end

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
contents = cellstr(get(hObject,'String'));
val = contents{get(hObject,'Value')};
switch val
    
    case 'No MEP (< 0.01)'
        handles.export = handles.TMS_temp.nomep;
    case 'Baseline too noisy (>0.01)'
        handles.export = handles.TMS_temp.absbase;
    case 'No Pulse'
        handles.export = handles.TMS_temp.nopulse;
    case 'MEP maxed out (negatively)'
        handles.export = handles.TMS_temp.minex;
    case 'MEP maxed out (postively)'
        handles.export = handles.TMS_temp.maxex;
    case 'Other'
        handles.export = handles.TMS_temp.other;
    case 'Accepted'
        handles.export = handles.TMS_temp.accepted;
    case 'All'
        handles.export = handles.TMS_temp.all;
    case 'Rejected'
        handles.export = handles.TMS_temp.rejected;
        
end

% Unset focus
set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');

% Update handles structure
guidata(hObject, handles);


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
var = get(hObject, 'String');
split = strfind(var,':');
min = str2double(var(1:split-1));
max = str2double(var(split+1:end));
if CheckRange(min, max)
    answer = GlobalMEPConfirmation;
    if strcmpi(answer, 'Yes')
        
        % Set new MEP window in all frames of TMS matrix
        handles.TMS(:, handles.settings.id.Taonset) = min;
        handles.TMS(:, handles.settings.id.Tmoffset) = max;
        
        % Show new frame
        ShowFrameOnAxis(handles)
        
    end
else 
    warn = sprintf('Invalid inputs. Setting must be two integers separated by a colon. \nExamples: 1:500, 5:100, 60:90');
    warning(warn);
end

% Unset focus
set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');

% Update handles structure
guidata(hObject, handles);

% Reset string on edit3
handles.edit3.String = 'Min:Max';


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
