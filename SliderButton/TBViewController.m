//
//  TBViewController.m
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import "TBViewController.h"
#import "TBSliderButton.h"

@interface TBViewController ()

@end

@implementation TBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    
    //Create the Circular Slider
    TBSliderButton *slider = [[TBSliderButton alloc]initWithFrame:CGRectMake(10, 60, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    
    //Define Target-Action behaviour
    [slider addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:slider];
}

/** This function is called when Circular slider value changes **/
-(void)newValue:(TBSliderButton*)slider{
    //TBSliderButton *slider = (TBSliderButton*)sender;
//    NSLog(@"Handle Pos %f",slider.handlePos);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
