function [ config ] = readConfig( file )

%Reads a config file and returns a config struct
%MAINTENANCE: This file must be updated to reflect parameter names.

%INTERNAL MAINTENANCE: If you add parameters which aren't strings or
%numbers, this must be reflected at POINT A

fid=fopen(file);

stringParams={'dirCode' 'dirSourcePCA' 'dirTargetPCA' 'dirSourceBitmaps' 'dirPCAModel' ...
    'sourceConf' 'targetConf' 'clusterRoot' 'localRoot' 'keypoints' 'dirOutput' 'dirBitmapsBeforeResize'...
    'dirResizedBitmaps','shareRoot','replicatedRoot','recursiveBitmapScan','replicatedClusterRoot'};

numericalParams={'h' 'w' 'models' 'PCs' 'maxWorkers' 'framesPerIdentity' 'autoGenPCAs' 'referenceModel' 'transform1' ...
    'transform1CaricCoeff', 'caricCoeff'};

arrayParams={'referenceFrames' 'frames'};

stringCellParams={'identities','referenceFrameFiles'};

param=1;
%Loop over lines:
while not(feof(fid))
    l=fgetl(fid);
    
    %Split on equals
    if not(l==-1)
        parts = regexp(l,'=','split');
        
        fields{param}=strtrim(parts{1});
        
        %POINT A:
        %If param is not in the list of string, numerical or array params,
        %error
        if (sum(strcmp(strtrim(parts{1}),stringParams)) +  sum(strcmp(strtrim(parts{1}),numericalParams))...
                +  sum(strcmp(strtrim(parts{1}),arrayParams)) + sum(strcmp(strtrim(parts{1}),stringCellParams))) ==0
            error(['The parameter "' strtrim(parts{1}) '" in file ' file ' is not valid; check capitalisation.']);
        end
        
        %If it's a numerical param
        if max(strcmpi(strtrim(parts{1}),numericalParams))==1
            contents{param}=str2num(strtrim(parts{2}));
            
        elseif max(strcmpi(strtrim(parts{1}),arrayParams))==1
            %If this param is an array
            tail=strtrim(parts{2});
            entries = regexp(tail,',','split');
            for j=1:size(entries,2)
                theArray(j)=str2num(entries{j});
            end
            contents{param}=theArray;
            %If the param is a string cell
        elseif max(strcmpi(strtrim(parts{1}),stringCellParams))==1
            tail=strtrim(parts{2});
            entries=regexp(tail,',','split');
            for j=1:size(entries,2)
                theCell{j}=entries{j};
            end
            
            contents{param}=theCell;
            %fields{param}=
            %param=param+1; %Increment for fields
            %Post-processing
            %Work out number of models
            %fields{param}='models';
            %contents{param}=size(contents{param-1},2);
        else
            %What?
            contents{param}=strtrim(parts{2});
        end
        
        
        param=param+1;
        
    end
end





config=cell2struct(contents,fields,2);

end

