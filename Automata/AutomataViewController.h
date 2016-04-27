//
//  ViewController.h
//  Automata
//
//  Created by Riley Williams on 10/29/14.
//  Copyright (c) 2014 Riley Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Grid.h"
//#import "CellAlgorithm.h"
//#import "CellShader.h"

#define pt(x, y, k) (self.width*y*3 + x*3 + k)

#define res 1

@import OpenGLES;
@import CoreImage;
@import CoreGraphics;

@interface AutomataViewController : UIViewController

@property CIContext *context;

@property int width;
@property int height;
@property uint8_t *data;
@property uint8_t *buf;
@property int8_t *lvl;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorPicker;
//@property CGDataProviderRef dataProvider;
@property BOOL isIntegrating;

- (IBAction)clear;

@end

