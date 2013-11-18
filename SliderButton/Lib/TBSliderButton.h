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
@property (strong, nonatomic) UIColor *bgColorOn;
@property (strong, nonatomic) UIColor *bgColorOff;
@property (strong, nonatomic) UIColor *fgColorOn;
@property (strong, nonatomic) UIColor *fgColorOff;
@property (strong, nonatomic) NSString *bgImageOnName;
@property (strong, nonatomic) NSString *bgImageOffName;
@property (strong, nonatomic) NSString *handleImageOnName;
@property (strong, nonatomic) NSString *handleImageOffName;
@property (strong, nonatomic) NSString *labelStringOnName;
@property (strong, nonatomic) NSString *labelStringOffName;

@property (assign, nonatomic) BOOL isOn;
@property (assign, nonatomic) float panStartX;
@property (assign, nonatomic) float labelStartXPos;
@property (assign, nonatomic) float labelWidth;
@property (assign, nonatomic) float buttonWidth;
@property (assign, nonatomic) float handleWidth;
@property (assign, nonatomic) float handlePos;
@property (assign, nonatomic) float handleStartPos;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *handleImageView;
@property (strong, nonatomic) UILabel *labelField;
@property (strong, nonatomic) UIImage *bgImageOff;
@property (strong, nonatomic) UIImage *handleImageOff;
@property (strong, nonatomic) UIImage *bgImageOn;
@property (strong, nonatomic) UIImage *handleImageOn;
@property (strong, nonatomic) NSString *label;
@end
