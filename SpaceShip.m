classdef SpaceShip
    %SPACESHIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=private)        
        FIGURE_WIDTH = 700;
        FIGURE_HEIGHT = 400;
        SHIP_W = 40; 
        SHIP_H = 30; 
        STEP = 10;
        INIT_SHAPE = [0 1 2 4 2 1 0 0; ... %x values
                 1 0 1 2 3 4 3 1];    %y values

        HEART_INITSHAPE = [0 1 2 3 4 5 6 6 6 5 4 3 2 1 0 0 0;
                    3 2 1 0 1 2 3 4 5 6 6 5 6 6 5 4 3];
        heartWidth = 20;
        heartScale;
        HEART_SHAPE;

        xScale;
        yScale;
        actualShape;
        shipPos;
        lifes = 3;
        playerHealth = [];
    end
    
    methods
        function obj = SpaceShip
            %spaceship shape
            obj.xScale = obj.SHIP_W / max(obj.INIT_SHAPE(1,:));
            obj.yScale = obj.SHIP_H / max(obj.INIT_SHAPE(2,:));
            obj.actualShape = [obj.INIT_SHAPE(1,:) .* obj.xScale; obj.INIT_SHAPE(2,:) .* obj.yScale];
            obj.shipPos = [50 floor(400 / 2)];

            %heart shape
            obj.heartScale = obj.heartWidth / max(obj.HEART_INITSHAPE(1,:));
            obj.HEART_SHAPE = [obj.HEART_INITSHAPE(1,:) .* obj.heartScale; obj.HEART_INITSHAPE(2,:) .* obj.heartScale];
        end

        %Get the polynom of ship in current position
        function ship = getShip(obj)
            ship = [obj.actualShape(1,:) + obj.shipPos(1); obj.actualShape(2,:) + obj.shipPos(2)];
        end

        function obj = moveShipUp(obj) 
            if (obj.shipPos(2) >= obj.FIGURE_HEIGHT - obj.SHIP_H)
               obj.shipPos(2) = obj.FIGURE_HEIGHT - obj.SHIP_H;
            else 
                obj.shipPos(2) = obj.shipPos(2)+obj.STEP;
            end
        end

        function obj = moveShipDown(obj) 
            if (obj.shipPos(2) <= 0)
               obj.shipPos(2) = 0;
            else 
                obj.shipPos(2) = obj.shipPos(2)-obj.STEP;
            end
        end

        function obj = decreaseLifes(obj)
            obj.lifes = obj.lifes - 1;
        end

        %Return peek of the ship
        %Starting position [x,y] for the bullet
        function peek = getPeek(obj)
            peek = [obj.shipPos(1) + obj.SHIP_W; obj.shipPos(2) + (obj.SHIP_H / 2)];
        end

        function lifes = getLifes(obj)
            lifes = obj.lifes;
        end

        function shape = getHearthShape(obj)
            shape = obj.HEART_SHAPE;
        end
    end
end

