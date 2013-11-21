//
//  TBViewController.m
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import "TBViewController.h"
#import "TBSliderSwitch.h"

@interface TBViewController ()

@end

@implementation TBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //Create the Circular Slider
    TBSliderSwitch *slider = [[TBSliderSwitch alloc]initWithFrame:CGRectMake(10, 60, TB_SLIDER_WIDTH, TB_SLIDER_HEIGHT)];
    
    //Define Target-Action behaviour
    [slider addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:slider];
}

/** This function is called when Circular slider value changes **/
-(void)switchChanged:(TBSliderSwitch*)sender{
    TBSliderSwitch *slider = (TBSliderSwitch*)sender;
    NSLog(@"Slider Switch is: %@",slider.on ? @"On" : @"Off");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
