//
//  HSImageSlider.h
//
//  Created by LeeRowoon on 2016. 1. 7..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - ImageSlider ENUM

/**
 *  스크롤 상태 ENUM
 */
typedef NS_ENUM(NSInteger, HSImageSliderScrollState) {
    /**
     *  한정된(Finite) 스크롤
     */
    HSImageSliderScrollStateFinite,
    
    /**
     *  무한(Infinite) 스크롤
     */
    HSImageSliderScrollStateInfinite
};

/**
 *  Indicator 상태 ENUM
 */
typedef NS_ENUM(NSInteger, HSImageSliderIndicatorState) {
    /**
     *  Indicator 보여줌
     */
    HSImageSliderIndicatorStateVisible,
    
    /**
     *  Indicator 안보여줌
     */
    HSImageSliderIndicatorStateInvisible
};

#pragma mark - HSImageSliderDataSource

@protocol HSImageSliderDataSource <NSObject>

@required

/**
 *  ImageSlider 이미지 개수
 *
 *  @return 이미지 개수
 */
- (NSInteger)countForImageSlider;

/**
 *  index에 있는 이미지 리턴
 *
 *  @param index 위치
 *
 *  @return 위치에 해당하는 이미지
 */
- (UIImage *)imageAtIndex:(NSInteger)index;

@optional

/**
 *  ImageSlider 스크롤 상태(한정, 무한정) 리턴
 *
 *  @return 스크롤 상태
 */
- (HSImageSliderScrollState)scrollStateForImageSlider;

/**
 *  ImageSlider 하단에 Indicator 상태(보여줌, 안보여줌) 리턴
 *
 *  @return Indicator 상태
 */
- (HSImageSliderIndicatorState)indicatorStateForImageSlider;

/**
 *  이미지 개수가 0개일때 표시할 문자열 리턴
 *
 *  @return 비었을때 타이틀 문자열
 */
- (NSString *)emptyStringForImageSlider;

@end

#pragma mark - HSImageSliderDelegate

@protocol HSImageSliderDelegate <NSObject>

@optional

/**
 *  index 번호에 해당하는 이미지로 이동했을때
 *
 *  @param index 이동한 위치
 */
- (void)didMoveToImageAtIndex:(NSInteger)index;

/**
 *  index 번호에 해당하는 이미지를 선택했을때
 *
 *  @param index 선택(싱글탭)한 위치
 */
- (void)didSelectImageAtIndex:(NSInteger)index;

@end

#pragma mark - HSImageSlider

@interface HSImageSlider : UIView

@property (nonatomic, weak) id <HSImageSliderDataSource> dataSource;
@property (nonatomic, weak) id <HSImageSliderDelegate> delegate;

@end
