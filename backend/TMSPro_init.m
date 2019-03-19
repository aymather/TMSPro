function [settings, TMS, tms] = TMSPro_init(data)

     % Define your project parameters
    if isfield(data, 'inputFile') && isfield(data, 'outputFile')

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
        settings.id.Trej_other = 15;

        % Get all trials that match a rejection criteria
        settings.filter_by = @(TMS, col) TMS(TMS(:,col) == 1,:);
        settings.get_accepted = @(TMS, cols) TMS(~all(TMS(:,cols) == 0,2) == 0,:);
        settings.get_rejected = @(TMS, cols) TMS(any(TMS(:,cols) == 1,2) == 1,:);

        % Reasons for rejections
        settings.rejreasons = { ...
            'No Pulse', ... % i.e. no artifact found
            'Baseline too noisy (>0.01)', ...
            'No MEP (< 0.01)', ...
            'MEP maxed out (negatively)', ...
            'MEP maxed out (postively)',...
            'Other' ...
            };
    
        % get input and open file
        settings.files.infile = data.inputFile;
        settings.files.outfile = data.outputFile;
        load(settings.files.infile);
        
        % make variable names
        variables = whos;
        varnames = {variables(~cellfun(@isempty,strfind({variables.name},'S'))).name};
        wavedata = varnames{~cellfun(@isempty,strfind(varnames,'wave'))};
        
        % Create data struct
        tms.data = eval(wavedata);
        
        % Sample rate
        settings.srate = 1/tms.data.interval;
        
        % General settings
        settings.baseline = data.baselinelength; % Baseline begins @ 90
        settings.plotlimitsx = data.plotlimitsx; % limits
        settings.artfactor = data.artifactfactor; % multiplicator for artifact identification (artfactor * max(baselinepoint));
        settings.maxmeplength = data.maxmeplength; % in ms
        settings.currentframe = 1; % init current frame
        settings.countindex = 1; % for scrolling through filters
        settings.artifactlength = data.artifactlength; % distance between peak of artifact and beginning of MEP
        settings.plotlimitsy = data.plotlimitsy; % vertical plot limits on normal plotting
        settings.minamplitude = data.minamplitude;
        
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
                TMS(it,settings.id.Taonset) = artonset + settings.artifactlength;
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
        
    elseif isfield(data, 'ExistingFile')
        
        % Load in existing data
        load(data.ExistingFile, 'settings', 'TMS', 'tms');
        
    end


end