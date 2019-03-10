% If you have programmed your experiment in a way in which a column in your
% trialseq structure has the onsets of where exactly the TMS should be
% (i.e., time 0 in Psychtoolbox is exactly the time of the first TMS sweep
% trigger in the ENTIRE STUDY (can't have pre-experiment baselines in the
% same CED file), then this function will split your CED .mat file into
% baseline (onsets not present in trialseq variable) and non-baseline
% trials (onsets present in trialseq variable). It will also overwrite the
% trialnumber values in the nonbaseline file with the according
% trialnumbers in the trialseq file. This will identify if trials are
% missing as well.
% YOU HAVE TO DEFINE THE COLUMN THAT HAS YOUR ONSET
onsetcolumn = 6;
% YOU HAVE TO ALSO DEFINE THE NAME OF YOUR TRIALSEQ TABLE
trialseq_varname = 'trialseq';

% IO
% get input and open file
[filen,filep] = uigetfile('*.mat','Open behavior file');
load(fullfile(filep,filen));
[filen,filep] = uigetfile('*.mat','Open TMS file');
load(fullfile(filep,filen));
cd(filep);

% make variable names
variables = whos;
varnames = {variables(~cellfun(@isempty,strfind({variables.name},'S'))).name};
wavedata = varnames{~cellfun(@isempty,strfind(varnames,'wave'))};

% make trialseq variable
eval(['trialseq = ' trialseq_varname ';']);

% RUN
slack = .5; % in secs
eval(['DATA = ' wavedata ';']);
onsets = [DATA.frameinfo.start]';
onsets = onsets - onsets(1);

% find bl and nonbl trials
bl = []; nobl = []; cnt = 0; bcnt = 0;
for it = 1:size(onsets,1)
    
    findtrial = find(abs(onsets(it)-trialseq(:,onsetcolumn))<=slack);
    if ~isempty(findtrial)
        cnt = cnt + 1;
        nobl(cnt,1) = findtrial;
        nobl(cnt,2) = it;
        DATA.frameinfo(it).number = findtrial;
    else
        bcnt = bcnt + 1;
        bl(bcnt) = it;
    end
    
end

% make separate vars: NOBL
NOBL = DATA;
NOBL.frameinfo(bl) = []; % delete bl
NOBL.values(:,:,bl) = []; % delete bl
NOBL.frames = size(nobl,1);
% make separate vars: BL
BL = DATA;
BL.frameinfo(nobl(:,2)) = []; % delete bl
BL.values(:,:,nobl(:,2)) = []; % delete bl
BL.frames = length(bl);

% IO: NOBL
eval([wavedata ' = NOBL;']);
[filen,filep] = uiputfile(filen,'Save non-baseline trials');
save(fullfile(filep,filen),wavedata);
% IO: BL
eval([wavedata ' = BL;']);
[filen,filep] = uiputfile(filen,'Save baseline trials');
save(fullfile(filep,filen),wavedata);