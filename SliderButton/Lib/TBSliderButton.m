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
#define TB_SAFEAREA_PADDING 60

#define LEFT_HANDLE_PADDING 22
#define RIGHT_MARGIN 8  // space on the right to start clipping
#define HANDLE_MARGIN_TOP 1
#define HANDLE_MARGIN_LEFT 3
#define HANDLE_WIDTH 80

#pragma mark - Private -

@interface TBSliderButton(){
}
@end


#pragma mark - Implementation -

@implementation TBSliderButton

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.opaque = NO;
        

        self.isOn = NO;
        self.bgImageOffName = @"backgroundImageOff.png";
        self.bgImageOnName = @"backgroundImageOn.png";
        
        self.handleImageOnName = @"handleArrowOn.png";
        self.handleImageOffName = @"handleArrowOff.png";
        self.labelStringOffName = @"Connect";
        self.labelStringOnName = @"Disconnect";
        
        [self setBgImageOff:[UIImage imageNamed:self.bgImageOffName]];
        [self setHandleImageOff:[UIImage imageNamed:self.handleImageOffName]];
        
        [self setBgImageOn:[UIImage imageNamed:self.bgImageOnName]];
        [self setHandleImageOn:[UIImage imageNamed:self.handleImageOnName]];
        
        [self setUpButton];

    }
    
    return self;
}

- (void)toggleState
{
    self.isOn = !self.isOn;
    [self setUpButton];
}

- (void)setUpButton
{
    [self.bgImageView removeFromSuperview];
    [self.handleImageView removeFromSuperview];
//    [_textField removeFromSuperview];
    [self.labelField removeFromSuperview];
    // get text for the button label based on the button state
    NSString *label = self.isOn ? self.labelStringOnName : self.labelStringOffName;
//    UIFont *font = [UIFont fontWithName:TB_FONTFAMILY size:TB_FONTSIZE];
    UIFont *font = [UIFont systemFontOfSize:28];
    CGSize fontSize = [label sizeWithFont:font];
    [self setLabelWidth:fontSize.width];
    CGSize imageSize = [self.isOn ? self.bgImageOn : self.bgImageOff size];
    self.buttonWidth = imageSize.width;     // the width of the button based on background image
    self.bgImageView = [[UIImageView alloc] initWithImage: self.isOn ? self.bgImageOn : self.bgImageOff ];
    self.handleImageView = [[UIImageView alloc] initWithImage: self.isOn ? self.handleImageOn : self.handleImageOff];
    CGRect handleFrame = [self.handleImageView frame];
    self.handleWidth = handleFrame.size.width;
    if (self.isOn) {    // if the state is on move handle to right, to indicate swipe left to turn off
        handleFrame.origin.x = self.buttonWidth - self.handleWidth;
    } else
        handleFrame.origin.x = 0;
    self.handleStartPos = handleFrame.origin.x;
    [self.handleImageView setFrame:handleFrame];
    //Using a TextField area we can easily modify the control to get user input from this field
    self.labelStartXPos = (imageSize.width  - fontSize.width) /2;
    NSLog(@"labelStartXPos = %f",self.labelStartXPos);
    CGRect textFieldRect = CGRectMake(self.labelStartXPos,
                                      (imageSize.height - fontSize.height) /2,
                                      fontSize.width,
                                      fontSize.height);
    
    self.labelField = [[UILabel alloc] initWithFrame:textFieldRect];
    if (self.isOn)
        [self.labelField setTextAlignment:NSTextAlignmentRight];
    else
        [self.labelField setTextAlignment:NSTextAlignmentLeft];
    [self.labelField setFont:font];
    [self.labelField setText:label];
    [self.labelField setTextColor:[UIColor blackColor]];
    [self.labelField setBackgroundColor:[UIColor clearColor]];
    [self.labelField setLineBreakMode:NSLineBreakByClipping ];
    [self addSubview:self.bgImageView];
    [self addSubview:self.handleImageView];
    [self addSubview:self.labelField];
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
    continueTracking = [self movehandle:lastPoint event:event];
    
    //Control value has changed, let's notify that   
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
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

//Use the draw rect to draw the Background, the Circle and the Handle 
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
}


#pragma mark - Math -

/** Move the Handle **/
-(BOOL)movehandle:(CGPoint)lastPoint event:(UIEvent *)event {
    
//    NSLog(@"x: %f, y: %f",lastPoint.x,lastPoint.y);
//    NSLog(@"DeltaX: %f",lastPoint.x - self.panStartX);
    BOOL continueHandling = YES;
    CGRect handleFrame = [self.handleImageView frame];
//    NSLog(@"oldHandle x = %f", handleFrame.origin.x);
    float deltaX =  lastPoint.x - self.panStartX;
    if (self.isOn) {
         deltaX = deltaX > 0 ? 0 : deltaX;
        handleFrame.origin.x = self.handleStartPos + deltaX;
        if (handleFrame.origin.x < 0)
            continueHandling = NO;
    } else {
        deltaX = deltaX < 0 ? 0 : deltaX;
        handleFrame.origin.x = deltaX;
        if (handleFrame.origin.x + self.handleWidth > self.buttonWidth)
            continueHandling = NO;
    }
//    NSLog(@"newHandleFrame.x = %f",handleFrame.origin.x);
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
        
        if (self.isOn) {
            textFrame.origin.x = 0 + RIGHT_MARGIN;
            textFrame.size.width = self.labelWidth + deltaX + self.labelStartXPos - RIGHT_MARGIN;
        } else {
            textFrame.origin.x = self.labelStartXPos + deltaX;
            textFrame.size.width = self.labelWidth - deltaX + self.labelStartXPos - RIGHT_MARGIN;
        }
        NSLog(@"textFrame x = %f", textFrame.origin.x);
        if (textFrame.size.width < 0 )
            textFrame.size.width = 0;
        [self.labelField setFrame:textFrame];
    }
    //Redraw
    [self setNeedsDisplay];
    return continueHandling;
}

@end


