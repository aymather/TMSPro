function [settings, TMS, tms] = TMSPro_init

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
    
    % Open initialization dialogue
    files = TMSPro_CreateProjGUI;
    
    % Define your project parameters
    if isfield(files, 'inputFile') || isfield(files, 'outputFile')
        
        % get input and open file
        settings.files.infile = files.inputFile;
        settings.files.outfile = files.outputFile;
        load(settings.files.infile);

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
        
        % Create main matrix
        TMS = zeros(settings.cframes,15);
        
        % Trigger Method
        settings.triggermethod = -999;
        
        % Populate TMS matrix
        for it = 1:settings.cframes

            % running index
            TMS(it,settings.id.Tnum) = double(it);

            % trial numbers in tms file
            TMS(it,settings.id.Ttrial) = tms.data.frameinfo(it).number;

            % RMS baseline
            thisdata = tms.data.values(:,1,it);
            baselinesamples = settings.baseline*settings.srate/1000;
            TMS(it,settings.id.Tbase) = double(rms(thisdata(1:baselinesamples)));

            % MEP
            % find artifact onset
            if settings.triggermethod == -999
                artonset = find(abs(thisdata) > max(thisdata(1:baselinesamples))*settings.artfactor,1,'first');
            else artonset = settings.triggermethod*settings.srate/1000;
            end

            % find end of MEP
            if settings.triggermethod == -999
                mepoffset = length(thisdata) - find(fliplr(thisdata') > max(thisdata(1:baselinesamples))*2,1,'first');
                mepoffset = min([mepoffset artonset+settings.maxmeplength*settings.srate/1000]); % either 50 ms post artifact or above criterion (whichever is lower)
            else mepoffset = artonset+settings.maxmeplength*settings.srate/1000;
            end
            % compute MEP (from artonset + 10 ms)
            MEP = thisdata(artonset+10*settings.srate/1000 : mepoffset);
            if ~isempty(artonset) && ~isempty(mepoffset) && ~isempty(MEP)
                TMS(it,settings.id.Taonset) = artonset;
                TMS(it,settings.id.Tmoffset) = mepoffset;
                TMS(it,settings.id.Tmin) = min(MEP);
                TMS(it,settings.id.Tmax) = max(MEP);
                TMS(it,settings.id.Tmep) = TMS(it,settings.id.Tmax) - TMS(it,settings.id.Tmin);
            else
                TMS(it,settings.id.Trej_nopulse) = 1; % no MEP rejection
            end

            % Exlcusion
            % More baseline criteria
            if TMS(it,settings.id.Tbase) > .1; TMS(it,settings.id.Trej_absbase) = 1; end
            % MEP
            if TMS(it,settings.id.Tmep) < .05; TMS(it,settings.id.Trej_nomep) = 1; end
            if TMS(it,settings.id.Tmin) < -2.99; TMS(it,settings.id.Trej_minex) = 1; end
            if TMS(it,settings.id.Tmax) > 2.99; TMS(it,settings.id.Trej_maxex) = 1; end

        end % of TMS trial loop
        
        % Save project to .mat file
        save(settings.files.outfile, 'settings', 'tms', 'TMS');
        
    elseif isfield(files, 'ExistingFile')
        
        % Load in existing data
        load(files.ExistingFile, 'settings', 'TMS', 'tms');
        
    end


end