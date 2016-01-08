//
//  ViewController.m
//  HSImageSliderExample
//
//  Created by LeeRowoon on 2016. 1. 8..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import "ViewController.h"
#import "ExampleViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *infiniteScrollSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *indicatorSwitch;

@property (weak, nonatomic) IBOutlet UIStepper *imageCountStepper;

@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageCountStepper.maximumValue = 43.0;
    _imageCountStepper.minimumValue = 0.0;
    _imageCountStepper.stepValue = 1.0;
    _imageCountStepper.value = 43.0;
    [_imageCountStepper addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ImageSliderSegue"]) {
        ExampleViewController *controller = (ExampleViewController *)segue.destinationViewController;
        controller.isInfiniteScroll = _infiniteScrollSwitch.on;
        controller.isIndicatorVisible = _indicatorSwitch.on;
        controller.imageCount = (long)_imageCountStepper.value;
    }
}

- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    NSString *imageCountString = @"이미지 개수 : %d";
    [_imageCountLabel setText:[NSString stringWithFormat:imageCountString, (int)value]];
}

@end
