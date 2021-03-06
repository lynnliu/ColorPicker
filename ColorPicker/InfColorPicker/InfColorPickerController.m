//==============================================================================
//
//  MainViewController.m
//  InfColorPicker
//
//  Created by Troy Gaul on 7 Aug 2010.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "InfColorPickerController.h"

#import "InfColorBarPicker.h"
#import "InfColorSquarePicker.h"
#import "InfHSBSupport.h"

//------------------------------------------------------------------------------

static void HSVFromUIColor( UIColor* color, float* h, float* s, float* v )
{
	CGColorRef colorRef = [ color CGColor ];
	
	const CGFloat* components = CGColorGetComponents( colorRef );
	size_t numComponents = CGColorGetNumberOfComponents( colorRef );
	
	CGFloat r, g, b;
	if( numComponents < 3 ) {
		r = g = b = components[ 0 ];
	}
	else {
		r = components[ 0 ];
		g = components[ 1 ];
		b = components[ 2 ];
	}
	
	RGBToHSV( r, g, b, h, s, v, YES );
}

//==============================================================================

@interface InfColorPickerController()

- (void) updateResultColor;

// Outlets and actions:

- (IBAction) takeBarValue: (id) sender;
- (IBAction) takeSquareValue: (id) sender;
- (IBAction) takeBackgroundColor: (UIView*) sender;
- (IBAction) done: (id) sender;

@end

//==============================================================================

@implementation InfColorPickerController

//------------------------------------------------------------------------------

@synthesize delegate, resultColor, sourceColor;
@synthesize barView, squareView;
@synthesize barPicker, squarePicker;
@synthesize sourceColorView,  resultColorView;
@synthesize navController;
@synthesize colorLabel;

//------------------------------------------------------------------------------
#pragma mark	Class methods
//------------------------------------------------------------------------------

+ (InfColorPickerController*) colorPickerViewController
{
	return [ [ [ self alloc ] initWithNibName: @"InfColorPickerView" bundle: nil ] autorelease ];
}

//------------------------------------------------------------------------------

+ (CGSize) idealSizeForViewInPopover
{
	return CGSizeMake( 256 + ( 1 + 20 ) * 2, 420 );
}

//------------------------------------------------------------------------------
#pragma mark	Memory management
//------------------------------------------------------------------------------

- (void) dealloc
{
	[ barView release ];
	[ squareView release ];
	[ barPicker release ];
	[ squarePicker release ];
	[ sourceColorView release ];
	[ resultColorView release ];
	[ navController release ];
	
	[ sourceColor release ];
	[ resultColor release ];
	[ colorLabel release];
	[ super dealloc ];
}

//------------------------------------------------------------------------------
#pragma mark	Creation
//------------------------------------------------------------------------------

- (id) initWithNibName: (NSString*) nibNameOrNil bundle: (NSBundle*) nibBundleOrNil
{
	self = [ super initWithNibName: nibNameOrNil bundle: nibBundleOrNil ];
	
	if( self ) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]){
            self.navigationItem.title = NSLocalizedString( @"色卡",
                                                          @"InfColorPicker default nav item title" );
        }else if ([currentLanguage isEqualToString:@"ja"]){
            self.navigationItem.title = NSLocalizedString( @"标准色",
                                                          @"InfColorPicker default nav item title" );
        }else{
            self.navigationItem.title = NSLocalizedString( @"Color",
                                                          @"InfColorPicker default nav item title" );
        }
	}
	
	return self;
}

//------------------------------------------------------------------------------

- (void) viewDidLoad
{
	[ super viewDidLoad ];

	self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

	barPicker.value = hue;
	squareView.hue = hue;
	squarePicker.hue = hue;
	squarePicker.value = CGPointMake( saturation, brightness );

	if( sourceColor )
		sourceColorView.backgroundColor = sourceColor;
	
	if( resultColor ){
		resultColorView.backgroundColor = resultColor;
        const CGFloat *components = CGColorGetComponents(resultColor.CGColor);
        int r = components[0] * 255, g = components[1] * 255, b = components[2] * 255;
        colorLabel.text = [NSString stringWithFormat:@"r:%d g:%d b:%d",r,g,b];
    }

}

//------------------------------------------------------------------------------

