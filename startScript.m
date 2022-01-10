function playGame
    BLUE = [.3, .3, .9];
    GREEN = [.1, .7, .1];
    WHITE = [1, 1, 1];
    RED = [.9, .3, .3];

    FIGURE_WIDTH = 700;
    FIGURE_HEIGHT = 400;
    SHIP_LINE_WIDTH = 2;
    BULLET_SIZE = 5;
    AXIS_COLOR = [.15, .15, .15];
    SPACE_COLOR = BLUE;
    BULLET_FACE_COLOR = [.1, .7, .1];
    BULLET_EDGE_COLOR = [.1, .7, .1];

    FONT = 'Courier';
    TITLE_TEXT = 21;
    LARGE_TEXT = 18;
    SMALL_TEXT = 14;
        
    spaceShip = SpaceShip;
    scoreFileHandler = ScoreFileHandler;
    counter = 0;
    counterDifficulty = 0;
    gameOver = false;
    quitGame = false;
    paused = false;
    intro = true;
    fig = [];
    shipPlot = [];
    bulletsPlot = [];
    enemyPlots = [];
    enemyHardPlots = [];
    heartPlots = [];
    enemiesEz = EnemyEz.empty;
    enemiesHard = EnemyHard.empty;
    bullets = [];
    enemyMode = 1; % 1-eazy enemies, 2-harder enem
    score = 0;

    axisTitle = [];
    username = [];
   

    function createFigure
            scrsz = get(0,'ScreenSize');
            fig = figure('Position',[(scrsz(3)-FIGURE_WIDTH)/2, ...
                                        (scrsz(4)-FIGURE_HEIGHT)/2, ...
                                        FIGURE_WIDTH, ...
                                        FIGURE_HEIGHT]);

            set(fig, 'menubar', 'none');
            set(fig, 'Resize', 'off');
            set(fig,'CloseRequestFcn',@win_close);
            set(fig, 'keypressfcn', @key_down);

            playGround = axes();
            axis([0 FIGURE_WIDTH 0 FIGURE_HEIGHT]);
            axis manual;

            set(playGround, 'color', AXIS_COLOR, 'YTick', [], 'XTick', []);

            axisTitle = title('');
            set(axisTitle, 'FontName', FONT,'FontSize', LARGE_TEXT);
            set(axisTitle, 'Color', GREEN);
            
            
            hold on;
    end

    function createPlots
            shipPlot = plot(NaN,NaN, '-');
            set(shipPlot, 'LineWidth', SHIP_LINE_WIDTH);
            set(shipPlot, 'color', SPACE_COLOR);

            bulletsPlot = plot(NaN,NaN, 'd');
            set(bulletsPlot, 'MarkerFaceColor', BULLET_FACE_COLOR);
            set(bulletsPlot, 'MarkerEdgeColor', BULLET_EDGE_COLOR);
            set(bulletsPlot, 'MarkerSize', BULLET_SIZE);
            set(bulletsPlot, 'LineStyle', 'None');

            for i = 1:spaceShip.getLifes
                tmpPlot = plot(NaN,NaN, '-');
                set(tmpPlot, 'LineWidth', SHIP_LINE_WIDTH);
                set(tmpPlot, 'color', RED);
                heartPlots(end + 1) = tmpPlot;
            end
    end

    function win_close(src, event)
        if (isa(gcbf,'ui.figure'))
            % Convert GBT1.5 figure to a double.
            delete(double(gcbf));
        else
            delete(gcbf);
        end
        quitGame = true;
        intro = false;
    end

    function key_down(src, event)
        %disp(event.Key);
        switch event.Key
            case 'uparrow',  spaceShip = spaceShip.moveShipUp;
            case 'downarrow', spaceShip = spaceShip.moveShipDown;
            case 'space'
                if intro == true
                    intro = false;
                else 
                    newBullet = spaceShip.getPeek;
                    bullets(1, end+1) = newBullet(1);
                    bullets(2, end) = newBullet(2);
                end
            case 'q'
                win_close; %% end game

            case 'r'
                if gameOver
                    reset;
                end

            case 'p'
                paused = ~paused;

            case 's'
                if paused
                    saveGame;
                end

            case 'l'
                if intro
                    clear spaceShip;
                    load("Hej.mat");
                end
        end
    end

    function reset
        delete(bulletsPlot);
        delete(enemyPlots(:));
        delete(enemyHardPlots(:));  
        delete(heartPlots(:));
        delete(shipPlot);

        spaceShip = SpaceShip;
        counter = 0;
        counterDifficulty = 0;
        gameOver = false;
        quitGame = false;
        paused = false;
        shipPlot = [];
        bulletsPlot = [];
        enemyPlots = [];
        enemyHardPlots = [];
        heartPlots = [];
        enemiesEz = EnemyEz.empty;
        enemiesHard = EnemyHard.empty;
        bullets = [];
        enemyMode = 1; % 1-eazy enemies, 2-harder enem
        score = 0;

        createPlots;
    end

    function saveGame
        save("Hej.mat", "spaceShip");
        save("Hej.mat", "score", '-append');
    end

    function updatePlots
       currentShip = spaceShip.getShip;
       set(shipPlot, 'XData', currentShip(1,:), 'YData', currentShip(2,:));

       if size(bullets, 2) > 0
            set(bulletsPlot, 'XData', bullets(1,:), 'YData', bullets(2,:));
       else
            set(bulletsPlot, 'XData', NaN, 'YData', NaN);
       end

       for i = 1:length(enemiesEz)
           currentEnemy = enemiesEz(i).getEnemy;
           set(enemyPlots(i), ...
               'XData', currentEnemy(1,:), ...
               'YData', currentEnemy(2,:));
       end

       for i = 1:length(enemiesHard)
           currentEnemy = enemiesHard(i).getEnemy;
           set(enemyHardPlots(i), ...
               'XData', currentEnemy(1,:), ...
               'YData', currentEnemy(2,:));
       end

       for i = 1:length(heartPlots)
           currentHeart = spaceShip.getHearthShape;
            currentHeart(2, :) = currentHeart(2,:) + ((i - 1) * 30);
            set(heartPlots(i), ...
               'XData', currentHeart(1,:) + 5, ...
               'YData', currentHeart(2,:) + 5);
       end


        scoreString = sprintf('score:%d', score);
        nameString = sprintf('Username:%s', username{:});
        set(axisTitle, 'String', [nameString, '   ', scoreString]);
    end

    function updateHealtPlot
        while spaceShip.getLifes < length(heartPlots)
            delete(heartPlots(end));
            heartPlots = heartPlots(:,1:end - 1);
        end
    end

    function showIntro
        intro = true;
        dText = [];

        x = FIGURE_WIDTH / 2;
        dText(1) = text(x, 330, "Space Invaders");
        dText(2) = text(x, 220, "Ovladanie pomocou sipok (hore/dolu)");
        dText(3) = text(x, 195, "Strelanie pomocou medzernika");
        dText(4) = text(x, 100, "Pre zaciatok stlacte medzernik");
        dText(5) = text(x, 75, "Pre ukoncenie stlacte q");
        


        for k = 1:length(dText)
            set(dText(k), 'HorizontalAlignment', 'Center');
            set(dText(k), 'FontName', FONT);

            set(dText(k), 'FontSize',SMALL_TEXT);
            set(dText(k), 'Color', WHITE);
        end
        set(dText(1), 'FontSize',TITLE_TEXT);
        set(dText(1), 'Color', BLUE);
        set(dText(1), 'fontweight', 'bold');

        set(dText(4), 'FontSize',12);
        set(dText(5), 'FontSize',12);

        while intro && ~quitGame
            pause(.25);
        end
        
        if (~quitGame) 
            delete(dText(:));
        end
    end

    function showGameOver
        dText = [];

        x = FIGURE_WIDTH / 2;
        dText(1) = text(x, 330, "Game Over");
        dText(2) = text(x, 220, "Pre reset stlacte r");
        dText(3) = text(x, 195, "Pre ukoncenie stlacte q");

        for k = 1:length(dText)
            set(dText(k), 'HorizontalAlignment', 'Center');
            set(dText(k), 'FontName', FONT);

            set(dText(k), 'FontSize',SMALL_TEXT);
            set(dText(k), 'Color', WHITE);
        end

        set(dText(1), 'FontSize',TITLE_TEXT);
        set(dText(1), 'Color', RED);
        set(dText(1), 'fontweight', 'bold');

        while ~quitGame && gameOver
            pause(.25);
        end

        if (~quitGame) 
            delete(dText(:));
        end
    end

    function showPause
        dText = [];

        x = FIGURE_WIDTH / 2;
        dText(1) = text(x, 330, "Paused");
        dText(2) = text(x, 220, "Pre pokračovanie stačte p");
        dText(3) = text(x, 195, "Pre ukoncenie stlacte q");

        for k = 1:length(dText)
            set(dText(k), 'HorizontalAlignment', 'Center');
            set(dText(k), 'FontName', FONT);

            set(dText(k), 'FontSize',SMALL_TEXT);
            set(dText(k), 'Color', WHITE);
        end

        set(dText(1), 'FontSize',TITLE_TEXT);
        set(dText(1), 'Color', RED);
        set(dText(1), 'fontweight', 'bold');

        while ~quitGame && paused
            pause(.25);
        end

        if (~paused) 
            delete(dText(:));
        end
    end

    function requestUserName
        username = inputdlg({'Zadajte svoje meno'}, 'Používateľské meno',[1 35], {''});
        disp(username{1});
    end

    function checkForColision
        i = length(enemiesEz);
        while i > 0
            currentenemy = enemiesEz(i);
            currentPos = currentenemy.getPosition;

            %Check colision with bullets
            j = size(bullets, 2);
            while j > 0
                
                if bullets(1, j) > currentPos(1) && ...
                   bullets(1, j) < currentPos(1) + currentenemy.getWidth && ...
                   bullets(2, j) > currentPos(2) && ...
                   bullets(2, j) < currentPos(2) + currentenemy.getHeight
                    %Decrease enemys life
                    currentenemy = currentenemy.shoted();
                    removeBullet(j);
                    enemiesEz(i) = currentenemy;
                    score = score + 5;
                end
                j = j - 1;
            end

            i = i - 1;
        end

        i = length(enemiesHard);
        while i > 0
            currentenemy = enemiesHard(i);
            currentPos = currentenemy.getPosition;

            %Check colision with bullets
            j = size(bullets, 2);
            while j > 0
                
                if bullets(1, j) > currentPos(1) && ...
                   bullets(1, j) < currentPos(1) + currentenemy.getWidth && ...
                   bullets(2, j) > currentPos(2) && ...
                   bullets(2, j) < currentPos(2) + currentenemy.getHeight
                    currentenemy = currentenemy.shoted();
                    removeBullet(j);
                    enemiesHard(i) = currentenemy;
                    score = score + 10;
                end
                j = j - 1;
            end

            i = i - 1;
        end


        removeDeadEnemies;
    end

    function moveEnemies
        k = length(enemiesEz);
        while k > 0
            enemiesEz(k) = enemiesEz(k).move;

            currentEnemy = enemiesEz(k).getEnemy;
            enemyX = min(currentEnemy(1,:));
            width = enemiesEz(k).getWidth;
            if enemyX < 50
                spaceShip = spaceShip.decreaseLifes;
                removeEnemy(1, k);
            end

            k = k - 1;
        end

        k = length(enemiesHard);
        while k > 0
            enemiesHard(k) = enemiesHard(k).move;

            currentEnemy = enemiesHard(k).getEnemy;
            enemyX = min(currentEnemy(1,:));
            width = enemiesHard(k).getWidth;
            if enemyX < 50
                spaceShip = spaceShip.decreaseLifes;
                removeEnemy(2, k);
            end

            k = k - 1;
        end
    end

    function moveBullets
        if size(bullets, 2) > 0
            bullets(1,:) = bullets(1,:) + 10;
        end
        
        i = size(bullets, 2);
        while i > 0
            if bullets(1, i) > 600
                removeBullet(i);
            end
            i = i - 1;
        end
    end

    function removeDeadEnemies
        i = length(enemiesEz);
        while i > 0
            currentenemy = enemiesEz(i);
            if currentenemy.isDead 
                removeEnemy(currentenemy.getType, i);
            end

            i = i - 1;
        end

        i = length(enemiesHard);
        while i > 0
            currentenemy = enemiesHard(i);
            if currentenemy.isDead 
                removeEnemy(currentenemy.getType, i);
            end

            i = i - 1;
        end
    end

    function generateEzEnemy
        enemiesEz(end + 1) = EnemyEz;

        tempPlot = plot(NaN, NaN, '-');
        set(tempPlot, 'LineWidth', SHIP_LINE_WIDTH);
        set(tempPlot, 'Color', [.9, .4, .0]);
        
        enemyPlots(end+1) = tempPlot;
    end

    function generateHardEnemy
        enemiesHard(end + 1) = EnemyHard;

        tempPlot = plot(NaN, NaN, '-');
        set(tempPlot, 'LineWidth', SHIP_LINE_WIDTH);
        set(tempPlot, 'Color', [.9, .4, .0]);
        
        enemyHardPlots(end+1) = tempPlot;
    end

    function generateEnemy
        switch enemyMode
            case 1
                generateEzEnemy;
            case 2
                generateHardEnemy;
        end
    end

    function removeEzEnemy(index)
        delete(enemyPlots(index));
        enemyPlots = [enemyPlots(:,1:index-1), enemyPlots(:,index+1:end)];
        enemiesEz = [enemiesEz(:,1:index-1), enemiesEz(:,index+1:end)];
    end

    function removeHardEnemy(index)
        delete(enemyHardPlots(index));
        enemyHardPlots = [enemyHardPlots(:,1:index-1), enemyHardPlots(:,index+1:end)];
        enemiesHard = [enemiesHard(:,1:index-1), enemiesHard(:,index+1:end)];
    end

    function removeEnemy(enemyType, index)
        switch enemyType
            case 1
                removeEzEnemy(index);
            case 2
                removeHardEnemy(index);
        end

        updateHealtPlot;
    end

    function removeBullet(index)
        bullets = [bullets(:,1:index-1), bullets(:,index+1:end)];
    end

    %------------ GAME LOOP ---------------

    createFigure;
    createPlots;

    reset;

    requestUserName;
    showIntro;

    while ~quitGame
        checkForColision;
        moveEnemies;
        moveBullets;
        updatePlots;

        counter = counter + 1;
        f = mod(counter, 15);        
        if f == 0
            generateEnemy;
            score = score + 1;
            counterDifficulty = counterDifficulty + 1;
            d = mod(counterDifficulty, 5);
            if d == 0 && enemyMode < 2
                enemyMode = enemyMode + 1; 
            end
        end

        if spaceShip.getLifes == 0
            gameOver = true;
        end

        if gameOver
            showGameOver;
        end

        if paused
            showPause;
        end

        pause(.25);
    end
    
    scoreFileHandler.saveScoreData(username{:}, score);
end