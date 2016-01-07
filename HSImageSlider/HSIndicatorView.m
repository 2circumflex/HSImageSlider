//
//  HSIndicatorView.m
//
//  Created by LeeRowoon on 2016. 1. 7..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import "HSIndicatorView.h"

/**
 *  Indicator 타이틀 문자열 형식
 *  예 : 1 / 30
 */
static NSString * const kIndicatorTitleStringType = @"%ld / %ld";

/**
 *  Indicator 배경 기본 투명값
 */
static const float kDefaultOpacity = 0.7f;

/**
 *  기본 Indicator 타이틀 폰트 사이즈
 */
static const float kDefaultFontSize = 15.0f;

@interface HSIndicatorView ()

/**
 *  배경뷰
 */
@property (nonatomic, strong) UIView *backgroundView;

/**
 *  타이틀 레이블
 *  예 : 1 / 30
 */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HSIndicatorView

#pragma mark - Class methods

/**
 *  총개수와 한계사이즈를 가지고 IndicatorView의 사이즈 리턴
 *
 *  @param totalCount 총 개수
 *  @param limitSize  한계(최대) 사이즈
 *
 *  @return IndicatorView 사이즈
 */
+ (CGSize)indicatorSizeWithTotalCount:(NSInteger)totalCount limitSize:(CGSize)limitSize {
    NSString *titleString = [NSString stringWithFormat:kIndicatorTitleStringType, (long)totalCount, (long)totalCount];
    
    CGRect titleRect = [titleString boundingRectWithSize:limitSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{
                                                           NSFontAttributeName:[UIFont systemFontOfSize:kDefaultFontSize]
                                                           }
                                                 context:nil];
    
    CGFloat width = titleRect.size.width + 20.0f;
    CGFloat height = titleRect.size.height + 15.0f;
    
    CGSize indicatorRect = CGSizeMake(MIN(width, limitSize.width), MIN(height, limitSize.height));
    return indicatorRect;
}

#pragma mark - Layout

- (void)layoutSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self initializeView];
}

#pragma mark - UI

/**
 *  뷰 초기화
 */
- (void)initializeView {
    [self initializeBackgroundView];
    [self initializeTitleLabel];
}

/**
 *  배경뷰 초기화
 */
- (void)initializeBackgroundView {
    CGSize backgroundSize = self.frame.size;
    CGRect backgroundRect = CGRectMake(0, 0, backgroundSize.width, backgroundSize.height);
    
    _backgroundView = [[UIView alloc] initWithFrame:backgroundRect];
    _backgroundView.backgroundColor = [UIColor darkGrayColor];
    _backgroundView.layer.cornerRadius = 4.0;
    _backgroundView.layer.opacity = kDefaultOpacity;
    
    [self addSubview:_backgroundView];
}

/**
 *  타이틀 레이블 초기화
 */
- (void)initializeTitleLabel {
    CGSize titleSize = self.frame.size;
    CGRect titleRect = CGRectMake(0, 0, titleSize.width, titleSize.height);
    
    _titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:kDefaultFontSize];
    _titleLabel.text = @"";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleLabel];
}

#pragma mark - Accessor

/**
 *  현재위치와 총개수로 IndicatorView의 타이틀 설정
 *
 *  @param currentIndex 현재 위치
 *  @param totalCount   총 개수
 */
- (void)setTitleWithCurrentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount {
    NSString *titleString = [NSString stringWithFormat:kIndicatorTitleStringType, (long)currentIndex, (long)totalCount];
    _titleLabel.text = titleString;
}

@end
