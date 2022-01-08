classdef EnemyEz < Enemy
    
    properties
      SHAPE = [0 1 2 3 3 2 1 0 1 1 0;1 0 0 1 2 3 3 2 2 1 1];
    end
    
    methods
        function obj = EnemyEz()
            obj@Enemy([0 1 2 3 3 2 1 0 1 1 0;1 0 0 1 2 3 3 2 2 1 1], 1, 1);
        end
        
    end
end

