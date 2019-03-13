function output = TMScheck(tmsdata,baseline,manual,triggermethod)

% baseline in ms
% tmsinfo is _ChX
% tmsdata is _wave_data
% triggermethod -999 means detection, else means triggers is at time XXms

if nargin < 3 || isempty(manual);
    check = 0;
else check = 1;
end
if nargin < 4 || isempty(triggermethod);
    triggermethod = -999;
end

% settings
plotlimits = [1 500]; % in ms
artfactor = 2.5; % multiplicator for artifact identification (artfactor * max(baselinepoint));
maxmeplength = 75; % in ms

% TMS matrix indices
Tnum = 1;
Ttrial = 2;
Tacc = 3;
Tbase = 4;
Taonset = 5;
Tmoffset = 6;
Tmin = 7;
Tmax = 8;
Tmep = 9;
Trej_nopulse = 10;
Trej_absbase = 11;
Trej_nomep = 12;
Trej_minex = 13;
Trej_maxex = 14;
Trej_manual = 15;

% reasons for rejection
rejreasons = { ...
    'No pulse', ... % i.e. no artifact found
    'Baseline too noisy (>0.01)', ...
    'No MEP (< 0.01)', ...
    'MEP maxed out (negatively)', ...
    'MEP maxed out (postively)',...
    'Manual' ...
    };
    
% make data array
tms.data = tmsdata;

% get params
srate = 1/tms.data.interval;
tmstrials = tms.data.frames;
    
% reset
TMS = zeros(tmstrials,15);
    
% make TMS matrix
for it = 1:tmstrials

    % running index
    TMS(it,Tnum) = double(it);
    
    % trial numbers in tms file
    TMS(it,Ttrial) = tms.data.frameinfo(it).number;

    % RMS baseline
    thisdata = tms.data.values(:,1,it);
    baselinesamples = baseline*srate/1000;
    TMS(it,Tbase) = double(rms(thisdata(1:baselinesamples)));
    
    % MEP
    % find artifact onset
    srate = 1/tmsdata.interval;
    if triggermethod == -999
        artonset = find(abs(thisdata) > max(thisdata(1:baselinesamples))*artfactor,1,'first');
    else artonset = triggermethod*srate/1000;
    end
        
    % find end of MEP
    if triggermethod == -999
        mepoffset = length(thisdata) - find(fliplr(thisdata') > max(thisdata(1:baselinesamples))*2,1,'first');
        mepoffset = min([mepoffset artonset+maxmeplength*srate/1000]); % either 50 ms post artifact or above criterion (whichever is lower)
    else mepoffset = artonset+maxmeplength*srate/1000;
    end
    % compute MEP (from artonset + 10 ms)
    MEP = thisdata(artonset+10*srate/1000 : mepoffset);
    if ~isempty(artonset) && ~isempty(mepoffset) && ~isempty(MEP)
        TMS(it,Taonset) = artonset;
        TMS(it,Tmoffset) = mepoffset;
        TMS(it,Tmin) = min(MEP);
        TMS(it,Tmax) = max(MEP);
        TMS(it,Tmep) = TMS(it,Tmax) - TMS(it,Tmin);
    else
        TMS(it,Trej_nopulse) = 1; % no MEP rejection
    end

    % Exlcusion
    % More baseline criteria
    if TMS(it,Tbase) > .1; TMS(it,Trej_absbase) = 1; end
    % MEP
    if TMS(it,Tmep) < .05; TMS(it,Trej_nomep) = 1; end
    if TMS(it,Tmin) < -2.99; TMS(it,Trej_minex) = 1; end
    if TMS(it,Tmax) > 2.99; TMS(it,Trej_maxex) = 1; end

end % of TMS trial loop

% Manual
if check == 1
    TMS(manual,Trej_manual) = 1;
end

if check == 0

    h = figure('Position',[1 1 1000 500]);
    for it = 1:size(TMS,1)

        % make
        figure(h); clf; hold on;
        title([ 'Trial ' num2str(it)]);

        % line
        l = line(1:length(tms.data.values(:,1,it)),tms.data.values(:,1,it),'LineWidth',1,'Color',[0 0 0.5]);

        % artifact?
        rejs = TMS(it,Trej_nopulse:Trej_maxex);
        if sum(rejs) > 0
            set(l,'Color',[1 0 0]);
            title({['Trial ' num2str(it) ', \color[rgb]{1 0 0}REJECTED: ']; rejreasons{find(rejs,1,'first')}});
        else
            title({['Trial ' num2str(it) ', Amplitude: ' num2str(TMS(it,Tmep)) ' mV. \color[rgb]{0 0.5 0}accepted' ];''});
        end

        % axes
        if TMS(it,Trej_nomep) == 0
            set(gca,'YTick',[TMS(it,Tmin) TMS(it,Tmax)],'YGrid','on');
            ylabel(['MEP amplitude (mV)']);
        end
        if TMS(it,Trej_nomep) == 0 && TMS(it,Trej_nopulse) == 0
            set(gca,'XTick',[TMS(it,Taonset)+10*srate/1000 TMS(it,Tmoffset)],'Xgrid','on');
            xlabel(['time (samples), Rate: ' num2str(srate) ' Hz']);
        end
        set(gca,'YLim',[min(TMS(:,Tmin)) max(TMS(:,Tmax))]);
        set(gca,'YLim',[-2 2]);
        set(gca,'XLim',plotlimits*srate/1000);

        pause

    end % of TMS trial loop
    close(h);

end % of visual check
output = TMS;