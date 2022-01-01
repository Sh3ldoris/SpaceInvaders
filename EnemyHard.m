classdef EnemyHard < Enemy
    %ENEMYHARD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SHAPE = [1 4 3 3 4 1 2 0 2 1;0 0 1 3 4 4 3 2 1 0];
    end
    
    methods
        function obj = EnemyHard()
            obj@Enemy([1 4 3 3 4 1 2 0 2 1;0 0 1 3 4 4 3 2 1 0]);
        end
        
    end
end

