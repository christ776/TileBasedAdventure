//
//  HelloWorldLayer.h
//  TileBasedAdventure
//
//  Created by Christian De Martino on 1/28/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "HelloWordHUD.h"
#import "SimpleAudioEngine.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Player.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer

// After the class declaration
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) CCTMXLayer *meta;
@property (nonatomic, retain) CCTMXLayer *foreground;
@property (nonatomic, assign) int numCollected;
@property (nonatomic, retain) HelloWordHUD *hud;

@end
