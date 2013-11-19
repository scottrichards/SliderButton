//
//  TBCircularSlider.m
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import "TBSliderButton.h"
#import "Commons.h"


/** Parameters **/
//#define TB_SAFEAREA_PADDING 60


#define MARGIN 4  // space on the right to start clipping


#pragma mark - Private -

@interface TBSliderButton(){
}


@property (assign, nonatomic) float panStartX;
@property (assign, nonatomic) float labelStartXPos;
@property (assign, nonatomic) float labelWidth;
@property (assign, nonatomic) float buttonWidth;
@property (assign, nonatomic) float handleWidth;
@property (assign, nonatomic) float handlePos;
@property (assign, nonatomic) float handleStartPos;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *handleImageView;
@property (strong, nonatomic) UIView *buttonBackgroundView;
@property (strong, nonatomic) UILabel *labelField;
@property (strong, nonatomic) UIImage *offBackgroundImage;  // Off Button Background
@property (strong, nonatomic) UIImage *offHandleImage;      // Off Handle Image
@property (strong, nonatomic) UIImage *onBackgroundImage;
@property (strong, nonatomic) UIImage *onHandleImage;
@property (strong, nonatomic) NSString *labelString;

@end



#pragma mark - Implementation -

@implementation TBSliderButton



-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.opaque = NO;
        self.on = NO;
        self.offBackgroundImageString = @"backgroundImageOff.png";
        self.onBackgroundImageString = @"backgroundImageOn.png";
        
        self.handleImageOnString = @"handleArrowOn.png";
        self.handleImageOffString = @"handleArrowOff.png";
        self.onActionString = @"Connect";
        self.offActionString = @"Disconnect";
        
        [self setOffBackgroundImage:[UIImage imageNamed:self.offBackgroundImageString]];
        [self setOffHandleImage:[UIImage imageNamed:self.handleImageOffString]];
        
        [self setOnBackgroundImage:[UIImage imageNamed:self.onBackgroundImageString]];
        [self setOnHandleImage:[UIImage imageNamed:self.handleImageOnString]];
        
        [self setUpViews];
    }
    
    return self;
}

- (void)toggleState
{
    self.on = !self.on;

    CGSize imageSize = [self.on ? self.onBackgroundImage : self.offBackgroundImage size];
    self.buttonWidth = imageSize.width;
    self.backgroundImageView.image = self.on ? self.onBackgroundImage : self.offBackgroundImage;
    
    self.handleImageView.image =  self.on ? self.onHandleImage : self.offHandleImage;

    CGRect handleFrame = [self.handleImageView frame];
    self.handleWidth = handleFrame.size.width;
    if (self.on) {    // if the state is on move handle to right, to indicate swipe left to turn off
        handleFrame.origin.x = self.buttonWidth - (self.handleWidth + MARGIN);
    } else {
        handleFrame.origin.x = 0;
    }
    
    self.handleStartPos = handleFrame.origin.x;
    [self.handleImageView setFrame:handleFrame];
    
    // Setup Switch State Label
    NSString *label = self.on ? self.offActionString : self.onActionString;
    UIFont *font = [UIFont systemFontOfSize:24];
    CGSize fontSize = [label sizeWithFont:font];
    [self.labelField setText:label];
    //Using a TextField area we can easily modify the control to get user input from this field
    self.labelStartXPos = (imageSize.width  - fontSize.width) /2;
    CGRect textFieldRect = CGRectMake(self.labelStartXPos,
                                      (imageSize.height - fontSize.height) /2,
                                      fontSize.width,
                                      fontSize.height);
    
    [self.labelField setFrame:textFieldRect];
    
    self.panStartX = 0;
    [self setNeedsDisplay];
    
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setUpViews
{
    // get text for the button label based on the button state
    NSString *label = self.on ? self.offActionString : self.onActionString;
//    UIFont *font = [UIFont fontWithName:TB_FONTFAMILY size:TB_FONTSIZE];
    UIFont *font = [UIFont systemFontOfSize:24];
    CGSize fontSize = [label sizeWithFont:font];
    [self setLabelWidth:fontSize.width];
    CGSize imageSize = [self.on ? self.onBackgroundImage : self.offBackgroundImage size];
    self.buttonWidth = imageSize.width;     // the width of the button based on background image
    self.backgroundImageView = [[UIImageView alloc] initWithImage: self.on ? self.onBackgroundImage : self.offBackgroundImage ];
    self.handleImageView = [[UIImageView alloc] initWithImage: self.on ? self.onHandleImage : self.offHandleImage];
    
    CGRect handleFrame = [self.handleImageView frame];
    self.handleWidth = handleFrame.size.width;
    
    // set up this background frame for clipping within the contents of the button
    CGRect backgroundFrame = CGRectMake(MARGIN,0,self.buttonWidth - (MARGIN * 2),imageSize.height);
    self.buttonBackgroundView = [[UIView alloc] initWithFrame:backgroundFrame];
    [self.buttonBackgroundView setBackgroundColor:[UIColor clearColor]];
    if (self.on) {    // if the state is on move handle to right, to indicate swipe left to turn off
        handleFrame.origin.x = self.buttonWidth - (self.handleWidth + MARGIN);
    } else {
        handleFrame.origin.x = 0;
    }
    self.handleStartPos = handleFrame.origin.x;
    [self.handleImageView setFrame:handleFrame];
    //Using a TextField area we can easily modify the control to get user input from this field
    self.labelStartXPos = (imageSize.width  - fontSize.width) /2;
    CGRect textFieldRect = CGRectMake(self.labelStartXPos,
                                      (imageSize.height - fontSize.height) /2,
                                      fontSize.width,
                                      fontSize.height);
    
    // Setup the Label
    self.labelField = [[UILabel alloc] initWithFrame:textFieldRect];
//    [self.labelField setTextAlignment:NSTextAlignmentLeft];
    [self.labelField setFont:font];
    [self.labelField setText:label];
    [self.labelField setTextColor:[UIColor blackColor]];
    [self.labelField setBackgroundColor:[UIColor clearColor]];
    [self.labelField setLineBreakMode:NSLineBreakByClipping ];
    [self.buttonBackgroundView setUserInteractionEnabled:NO];
    
    // Add subviews
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.buttonBackgroundView];
    [self.buttonBackgroundView setClipsToBounds:YES];
    [self.buttonBackgroundView addSubview:self.handleImageView];
    [self.buttonBackgroundView addSubview:self.labelField];
    self.panStartX = 0;
    [self setNeedsDisplay];
}

