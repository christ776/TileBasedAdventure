//
//  HelloWordHUD.h
//  TileBasedAdventure
//
//  Created by Christian De Martino on 2/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyJoystick.h"

@interface HelloWordHUD : CCLayer

@property (nonatomic,retain) CCLabelTTF *label;
@property (nonatomic, assign) CCSprite *player;
@property (nonatomic,retain) SneakyJoystick *joystick;

- (void)numCollectedChanged:(int)numCollected;

@end
