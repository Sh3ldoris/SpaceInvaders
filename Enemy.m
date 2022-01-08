classdef Enemy
    %ENEMY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=private)
        FIGURE_WIDTH = 700;
        FIGURE_HEIGHT = 400;
        ENEMY_W = 30; 
        ENEMY_H = 30; 
        STEP = 10;
        INIT_SHAPE;
        xScale;
        yScale;
        actualShape;
        enemyPos;
        type;
        life;
    end
    
    methods
        function obj = Enemy(shape, enemyType, life)
            obj.life = life;
            obj.INIT_SHAPE = shape;
            obj.type = enemyType;
            obj.xScale = obj.ENEMY_W / max(obj.INIT_SHAPE(1,:));
            obj.yScale = obj.ENEMY_H / max(obj.INIT_SHAPE(2,:));
            obj.actualShape = [obj.INIT_SHAPE(1,:) .* obj.xScale; obj.INIT_SHAPE(2,:) .* obj.yScale];
            y = randi([0, obj.FIGURE_HEIGHT - obj.ENEMY_H]);
            obj.enemyPos = [obj.FIGURE_WIDTH y];
        end

        function ship = getEnemy(obj)
            ship = [obj.actualShape(1,:) + obj.enemyPos(1); obj.actualShape(2,:) + obj.enemyPos(2)];
        end

        function obj = move(obj) 
            obj.enemyPos(1) = obj.enemyPos(1) - obj.STEP;
        end

        function obj = shoted(obj) 
            obj.life = obj.life - 1;
        end

        function result = isDead(obj) 
            result = obj.life <= 0;
        end

        function width = getWidth(obj)
            width = obj.ENEMY_W;
        end

        function height = getHeight(obj)
            height = obj.ENEMY_H;
        end

        function pos = getPosition(obj)
            pos = obj.enemyPos;
        end

        function peek = getPeek(obj)
            peek = [obj.enemyPos(1) + obj.ENEMY_W; obj.enemyPos(2) + (obj.ENEMY_H / 2)];
        end

        function type = getType(obj)
            type = obj.type;
        end
    end
end

