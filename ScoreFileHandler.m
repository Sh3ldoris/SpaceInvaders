classdef ScoreFileHandler
    
    properties(SetAccess=private)
        SCORE_DIRECTORY = "scores";
        SCORE_FILE = "scores.csv";
    end
    
    methods
        function obj = ScoreFileHandler
            obj.SCORE_FILE = sprintf("%s", obj.SCORE_FILE{:});
        end

        function obj = saveScoreData(obj, username, score)
            %Change directory to the right dir (if doesnt exist create one)
            if ~exist(obj.SCORE_DIRECTORY, 'dir')
                mkdir(obj.SCORE_DIRECTORY);
            end
            cd(obj.SCORE_DIRECTORY);
            
            %Prepare data to save to the file
            dataToWrite = {username, score, datetime};
            
            %Save data on the top of the file
            if isfile(obj.SCORE_FILE)
                savedData = readcell(obj.SCORE_FILE,'Delimiter',';');
                %Saving max 5 scores at all
                if length(savedData) >= 5
                    savedData = savedData(1:4,:);
                end
                dataToWrite = vertcat(dataToWrite, savedData);
            end
            writecell(dataToWrite,obj.SCORE_FILE,'Delimiter',';');
            
            %Get back to the game directory
            cd ..;
        end
        
    end

    methods(Access = private)

    end
end

