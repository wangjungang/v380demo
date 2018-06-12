//
//  CreamsupGestureRecognizer .m
//  testMapTuach
//
//  Created by luo king on 11-8-4.
//  Copyright 2011 cctv. All rights reserved.
//

#import "GestureRecognizer.h"


@implementation GestureRecognizer
@synthesize touchesBeganCallback, touchesEndedCallback, touchesMovedCallback;

-(id) init{    
	if (self = [super init])   
	{        
		self.cancelsTouchesInView = NO;   
	}    
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
    if (touchesBeganCallback)
        touchesBeganCallback(touches, event);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if (touchesEndedCallback)
        touchesEndedCallback(touches, event);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if (touchesMovedCallback)
        touchesMovedCallback(touches, event);
}

- (void)reset{}

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event{
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer{ 
	return NO;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer{  
	return NO;
}


-(void)dealloc{
	[touchesBeganCallback release];
	[touchesEndedCallback release];
	[touchesMovedCallback release];
	[super dealloc];
}

@end
