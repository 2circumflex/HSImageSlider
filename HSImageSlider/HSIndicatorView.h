//
//  HSIndicatorView.h
//
//  Created by LeeRowoon on 2016. 1. 7..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  하단에 표시할 (현재위치 / 총개수) 형식의 Indicator
 */
@interface HSIndicatorView : UIView

+ (CGSize)indicatorSizeWithTotalCount:(NSInteger)totalCount limitSize:(CGSize)limitSize;

- (void)setTitleWithCurrentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount;

@end
