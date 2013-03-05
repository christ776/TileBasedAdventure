//
//  HelloWordHUD.m
//  TileBasedAdventure
//
//  Created by Christian De Martino on 2/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HelloWordHUD.h"
#import "CCLabelTTF.h"
#import "SneakyJoystickSkinnedBase.h"

@implementation HelloWordHUD

@synthesize label = _label;
@synthesize player;
@synthesize joystick = _joystick;

-(void) dealloc
{
    [_joystick release]; _joystick = nil;
    [_label release]; _label = nil;
    [super dealloc];
}

-(id) init
{
    if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.label = [CCLabelTTF labelWithString:@"0"dimensions:CGSizeMake(50, 20) hAlignment:UITextAlignmentRight
                                        fontName:@"Verdana-Bold" fontSize:18.0];
        self.label.color = ccc3(0,0,0);
        int margin = 10;
        self.label.position = ccp(winSize.width - (self.label.contentSize.width/2)
                             - margin, self.label.contentSize.height/2 + margin);
        [self addChild:self.label];
        
        [self initJoystick];
    }
    return self;
}


-(void) initJoystick {
    SneakyJoystickSkinnedBase *joystickBase =[[[SneakyJoystickSkinnedBase alloc]init]autorelease];
    joystickBase.backgroundSprite =[CCSprite spriteWithFile:@"dpad.png"];
    joystickBase.thumbSprite = [CCSprite spriteWithFile:@"joystick.png"];
    joystickBase.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, 128, 128)];
    joystickBase.position = ccp(55, 55);
    [self addChild:joystickBase];
    self.joystick = [joystickBase.joystick retain];
    
}

- (void)numCollectedChanged:(int)numCollected {
    [self.label setString:[NSString stringWithFormat:@"%d", numCollected]];
}

@end
