//
//  ColorPickerViewController.m
//  ColorPicker
//
//  Created by Gilly Dekel on 23/3/09.
//  Extended by Fabián Cañas August 2010.
//  Copyright 2010. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "ColorPickerView.h"
#import "UIColor+HSV.h"

@implementation ColorPickerViewController

@synthesize delegate, chooseButton;
@synthesize defaultsKey;

NSString *keyForHue = @"hue";
NSString *keyForSat = @"sat";
NSString *keyForBright = @"bright";

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	NSUserDefaults *saveColors = [NSUserDefaults standardUserDefaults];
	if (defaultsKey==nil) {
        self.defaultsKey = @"";
    }
    
    NSData *colorData= [saveColors objectForKey:defaultsKey];
    UIColor *color;
    if (colorData!=nil) {
        color = (UIColor*)[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    }
		
    [self moveToDefault];   // Move the crosshair to the default setting
}

-(void) moveToDefault {
  ColorPickerView *theView = (ColorPickerView*) [self view];
  NSUserDefaults *saveColors = [NSUserDefaults standardUserDefaults];
  NSData *colorData= [saveColors objectForKey:defaultsKey];
  UIColor *color;
  if (colorData!=nil) {
      color = (UIColor*)[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
  }
  [theView setColor:color];
}

- (UIColor *) getSelectedColor {
	return [(ColorPickerView *) [self view] getColorShown];
}

- (IBAction) chooseSelectedColor {
    [delegate colorPickerViewController:self didSelectColor:[self getSelectedColor]];
}

- (IBAction) cancelColorSelection {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if (defaultsKey==nil) {
        defaultsKey = @"";
    }
    
    NSData *colorData= [userDefaults objectForKey:defaultsKey];
    UIColor *color;
    if (colorData!=nil) {
        color = (UIColor*)[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    }
    
    [delegate colorPickerViewController:self didSelectColor:color];
}

// Housekeeping actions when a view as unloaded
- (void)viewDidUnload {
  // Release any retained subviews of the main view.
#if ___IPHONE_OS_VERSION_MAX_ALLOWED >= 30000
  [super viewDidUnload];  // First super, from iOS 3 on

  self.chooseButton=nil;   // Same as release, but also setting it to nil
#endif

  return;
}

- (void)dealloc {
    // Release claimed resources also
    [defaultsKey release];
    [super dealloc];
}

@end
