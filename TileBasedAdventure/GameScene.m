//
//  GameScene.m
//  TileBasedAdventure
//
//  Created by Christian De Martino on 2/23/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "HelloWorldLayer.h"
#import "HelloWordHUD.h"


@implementation GameScene

-(id)init
{
    if ((self = [super init]))
    {
        // 'layer' is an autorelease object.
        HelloWorldLayer *layer = [HelloWorldLayer node];
        
        // add layer as a child to scene
        [self addChild: layer];
        
        HelloWordHUD *hud = [HelloWordHUD node];
        
        [self addChild: hud];
        
        layer.hud = hud;
        //Set delegate to get Joystick events.
        hud.player= layer.player;
    }
    return self;
}

@end
