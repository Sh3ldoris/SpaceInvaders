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
        xScale;
        yScale;
        actualShape;
        shipPos;
    end
    
    methods
        function obj = SpaceShip
            obj.xScale = obj.SHIP_W / max(obj.INIT_SHAPE(1,:));
            obj.yScale = obj.SHIP_H / max(obj.INIT_SHAPE(2,:));
            obj.actualShape = [obj.INIT_SHAPE(1,:) .* obj.xScale; obj.INIT_SHAPE(2,:) .* obj.yScale];
            obj.shipPos = [50 floor(400 / 2)];
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

        %Return peek of the ship
        %Starting position [x,y] for the bullet
        function peek = getPeek(obj)
            peek = [obj.shipPos(1) + obj.SHIP_W; obj.shipPos(2) + (obj.SHIP_H / 2)];
        end
    end
end

