//
//  TBSliderButton.h
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Parameters **/
#define TB_SLIDER_WIDTH 300                          //The width of the slider
#define TB_SLIDER_HEIGHT 80                          //The height of the slider


/*#define TB_FONTSIZE 48                                  //The size of the textfield font
#define TB_FONTFAMILY @"Futura-CondensedExtraBold"  //The font family of the textfield font
*/

#define TB_FONTSIZE 36                                  //The size of the textfield font
#define TB_FONTFAMILY @"ArialMT"  //The font family of the textfield font

@interface TBSliderSwitch : UIControl

@property (assign, nonatomic) BOOL on;
@property (strong, nonatomic) NSString *onBackgroundImageString;    // Change name bgImageOnString
@property (strong, nonatomic) NSString *offBackgroundImageString;
@property (strong, nonatomic) NSString *handleImageOnString;
@property (strong, nonatomic) NSString *handleImageOffString;
@property (strong, nonatomic) NSString *onStateString;
@property (strong, nonatomic) NSString *offStateString;
@property (strong, nonatomic) NSString *onActionString;
@property (strong, nonatomic) NSString *offActionString;

@end
