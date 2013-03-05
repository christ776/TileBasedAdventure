//
//  Defines.h
//  PompaDroid
//
//  Created by Allen Benson G Tan on 10/21/12.
//
//

#ifndef PompaDroid_Defines_h
#define PompaDroid_Defines_h

//convenience measurements
#define SCREEN [[CCDirector sharedDirector] winSize]
#define CENTER ccp(SCREEN.width/2, SCREEN.height/2)
#define CURTIME CACurrentMediaTime()

//convenience functions
#define random_range(low,high) (arc4random()%(high-low+1))+low
#define frandom (float)arc4random()/UINT64_C(0x100000000)
#define frandom_range(low,high) ((high-low)*frandom)+low

//enumerations
typedef enum _ActionState
{
    kActionStateNone = 0,
    kActionStateIdle,
    kActionStateAttack,
    kActionStateWalk,
    kActionStateHurt,
    kActionStateKnockedOut
} ActionState;

//structures
typedef struct _BoundingBox
{
    CGRect actual;
    CGRect original;
} BoundingBox;

#endif
