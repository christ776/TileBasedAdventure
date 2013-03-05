//
//  SimpleDPad.m
//  PompaDroid
//
//  Created by Allen Benson G Tan on 10/21/12.
//  Copyright 2012 WhiteWidget Inc. All rights reserved.
//

#import "SimpleDPad.h"


@implementation SimpleDPad

+(id)dPadWithFile:(NSString *)fileName radius:(float)radius
{
    return [[self alloc] initWithFile:fileName radius:radius];
}

-(id)initWithFile:(NSString *)filename radius:(float)radius
{
    if ((self = [super initWithFile:filename]))
    {
        _radius = radius;
        _direction = CGPointZero;
        _isHeld = NO;
        [self scheduleUpdate];
    }
    return self;
}

-(void)onEnterTransitionDidFinish
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(void)update:(ccTime)dt
{
    if (_isHeld)
    {
        [_delegate simpleDPad:self isHoldingDirection:_direction];
    }
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    float distanceSQ = ccpDistanceSQ(location, position_);
    if (distanceSQ <= _radius * _radius)
    {
        //get angle 8 directions
        [self updateDirectionForTouchLocation:location];
        _isHeld = YES;
        return YES;
    }
    return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    [self updateDirectionForTouchLocation:location];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    _direction = CGPointZero;
    _isHeld = NO;
    [_delegate simpleDPadTouchEnded:self];
}

-(void)updateDirectionForTouchLocation:(CGPoint)location
{
    float radians = ccpToAngle(ccpSub(location, position_));
    float degrees = -1 * CC_RADIANS_TO_DEGREES(radians);
    
    if (degrees <= 22.5 && degrees >= -22.5)
    {
        //right
        _direction = ccp(1.0, 0.0);
    }
    else if (degrees > 22.5 && degrees < 67.5)
    {
        //bottomright
        _direction = ccp(1.0, -1.0);
    }
    else if (degrees >= 67.5 && degrees <= 112.5)
    {
        //bottom
        _direction = ccp(0.0, -1.0);
    }
    else if (degrees > 112.5 && degrees < 157.5)
    {
        //bottomleft
        _direction = ccp(-1.0, -1.0);
    }
    else if (degrees >= 157.5 || degrees <= -157.5)
    {
        //left
        _direction = ccp(-1.0, 0.0);
    }
    else if (degrees < -22.5 && degrees > -67.5)
    {
        //topright
        _direction = ccp(1.0, 1.0);
    }
    else if (degrees <= -67.5 && degrees >= -112.5)
    {
        //top
        _direction = ccp(0.0, 1.0);
    }
    else if (degrees < -112.5 && degrees > -157.5)
    {
        //topleft
        _direction = ccp(-1.0, 1.0);
    }
    [_delegate simpleDPad:self didChangeDirectionTo:_direction];
}

@end
