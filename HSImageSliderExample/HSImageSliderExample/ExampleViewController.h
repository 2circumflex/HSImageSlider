//
//  ExampleViewController.h
//  HSImageSliderExample
//
//  Created by LeeRowoon on 2016. 1. 8..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExampleViewController : UIViewController

// 무한스크롤 여부
@property (nonatomic) BOOL isInfiniteScroll;

// 하단 인디케이터 표시 여부
@property (nonatomic) BOOL isIndicatorVisible;

// 이미지개수
@property (nonatomic) NSInteger imageCount;

@end
