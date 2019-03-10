function settings = TMSPro_init(projType)

    % General settings
    settings.baseline = 90; % Baseline begins @ 90
    settings.plotlimits = [1 500]; % limits
    settings.artfactor = 2.5; % multiplicator for artifact identification (artfactor * max(baselinepoint));
    settings.maxmeplength = 75; % in ms
    
    % Matrix columns
    settings.id.Tnum = 1;
    settings.id.Ttrial = 2;
    settings.id.Tacc = 3;
    settings.id.Tbase = 4;
    settings.id.Taonset = 5;
    settings.id.Tmoffset = 6;
    settings.id.Tmin = 7;
    settings.id.Tmax = 8;
    settings.id.Tmep = 9;
    settings.id.Trej_nopulse = 10;
    settings.id.Trej_absbase = 11;
    settings.id.Trej_nomep = 12;
    settings.id.Trej_minex = 13;
    settings.id.Trej_maxex = 14;
    settings.id.Trej_manual = 15;
    
    % Reasons for rejections
    settings.rej.nopulse = 'No pulse';
    settings.rej.basenoisy = 'Baseline too noisy (>0.01)';
    settings.rej.nomep = 'NoMEP (<0.01)';
    settings.rej.mepmaxneg = 'MEP maxed out (negatively)';
    settings.rej.mepmaxpos = 'MEP maxed out (positively)';
    settings.rej.manual = 'Manual';
    
    % Define your project parameters
    if strcmp(projType, 'Create New Project')
        
        % get input and open file
        [filen,filep] = uigetfile('*.mat');
        load(fullfile(filep,filen));

        % make variable names
        variables = whos;
        varnames = {variables(~cellfun(@isempty,strfind({variables.name},'S'))).name};
        wavedata = varnames{~cellfun(@isempty,strfind(varnames,'wave'))};
        
        % Create data struct
        tms.data = eval(wavedata);
        
        % Sample rate
        settings.srate = 1/tms.data.interval;
        
        % Number of frames
        settings.cframes = tms.data.frames;
        
    end


end