- (void) viewDidUnload
{
	[ super viewDidUnload ];
	
	// Release any retained subviews of the main view.
	
	self.barView = nil;
	self.squareView = nil;
	self.barPicker = nil;
	self.squarePicker = nil;
	self.sourceColorView = nil;
	self.resultColorView = nil;
	self.navController = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.barPicker.frame = CGRectMake(200, self.barPicker.frame.origin.y, 624, self.barPicker.frame.size.height);
        self.squarePicker.frame = CGRectMake(100, 100, 824, 500);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	// if we're not presented modally, we'll never get a chance to send "did finish"
	if (self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------------------------------------------------

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

//------------------------------------------------------------------------------
#pragma mark	IB actions
//------------------------------------------------------------------------------

- (IBAction) takeBarValue: (InfColorBarPicker*) sender
{
	hue = sender.value;
	
	squareView.hue = hue;
	squarePicker.hue = hue;
	
	[ self updateResultColor ];
}

//------------------------------------------------------------------------------

- (IBAction) takeSquareValue: (InfColorSquarePicker*) sender
{
	saturation = sender.value.x;
	brightness = sender.value.y;

	[ self updateResultColor ];
}

//------------------------------------------------------------------------------

- (IBAction) takeBackgroundColor: (UIView*) sender
{
	self.resultColor = sender.backgroundColor;
}

//------------------------------------------------------------------------------

- (IBAction) done: (id) sender
{
    [ self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------------------------------------------------
#pragma mark	Properties
//------------------------------------------------------------------------------

- (void) informDelegateDidChangeColor
{
	if( self.delegate && [ (id) self.delegate respondsToSelector: @selector( colorPickerControllerDidChangeColor: ) ] )
		[ self.delegate colorPickerControllerDidChangeColor: self ];
}

//------------------------------------------------------------------------------

- (void) updateResultColor
{
	// This is used when code internally causes the update.  We do this so that
	// we don't cause push-back on the HSV values in case there are rounding
	// differences or anything.  However, given protections from hue and sat
	// changes when not necessary elsewhere it's probably not actually needed.
	
	[ self willChangeValueForKey: @"resultColor" ];
	
	[ resultColor release ];
	resultColor = [ [ UIColor colorWithHue: hue saturation: saturation 
								brightness: brightness alpha: 1.0f ] retain ];
	
	[ self didChangeValueForKey: @"resultColor" ];
	
	resultColorView.backgroundColor = resultColor;
    const CGFloat *components = CGColorGetComponents(resultColor.CGColor); 
    int r = components[0] * 255, g = components[1] * 255, b = components[2] * 255;
	colorLabel.text = [NSString stringWithFormat:@"r:%d g:%d b:%d",r,g,b];
    
	[ self informDelegateDidChangeColor ];
}

//------------------------------------------------------------------------------

- (void) setResultColor: (UIColor*) newValue
{
	if( ![ resultColor isEqual: newValue ] ) {
		[ resultColor release ];
		resultColor = [ newValue retain ];
		
		float h = hue;
		HSVFromUIColor( newValue, &h, &saturation, &brightness );
		
		if( h != hue ) {
			hue = h;
			
			barPicker.value = hue;
			squareView.hue = hue;
			squarePicker.hue = hue;
		}
		
		squarePicker.value = CGPointMake( saturation, brightness );

		resultColorView.backgroundColor = resultColor;
        const CGFloat *components = CGColorGetComponents(resultColor.CGColor);
        int r = components[0] * 255, g = components[1] * 255, b = components[2] * 255;
        colorLabel.text = [NSString stringWithFormat:@"r:%d g:%d b:%d",r,g,b];
        
		[ self informDelegateDidChangeColor ];
	}
}

//------------------------------------------------------------------------------

- (void) setSourceColor: (UIColor*) newValue
{
	if( ![ sourceColor isEqual: newValue ] ) {
		[ sourceColor release ];
		sourceColor = [ newValue retain ];
		
		sourceColorView.backgroundColor = sourceColor;
		
		self.resultColor = newValue;
	}
}

//------------------------------------------------------------------------------
#pragma mark	UIViewController( UIPopoverController ) methods
//------------------------------------------------------------------------------

- (CGSize) contentSizeForViewInPopover
{
	return [ [ self class ] idealSizeForViewInPopover ];
}

//------------------------------------------------------------------------------

@end

//==============================================================================
