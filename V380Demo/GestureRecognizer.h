//
//  CreamsupGestureRecognizer .h
//  testMapTuach
//
//  Created by luo king on 11-8-4.
//  Copyright 2011 cctv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);
@interface GestureRecognizer: UIGestureRecognizer {
	TouchesEventBlock touchesBeganCallback;
	TouchesEventBlock touchesEndedCallback;
	TouchesEventBlock touchesMovedCallback;
}


@property(copy) TouchesEventBlock touchesBeganCallback;
@property(copy) TouchesEventBlock touchesEndedCallback;
@property(copy) TouchesEventBlock touchesMovedCallback;

@end
