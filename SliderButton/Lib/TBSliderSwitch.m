//
//  TBCircularSlider.m
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import "TBSliderSwitch.h"
#import "Commons.h"


/** Parameters **/
//#define TB_SAFEAREA_PADDING 60


#define MARGIN 4  // space on the right to start clipping


#pragma mark - Private -

@interface TBSliderSwitch(){
}


@property (assign, nonatomic) float panStartX;
@property (assign, nonatomic) float labelStartXPos;
@property (assign, nonatomic) float actionLabelStartXPos;
@property (assign, nonatomic) float labelWidth;
@property (assign, nonatomic) float buttonWidth;
@property (assign, nonatomic) float handleWidth;
@property (assign, nonatomic) float handlePos;
@property (assign, nonatomic) float handleStartPos;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *handleImageView;
@property (strong, nonatomic) UIView *clipToButtonBackgroundView;
@property (strong, nonatomic) UILabel *currentStateLabel;
@property (strong, nonatomic) UILabel *actionStateLabel;
@property (strong, nonatomic) UIImage *offBackgroundImage;  // Off Button Background
@property (strong, nonatomic) UIImage *offHandleImage;      // Off Handle Image
@property (strong, nonatomic) UIImage *onBackgroundImage;
@property (strong, nonatomic) UIImage *onHandleImage;
@property (strong, nonatomic) NSString *labelString;

@end



#pragma mark - Implementation -

@implementation TBSliderSwitch



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
        self.onStateString = @"Connected";
        self.offStateString = @"Disconnected";
        
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

    CGSize backgroundImageSize = [self.on ? self.onBackgroundImage : self.offBackgroundImage size];
    self.buttonWidth = backgroundImageSize.width;
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
    NSString *label = self.on ? self.onStateString : self.offStateString;
    UIFont *font = [UIFont systemFontOfSize:24];
    CGSize fontSize = [label sizeWithFont:font];
    [self.currentStateLabel setText:label];
    //Using a TextField area we can easily modify the control to get user input from this field
    self.labelStartXPos = (backgroundImageSize.width  - fontSize.width) /2;
    CGRect textFieldRect = CGRectMake(self.labelStartXPos,
                                      (backgroundImageSize.height - fontSize.height) /2,
                                      fontSize.width,
                                      fontSize.height);
    
    [self.currentStateLabel setFrame:textFieldRect];
    
    // ACTION LABEL
    // get text for the button label based on the button state
    NSString *actionLabel = self.on ? self.offActionString : self.onActionString;
    CGSize actionLabelSize = [actionLabel sizeWithFont:font];
    
    if (self.on) {
        self.actionLabelStartXPos = backgroundImageSize.width + (backgroundImageSize.width - actionLabelSize.width) /2 - 40;
        NSLog(@"actionLabelStartXPos = %f",self.actionLabelStartXPos);
    } else {
        self.actionLabelStartXPos = -(actionLabelSize.width + (backgroundImageSize.width - actionLabelSize.width) /2 - 40);
    }
    CGRect actionLabelRect = CGRectMake(self.actionLabelStartXPos,
                                        (backgroundImageSize.height - actionLabelSize.height) /2,
                                        actionLabelSize.width,
                                        actionLabelSize.height);
    [self.actionStateLabel setFrame:actionLabelRect];
    [self.actionStateLabel setText:actionLabel];
    
    [self.actionStateLabel setAlpha:0];
    [self.currentStateLabel setAlpha:1];
    
    self.panStartX = 0;
    [self setNeedsDisplay];
    
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setUpViews
{
    CGSize backgroundImageSize = [self.on ? self.onBackgroundImage : self.offBackgroundImage size];
    self.buttonWidth = backgroundImageSize.width;     // the width of the button based on background image
    self.backgroundImageView = [[UIImageView alloc] initWithImage: self.on ? self.onBackgroundImage : self.offBackgroundImage ];
    
    // set up this background frame for clipping within the contents of the button
    CGRect backgroundFrame = CGRectMake(MARGIN,0,self.buttonWidth - (MARGIN * 2),backgroundImageSize.height);
    self.clipToButtonBackgroundView = [[UIView alloc] initWithFrame:backgroundFrame];
    [self.clipToButtonBackgroundView setUserInteractionEnabled:NO];
    [self.clipToButtonBackgroundView setBackgroundColor:[UIColor clearColor]];
    
    self.handleImageView = [[UIImageView alloc] initWithImage: self.on ? self.onHandleImage : self.offHandleImage];
    
    CGRect handleFrame = [self.handleImageView frame];
    self.handleWidth = handleFrame.size.width;
    

    if (self.on) {    // if the state is on move handle to right, to indicate swipe left to turn off
        handleFrame.origin.x = self.buttonWidth - (self.handleWidth + MARGIN);
    } else {
        handleFrame.origin.x = 0;
    }
    self.handleStartPos = handleFrame.origin.x;
    [self.handleImageView setFrame:handleFrame];
    
    // STATE LABEL FIELD
    // get text for the button label based on the button state
    NSString *stateLabel = self.on ? self.onStateString : self.offStateString;
    //    UIFont *font = [UIFont fontWithName:TB_FONTFAMILY size:TB_FONTSIZE];
    UIFont *font = [UIFont systemFontOfSize:24];
    CGSize fontSize = [stateLabel sizeWithFont:font];
    [self setLabelWidth:fontSize.width];

    self.labelStartXPos = (backgroundImageSize.width  - fontSize.width) /2;
    CGRect textFieldRect = CGRectMake(self.labelStartXPos,
                                      (backgroundImageSize.height - fontSize.height) /2,
                                      fontSize.width,
                                      fontSize.height);
    
    // Setup the Label
    self.currentStateLabel = [[UILabel alloc] initWithFrame:textFieldRect];
    [self.currentStateLabel setFont:font];
    [self.currentStateLabel setText:stateLabel];
    [self.currentStateLabel setTextColor:[UIColor blackColor]];
    [self.currentStateLabel setBackgroundColor:[UIColor clearColor]];
    [self.currentStateLabel setLineBreakMode:NSLineBreakByClipping ];
    
    
    // ACTION LABEL
    // get text for the button label based on the button state
    NSString *actionLabel = self.on ? self.offActionString : self.onActionString;
    CGSize actionLabelSize = [actionLabel sizeWithFont:font];
    
    self.actionLabelStartXPos = -(actionLabelSize.width + (backgroundImageSize.width - actionLabelSize.width) /2 - 20);
    NSLog(@"actionLabelStartXPos %f",self.actionLabelStartXPos);
    CGRect actionLabelRect = CGRectMake(self.actionLabelStartXPos,
                                      (backgroundImageSize.height - actionLabelSize.height) /2,
                                      actionLabelSize.width,
                                      actionLabelSize.height);
    self.actionStateLabel = [[UILabel alloc] initWithFrame:actionLabelRect];
    [self.actionStateLabel setText:actionLabel];
    [self.actionStateLabel setFont:font];
    [self.actionStateLabel setTextColor:[UIColor blackColor]];
    
    // Add subviews
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.clipToButtonBackgroundView];
    [self.clipToButtonBackgroundView setClipsToBounds:YES];
    [self.clipToButtonBackgroundView addSubview:self.handleImageView];
    [self.clipToButtonBackgroundView addSubview:self.currentStateLabel];
    [self.clipToButtonBackgroundView addSubview:self.actionStateLabel];
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
    continueTracking = [self handleTrackingEvent:lastPoint event:event];
    
    
    
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
    
    CGRect labelFrame = [self.currentStateLabel frame];
    labelFrame.origin.x = self.labelStartXPos;
    
    CGRect actionLabelFrame = [self.actionStateLabel frame];
    actionLabelFrame.origin.x = self.actionLabelStartXPos;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelay:.05];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [self.actionStateLabel setAlpha:0];
    [self.currentStateLabel setAlpha:1];
    self.handleImageView.frame = handleFrame;
    self.currentStateLabel.frame = labelFrame;
    self.actionStateLabel.frame = actionLabelFrame;
    [UIView commitAnimations];
}