#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    CGPoint locationInView = [touch locationInView:self];
    self.panStartX = locationInView.x;
    NSLog(@"Begin Tacking With Touch");
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL continueTracking = YES;
    [super continueTrackingWithTouch:touch withEvent:event];

    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];

    //Use the location to design the Handle
    continueTracking = [self handleEvent:lastPoint event:event];
    
    
    
    return continueTracking;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    NSLog(@"End Tacking With Touch");
    
    self.panStartX = 0;
    [self returnToStartState];
}


-(void)returnToStartState
{
    CGRect handleFrame = [self.handleImageView frame];
    handleFrame.origin.x = self.handleStartPos;
    
    CGRect labelFrame = [self.labelField frame];
    labelFrame.origin.x = self.labelStartXPos;
    labelFrame.size.width = self.labelWidth;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:.05];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    self.handleImageView.frame = handleFrame;
    self.labelField.frame = labelFrame;
    [UIView commitAnimations];
}

#pragma mark - Drawing Functions - 

// Use to override drawing
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
}


#pragma mark - Math -

/** Move the Handle **/
-(BOOL)handleEvent:(CGPoint)lastPoint event:(UIEvent *)event {
    
    BOOL continueHandling = YES;
    CGRect handleFrame = [self.handleImageView frame];
    float deltaX =  lastPoint.x - self.panStartX;
    if (self.on) {
        deltaX = deltaX > 0 ? 0 : deltaX;   // prevent moving handles outside of the button
        handleFrame.origin.x = self.handleStartPos + deltaX;    // deltaX is negative when sliding left
        if (handleFrame.origin.x < 0)   // stop tracking when we slide all the way to the left
            continueHandling = NO;
    } else {
        deltaX = deltaX < 0 ? 0 : deltaX;   // prevent moving handles outside of the button
        handleFrame.origin.x = deltaX;
        if (handleFrame.origin.x + self.handleWidth > self.buttonWidth)  // stop tracking when we slide all the way to the right
            continueHandling = NO;
    }
    // check if we dragged outside the button and stop dragging change button state
    if (!continueHandling) {
        [self cancelTrackingWithEvent:event];
        [self toggleState];
        self.handlePos = 0;
        self.panStartX = 0;
    } else {
        self.handlePos = deltaX;
        [self.handleImageView setFrame:handleFrame];
        
        CGRect textFrame = [self.labelField frame];
        textFrame.origin.x = self.labelStartXPos + deltaX;
        if (textFrame.size.width < 0 )
            textFrame.size.width = 0;
        [self.labelField setFrame:textFrame];
    }
    //Redraw
    [self setNeedsDisplay];
    return continueHandling;
}

@end


