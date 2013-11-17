//
//  TBCircularSlider.m
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import "TBSliderButton.h"
#import "Commons.h"

/** Helper Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

/** Parameters **/
#define TB_SAFEAREA_PADDING 60

#define LEFT_HANDLE_PADDING 22


#pragma mark - Private -

@interface TBSliderButton(){
    UITextField *_textField;
    int radius;
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
        
        self.handleImageOnName = @"handleImageOn.png";
        self.handleImageOffName = @"handleImageOff.png";
        self.labelStringOffName = @"CONNECT";
        self.labelStringOnName = @"DISCONNECT";
        
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
    [_textField removeFromSuperview];
    // get text for the button label based on the button state
    NSString *label = self.isOn ? self.labelStringOnName : self.labelStringOffName;
    UIFont *font = [UIFont fontWithName:TB_FONTFAMILY size:TB_FONTSIZE];
    CGSize fontSize = [label sizeWithFont:font];
    [self setLabelWidth:fontSize.width];
    CGSize imageSize = [self.isOn ? self.bgImageOn : self.bgImageOff size];
    self.buttonWidth = imageSize.width;     // the width of the button based on background image
    self.bgImageView = [[UIImageView alloc] initWithImage: self.isOn ? self.bgImageOn : self.bgImageOff ];
    self.handleImageView = [[UIImageView alloc] initWithImage: self.isOn ? self.handleImageOn : self.handleImageOff];
    
    //Using a TextField area we can easily modify the control to get user input from this field
    self.labelStartXPos = (imageSize.width  - fontSize.width) /2;
    CGRect textFieldRect = CGRectMake(self.labelStartXPos,
                                      (imageSize.height - fontSize.height) /2,
                                      fontSize.width,
                                      fontSize.height);
    
    _textField = [[UITextField alloc]initWithFrame:textFieldRect];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textColor = [UIColor colorWithWhite:1 alpha:1];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.font = font;
    _textField.text = label;
    _textField.enabled = NO;
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.handleImageView];
    [self addSubview:_textField];
    [self setNeedsDisplay];
}

#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    NSLog(@"Begin Tacking With Touch");
    CGPoint lastPoint = [touch locationInView:self];
    CGRect handleFrame = [self.handleImageView frame];
    //    NSLog(@"oldHandle x = %f", handleFrame.origin.x);
    float deltaX =  lastPoint.x - self.panStartX;
    deltaX = deltaX < 0 ? 0 : deltaX;
    handleFrame.origin.x = deltaX;
    if (handleFrame.origin.x + LEFT_HANDLE_PADDING < self.buttonWidth) {
        self.panStartX = lastPoint.x;
        //We need to track continuously
        return YES;
    } else
        return NO;
    
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
    deltaX = deltaX < 0 ? 0 : deltaX;
    handleFrame.origin.x = deltaX;
//    NSLog(@"newHandleFrame.x = %f",handleFrame.origin.x);
    // check if we dragged outside the button and stop dragging change button state
    if (handleFrame.origin.x + LEFT_HANDLE_PADDING > self.buttonWidth) {
        [self cancelTrackingWithEvent:event];
        [self toggleState];
        self.handlePos = 0;
        continueHandling = NO;
    } else {
        self.handlePos = deltaX;
        [self.handleImageView setFrame:handleFrame];
        
        CGRect textFrame = [_textField frame];
    //    NSLog(@"textFrame x = %f", textFrame.origin.x);
        textFrame.origin.x = self.labelStartXPos + deltaX;
        [_textField setFrame:textFrame];
    }
    //Redraw
    [self setNeedsDisplay];
    return continueHandling;
}

@end