#pragma mark - Drawing Functions - 

// Use to override drawing
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
}


#pragma mark - Math -

-(float)calculateHandlePos:(float)deltaX
{
    
    float fractionValue = (deltaX/(self.buttonWidth - self.handleWidth));
    NSLog(@"HandlePos: %f",fractionValue);
    return fabs(fractionValue);
}

/** Move the Handle **/
-(BOOL)handleTrackingEvent:(CGPoint)lastPoint event:(UIEvent *)event {
    
    BOOL continueHandling = YES;
    CGRect handleFrame = [self.handleImageView frame];
    float deltaX =  lastPoint.x - self.panStartX;
    self.handlePos = [self calculateHandlePos:deltaX];
    if (self.on) {
        deltaX = deltaX > 0 ? 0 : deltaX;   // prevent moving handles outside of the button
        handleFrame.origin.x = self.handleStartPos + deltaX;    // deltaX is negative when sliding left
        if (handleFrame.origin.x < 0)   // stop tracking when we slide all the way to the left
            continueHandling = NO;
    } else {
        deltaX = deltaX < 0 ? 0 : deltaX;   // prevent moving handles outside of the button
        handleFrame.origin.x = deltaX;
        if (handleFrame.origin.x + self.handleWidth + MARGIN > self.buttonWidth)  // stop tracking when we slide all the way to the right
            continueHandling = NO;
    }
    // check if we dragged outside the button and stop dragging change button state
    if (!continueHandling) {
        [self cancelTrackingWithEvent:event];
        [self toggleState];
        self.handlePos = 0;
        self.panStartX = 0;
    } else {
        [self.handleImageView setFrame:handleFrame];
        
        [self.currentStateLabel setAlpha:1-self.handlePos];
        
        CGRect textFrame = [self.currentStateLabel frame];
        textFrame.origin.x = self.labelStartXPos + deltaX;
        [self.currentStateLabel setFrame:textFrame];
        
        CGRect actionLabelFrame = [self.actionStateLabel frame];
        actionLabelFrame.origin.x = self.actionLabelStartXPos + deltaX;
        NSLog(@"actionLabelFrame.origin.x: %f",actionLabelFrame.origin.x);
        [self.actionStateLabel setAlpha:self.handlePos];
        [self.actionStateLabel setFrame:actionLabelFrame];
        
    }
    //Redraw
    [self setNeedsDisplay];
    return continueHandling;
}

@end


