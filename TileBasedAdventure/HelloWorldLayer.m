//
//  HelloWorldLayer.m
//  TileBasedAdventure
//
//  Created by Christian De Martino on 1/28/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "CCTouchDispatcher.h"
#import "SneakyJoystick.h"

@interface HelloWorldLayer ()

@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize tileMap = _tileMap;
@synthesize background = _background;
@synthesize player = _player;
@synthesize meta = _meta;
@synthesize foreground = _foreground;
@synthesize numCollected;
@synthesize hud = _hud;

- (void) dealloc
{
    [_tileMap release]; _tileMap = nil;
    [_background release]; _background = nil;
    [_player release]; _player = nil;
    [_meta release]; _meta = nil;
    [_foreground release]; _foreground = nil;
    [_hud release]; _hud = nil;
	[super dealloc];
}

-(id) init
{
    if( (self=[super init] )) {
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pickup.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"move.caf"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"TileMap.caf"];
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
        self.meta = [_tileMap layerNamed:@"Meta"];
        self.foreground = [_tileMap layerNamed:@"Foreground"];
        self.meta.visible = NO;
        
        CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"Objects"];
        NSAssert(objects != nil, @"'Objects' object group not found");
        NSMutableDictionary *spawnPoint = [objects objectNamed:@"SpawnPoint"];
        NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
        int x = [[spawnPoint valueForKey:@"x"] intValue];
        int y = [[spawnPoint valueForKey:@"y"] intValue];
        
        self.player = [Player node];
        _player.position = ccp(x, y);
        [self addChild:_player];
        
        [self setViewpointCenter:_player.position];
        
        [self addChild:_tileMap z:-1];
        
       // self.isTouchEnabled = YES;
        
        [self scheduleUpdate];
        
    }
    return self;
}


-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
}

-(BOOL) canMovePlayerToPosition:(CGPoint)position
{
    BOOL canMovePlayer = YES;
    
    CGPoint tileCoord = [self tileCoordForPosition:position];
    int tileGid = [_meta tileGIDAt:tileCoord];
    if (tileGid) {
        NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
        if (properties) {
            NSString *collision = [properties valueForKey:@"Collidable"];
            if (collision && [collision compare:@"True"] == NSOrderedSame)
            {
                canMovePlayer = NO;
            }
            
            NSString *collectable = [properties valueForKey:@"Collectable"];
            if (collectable && [collectable compare:@"True"] == NSOrderedSame)
            {
                [_meta removeTileAt:tileCoord];
                [_foreground removeTileAt:tileCoord];
                self.numCollected++;
                [self.hud numCollectedChanged:self.numCollected];
                // In case of collectable tile
                [[SimpleAudioEngine sharedEngine] playEffect:@"pickup.caf"];
                
            }
        }
    }

	id cameraMove = [CCFollow actionWithTarget:_player
                                 worldBoundary:CGRectMake(0, 0, (_tileMap.mapSize.width * _tileMap.tileSize.width), (_tileMap.mapSize.height * _tileMap.mapSize.height))];
    
	[self runAction:cameraMove];
    return canMovePlayer;
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / _tileMap.tileSize.width;
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height) - position.y) / _tileMap.tileSize.height;
    return ccp(x, y);
}

-(void) registerWithTouchDispatcher
{
	[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self
                                                     priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}


-(void) update:(ccTime)deltaTime
{
    [self applyJoystick:self.hud.joystick toNode:self.player forTimeDelta:deltaTime];
}

- (void) applyJoystick:(SneakyJoystick *)aJoystick toNode:(CCNode *)tempNode forTimeDelta:(float)deltaTime {
    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 480.0f);
    
    CGPoint newPosition =
    ccp(tempNode.position.x + scaledVelocity.x * deltaTime,tempNode.position.y + scaledVelocity.y * deltaTime);
    
    if (newPosition.x <= (_tileMap.mapSize.width * _tileMap.tileSize.width) &&
        newPosition.y <= (_tileMap.mapSize.height * _tileMap.tileSize.height) &&
        newPosition.y >= 0 &&
        newPosition.x >= 0 )
    {
        if ([self canMovePlayerToPosition:newPosition])
        {
            [tempNode setPosition:newPosition];
        }
    }

    [self setViewpointCenter:_player.position];
}

@end
