//
//  ExampleViewController.m
//  HSImageSliderExample
//
//  Created by LeeRowoon on 2016. 1. 8..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import "ExampleViewController.h"
#import "HSImageSlider.h"

@interface ExampleViewController () <HSImageSliderDataSource, HSImageSliderDelegate>

@property (nonatomic, strong) HSImageSlider *imageSlider;

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                      @"거봉.jpg",
                      @"골드키위.jpg",
                      @"구아바.jpg",
                      @"귤.jpg",
                      @"단감.jpg",
                      @"대추.jpg",
                      @"딸기.jpg",
                      @"라임.jpg",
                      @"라즈베리.jpg",
                      @"레몬.jpg",
                      @"리치.jpg",
                      @"망고.jpg",
                      @"망고스틴.jpg",
                      @"매실.jpg",
                      @"멜론.jpg",
                      @"모과.jpg",
                      @"무화과.jpg",
                      @"바나나.jpg",
                      @"배.jpg",
                      @"복숭아.jpg",
                      @"블랙베리.jpg",
                      @"블루베리.jpg",
                      @"사과.jpg",
                      @"살구.jpg",
                      @"석류.jpg",
                      @"수박.jpg",
                      @"애플망고.jpg",
                      @"오디.jpg",
                      @"오렌지.jpg",
                      @"용과.jpg",
                      @"유자.jpg",
                      @"자두.jpg",
                      @"자몽.jpg",
                      @"참외.jpg",
                      @"천도복숭아.jpg",
                      @"청포도.jpg",
                      @"체리.jpg",
                      @"코코넛.jpg",
                      @"키위.jpg",
                      @"파인애플.jpg",
                      @"파파야.jpg",
                      @"포도.jpg",
                      @"홍시.jpg"
                      ];
    
    // 이미지 array
    _images = [NSMutableArray array];
    for (int i=0; i<_imageCount; i++) {
        [_images addObject:[array objectAtIndex:i]];
    }
    
    // HSImageSlider 생성, 추가
    CGRect imageSliderRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _imageSlider = [[HSImageSlider alloc] initWithFrame:imageSliderRect];
    _imageSlider.dataSource = self;
    _imageSlider.delegate = self;
    [self.view addSubview:_imageSlider];
    
    // 닫기버튼 추가
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 30, 80.0f, 30.0f)];
    [closeButton setTitle:@"닫기" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeModal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

#pragma mark - Action

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HSImageSliderDataSource

- (NSInteger)countForImageSlider {
    if (_images) {
        return [_images count];
    } else {
        return 0;
    }
}

- (UIImage *)imageAtIndex:(NSInteger)index {
    NSString *imageName = [_images objectAtIndex:index];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

- (HSImageSliderScrollState)scrollStateForImageSlider {
    if (_isInfiniteScroll) {
        return HSImageSliderScrollStateInfinite;
    } else {
        return HSImageSliderScrollStateFinite;
    }
}

- (HSImageSliderIndicatorState)indicatorStateForImageSlider {
    if (_isIndicatorVisible) {
        return HSImageSliderIndicatorStateVisible;
    } else {
        return HSImageSliderIndicatorStateInvisible;
    }
}

#pragma mark - HSImageSliderDelegate

- (void)didMoveToImageAtIndex:(NSInteger)index {
    NSLog(@"%ld번째로 이동", (long)index);
}

- (void)didSelectImageAtIndex:(NSInteger)index {
    NSLog(@"%ld번째 선택", (long)index);
}

@end
