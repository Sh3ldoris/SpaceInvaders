function playGame
    FIGURE_WIDTH = 700;
    FIGURE_HEIGHT = 400;
    SHIP_LINE_WIDTH = 2;
    AXIS_COLOR = [0, 0, 0];
    SPACE_COLOR = [.3, .3, .9];
        
    spaceShip = SpaceShip;
    fig = [];
    shipPlot = [];


    function createFigure
            scrsz = get(0,'ScreenSize');
            fig = figure('Position',[(scrsz(3)-FIGURE_WIDTH)/2, ...
                                        (scrsz(4)-FIGURE_HEIGHT)/2, ...
                                        FIGURE_WIDTH, ...
                                        FIGURE_HEIGHT]);

            set(fig, 'menubar', 'none');
            set(fig, 'Resize', 'off');
            set(fig, 'keypressfcn', @key_down);

            playGround = axes();
            axis([0 FIGURE_WIDTH 0 FIGURE_HEIGHT]);
            axis manual;

            set(playGround, 'color', AXIS_COLOR, 'YTick', [], 'XTick', []);
        
            hold on;
    end

    function createPlots
            shipPlot = plot(NaN,NaN, '-');
            set(shipPlot, 'LineWidth', SHIP_LINE_WIDTH);
            set(shipPlot, 'color', SPACE_COLOR);
    end

    function key_down(src, event)
        switch event.Key
            case 'uparrow',  spaceShip = spaceShip.moveShipUp;
            case 'downarrow', spaceShip = spaceShip.moveShipDown;
        end
    end

    %------------ GAME LOOP ---------------

    createFigure;
    createPlots;


    while 1
       currentShip = spaceShip.getShip;
       set(shipPlot, 'XData', currentShip(1,:), 'YData', currentShip(2,:));
       pause(.025);
    end
end