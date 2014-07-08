//
//  Creature.m
//  GameOfLife
//
//  Created by Kendall Agbulos on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Creature.h"

@implementation Creature

-(instancetype)initCreature{
//since we made creature inherit from CCspire, 'super' refers too CCspite
    self = [super initWithImageNamed:@"GameOfLifeAssets/Assets/bubble.png"];
    if (self) {
        self.isAlive = NO;
    }
    
    return  self;

}

-(void)setIsAlive:(BOOL)newState{
    //when you create an @property, an instance variable with a leading underscore is automatically created for you
    _isAlive = newState;
    
    //'visible' is a property of any class that inherits from CCNode. CCNODE ->ccsprite ->create therefore creatures have the property
    self.visible = _isAlive;
}
@end
