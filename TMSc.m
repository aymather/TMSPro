% Frontend for TMS check
% Jan R. Wessel 2014; jwessel@ucsd.edu

clear; clc;
disp('Manual TMS checking routine: Frontend (jan-wessel@uiowa.edu)');

% settings
baseline = 90; % adapt based on experiment
manual = []; % this function is only for manual rejections

% get input and open file
[filen,filep] = uigetfile('*.mat');
load(fullfile(filep,filen));
cd(filep);

% make variable names
variables = whos;
varnames = {variables(~cellfun(@isempty,strfind({variables.name},'S'))).name};
wavedata = varnames{~cellfun(@isempty,strfind(varnames,'wave'))};

% execute
eval(['TMS = TMScheck(' wavedata ',baseline,manual);']);

% save
[filen,filep] = uiputfile(filen);
save(fullfile(filep,filen),'TMS');