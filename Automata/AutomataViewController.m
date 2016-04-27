//
//  ViewController.m
//  Automata
//
//  Created by Riley Williams on 10/29/14.
//  Copyright (c) 2014 Riley Williams. All rights reserved.
//

#import "AutomataViewController.h"

@interface AutomataViewController ()

@end

@implementation AutomataViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	/*
	 EAGLContext *eContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
	 NSDictionary *options = @{kCIContextWorkingColorSpace : [NSNull null]};
	 self.context = [CIContext contextWithEAGLContext:eContext options:options];
	 */
	
	//self.dataProvider = CGDataProviderCreateWithData(NULL, self.data, self.width*self.height, NULL);
	
	self.width = self.imageView.frame.size.width/res;
	self.height = self.imageView.frame.size.height/res;

	self.data = malloc(3*self.width*self.height);
	self.buf = malloc(3*self.width*self.height);
	self.lvl = malloc(self.width*self.height);
	for (int x = 0; x < self.width; x++) {
		for (int y = 0; y < self.height; y++) {
			self.data[pt(x,y,0)] = 0;
			self.data[pt(x,y,1)] = 0;
			self.data[pt(x,y,2)] = 0;
			self.lvl[self.width*y+x] = 10;
		}
	}
	
	self.isIntegrating = NO;
	
	//self.imageView.contentMode = UIViewContentModeCenter;
	
	NSTimer *update = [NSTimer timerWithTimeInterval:1.0/30 target:self selector:@selector(updatePixels) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:update forMode:NSRunLoopCommonModes];
	[self updatePixels];
}

-(void)integrate {
	if (self.isIntegrating == YES) {
		return;
	}
	self.isIntegrating = YES;
	
	int dy;
	int dx;
	u_int8_t red[]   = {000, 000, 000, 000, 255, 255, 000, 000};
	u_int8_t green[] = {000, 000, 255, 000, 000, 000, 255, 000};
	u_int8_t blue[]  = {000, 255, 000, 255, 000, 000, 000, 000};
	int8_t lvlup[]   = {000, -01, -01, 001, -01, 001, 001, 000};
	
	dx = arc4random_uniform(3)-1 + self.width;
	dy = arc4random_uniform(3)-1 + self.height;
	
	for (int x = 0; x < self.width; x++) {
		for (int y = 0; y < self.height; y++) {
			
			int xf = (x+dx)%self.width;
			int yf = (y+dy)%self.height;
			
			unsigned int pxl = pt(x, y, 0);
			unsigned int adj = pt(xf, yf, 0);
			unsigned int pxllvl = self.width*y+x;
			
			u_int8_t convoluted =
			(((self.data[pxl] & 4) + (self.data[pxl+1] & 2) + (self.data[pxl+2] & 1)) |
			 ((self.data[adj] & 4) + (self.data[adj+1] & 2) + (self.data[adj+2] & 1))) & 7;
			if (convoluted == -1 && self.lvl[pxllvl] <= 0) {
				self.buf[adj] = self.data[adj];
				self.buf[adj+1] = self.data[adj+1];
				self.buf[adj+2] = self.data[adj+2];
				continue;
			}
			self.buf[adj] = red[convoluted];
			self.buf[adj+1] = green[convoluted];
			self.buf[adj+2] = blue[convoluted];
			self.lvl[self.width*yf+xf] = self.lvl[pxllvl]+lvlup[convoluted];
			//}
		}
	}
	memcpy(self.data, self.buf, 3*self.width*self.height);
	self.isIntegrating = NO;
}

-(void)updatePixels {
	[self integrate];
	
	//self.dataProvider = CGDataProviderCreateWithData(NULL, self.data, self.width*self.height, NULL);
	
	CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, self.data, self.width*self.height, NULL);
	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef inputImage = CGImageCreate(self.width, self.height,
										  8, 24, self.width*3,
										  colourSpace,
										  kCGBitmapByteOrderDefault,
										  dataProvider,
										  NULL, NO,
										  kCGRenderingIntentDefault);
	CGDataProviderRelease(dataProvider);
	CGColorSpaceRelease(colourSpace);
	
	UIImage *image = [UIImage imageWithCGImage:inputImage];
	CGImageRelease(inputImage);
	
	self.imageView.image = image;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	int x;
	int y;
	for (UITouch *touch in touches) {
		if (CGRectContainsPoint(self.imageView.frame, [touch locationInView:self.imageView])) {
			x = [touch locationInView:self.imageView].x/res;
			y = [touch locationInView:self.imageView].y/res;
			self.data[pt(x, y, self.colorPicker.selectedSegmentIndex)] = 255;
		}
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	int x;
	int y;
	for (UITouch *touch in touches) {
		if (CGRectContainsPoint(self.imageView.frame, [touch locationInView:self.imageView])) {
			x = [touch locationInView:self.imageView].x/res;
			y = [touch locationInView:self.imageView].y/res;
			self.data[pt(x, y, self.colorPicker.selectedSegmentIndex)] = 255;
		}
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	int x;
	int y;
	for (UITouch *touch in touches) {
		if (CGRectContainsPoint(self.imageView.frame, [touch locationInView:self.imageView])) {
			x = [touch locationInView:self.imageView].x/res;
			y = [touch locationInView:self.imageView].y/res;
			self.data[pt(x, y, self.colorPicker.selectedSegmentIndex)] = 255;
		}
	}
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)clear {
	for (int x = 0; x < self.width; x++) {
		for (int y = 0; y < self.height; y++) {
			self.data[pt(x,y,0)] = 0;
			self.data[pt(x,y,1)] = 0;
			self.data[pt(x,y,2)] = 0;
			self.lvl[self.width*y+x] = 0;
		}
	}
}


@end
