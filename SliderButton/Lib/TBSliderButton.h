//
//  TBSliderButton.h
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Parameters **/
#define TB_SLIDER_SIZE 320                          //The width and the heigth of the slider
#define TB_BACKGROUND_WIDTH 60                      //The width of the dark background
#define TB_LINE_WIDTH 40                            //The width of the active area (the gradient) and the width of the handle
/*#define TB_FONTSIZE 48                                  //The size of the textfield font
#define TB_FONTFAMILY @"Futura-CondensedExtraBold"  //The font family of the textfield font
*/

#define TB_FONTSIZE 36                                  //The size of the textfield font
#define TB_FONTFAMILY @"ArialMT"  //The font family of the textfield font

@interface TBSliderButton : UIControl

@property (strong, nonatomic) NSString *bgImageOnString;    // Change name bgImageOnString
@property (strong, nonatomic) NSString *bgImageOffString;
@property (strong, nonatomic) NSString *handleImageOnString;
@property (strong, nonatomic) NSString *handleImageOffString;
@property (strong, nonatomic) NSString *onStateString;
@property (strong, nonatomic) NSString *offStateString;
@property (strong, nonatomic) NSString *onActionString;
@property (strong, nonatomic) NSString *offActionString;

@end
