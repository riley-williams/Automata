//
//  Grid.h
//  Automata
//
//  Created by Riley Williams on 10/29/14.
//  Copyright (c) 2014 Riley Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct {
	int x;
	int y;
} GPoint;

typedef struct {
	int width;
	int height;
} GSize;

typedef struct {
	char r;
	char g;
	char b;
} Color;

@interface Grid : NSObject

@property GSize size;
@property Color *data;

@end
