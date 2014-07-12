//
//  Grid.m
//  GameOfLife
//
//  Created by Kendall Agbulos on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

//these variables canno be changed
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid{
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}

-(void)onEnter
{
    [super onEnter];
    [self setupGrid];
    
    //accept touches on the grid
    self.userInteractionEnabled = YES;
}

-(void)setupGrid
{
    //divide the grids size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    //initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
    //initialize creatures
    for (int i = 0; i < GRID_ROWS; i++) {
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0,0);
            creature.position = ccp(x,y);
            [self addChild:creature];
            
            //this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            
            //makes creatures visible to test this method, remove this once we know we have filled the grid properly
            //creature.isAlive = YES;
            
            x+= _cellWidth;
        }
        
        y+= _cellHeight;
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    //get the Creature at that location
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    //invert its state - kill it if its alive, bring it to life if its dead.
    creature.isAlive = !creature.isAlive;
}

-(Creature *)creatureForTouchPosition:(CGPoint)touchPosition
{
    //get the row and column that was touched, return the creature inside the corresponding cell
    int row = touchPosition.y/_cellHeight;
    int column = touchPosition.x/_cellWidth;
    
    //return the creature
    return _gridArray[row][column];
}


-(void) evolveStep
{
    //update each creatures neighbor count
    [self countNeighbors];
    
    //update each creatures state
    [self updateCreatures];
    
    //update the generation to the labels text will display the correct generation
    _generation++;
    
}

-(void) countNeighbors
{
    //iterate through the rows
    //note that the NSArray has a method called count that will return the number of elements in the array
    for (int i = 0; i < [_gridArray count] ; i++ ) {
        //iterate through all columns for a given row
        for (int j = 0; j < [_gridArray[i] count]; j++) {
            //access the creature in the cell that corresponds to the current row/col
            Creature *currentCreature = _gridArray[i][j];
            
            //remember that every creature has a living neighbors propety that we created earlier
            currentCreature.livingNeighbors = 0;
            
            //now examine every cell around the current one
            
            //go through the row on top of the cell, the row the the cell is in and the row that is past the cell
            for (int x = (i-1); x<=(i+1); x++) {
                //go through the column to the left of the cell, the one th cell is in, and the one to the right of the cell
                for (int y = (j-1); y <= (j+1); y++) {
                    //check that the cell were checking isnt off the screen
                    BOOL isIndexValid;
                    isIndexValid = [self isIndexValidForX:x andY:y];
                    
                    //skip over all the cells that are OFF the screen and the cell that wer are currently updating
                    if (!((x==i) && (y==j)) && isIndexValid) {
                        Creature *neighbor = _gridArray[x][y];
                        if (neighbor.isAlive) {
                            currentCreature.livingNeighbors += 1;
                        }
                    }
                }
            }
        }
    }
}

- (BOOL)isIndexValidForX:(int)x andY:(int)y
{
    BOOL isIndexValid = YES;
    if(x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS)
    {
        isIndexValid = NO;
    }
    return isIndexValid;
}

-(void) updateCreatures
{
    int numAlive = 0;
    //iterate through the rows
    for (int i = 0; i < [_gridArray count] ; i++ ) {
        //iterate through all columns for a given row
        for (int j = 0; j < [_gridArray[i] count]; j++) {
            //access the creature in the cell that corresponds to the current row/col
            Creature *currentCreature = _gridArray[i][j];
            
            if (currentCreature.livingNeighbors == 3) {
                currentCreature.isAlive = TRUE;
                numAlive++;
            }
            else if (currentCreature.livingNeighbors <= 1 || currentCreature.livingNeighbors >= 4)
            {
                currentCreature.isAlive = FALSE;
                numAlive--;
            }
            
        }
    }
    
    _totalAlive = numAlive;
    
}

























@end
