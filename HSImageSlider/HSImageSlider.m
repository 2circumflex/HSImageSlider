//
//  HSImageSlider.m
//
//  Created by LeeRowoon on 2016. 1. 7..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import "HSImageSlider.h"
#import "HSIndicatorView.h"

/**
 *  기본 HSImageSliderScrollState 값
 */
static const enum HSImageSliderScrollState kDefaultScrollState = HSImageSliderScrollStateFinite;

/**
 *  기본 HSImageSliderIndicatorState 값
 */
static const enum HSImageSliderIndicatorState kDefaultIndicatorState = HSImageSliderIndicatorStateVisible;

/**
 *  HSImageSlider 비었을때 표시할 문자열 기본값
 */
static NSString * const kDefaultEmptyLabelString = @"Empty :)";

/**
 *  이미지 없을대 대체용 이미지
 */
static NSString * const kDefaultImageNotFound = @"image_not_found.png";

/**
 *  HSImageSlider 비었을때 표시할 문자열 폰트 사이즈 기본값
 */
static const float kDefaultEmptyLabelFontSize = 20.0f;


@interface HSImageSlider() <UIScrollViewDelegate>

/**
 *  스크롤뷰
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  하단 중앙에 Indicator
 */
@property (nonatomic, strong) HSIndicatorView *indicatorView;

/**
 *  Indicator 상태
 */
@property (nonatomic) enum HSImageSliderIndicatorState indicatorState;

/**
 *  이미지 array
 */
@property (nonatomic, strong) NSMutableArray *images;

/**
 *  스크롤뷰안에 추가된 UIImageView array
 */
@property (nonatomic, strong) NSMutableArray *imageViews;

/**
 *  스크롤 상태
 */
@property (nonatomic) enum HSImageSliderScrollState scrollState;

/**
 *  ImageSlider 개수
 */
@property (nonatomic) NSInteger count;

/**
 *  Imageslider 현재 위치
 */
@property (nonatomic) NSInteger currentIndex;

@end

@implementation HSImageSlider

#pragma mark - Private method

- (void)removeAllData {
    [_images removeAllObjects];
    [_imageViews removeAllObjects];
    
    [self initializeDefaultData];
}

- (void)initializeDefaultData {
    _count = 0;
    _currentIndex = 0;
    
    _indicatorState = kDefaultIndicatorState;
    _scrollState = kDefaultScrollState;
}

- (void)initializeData {
    [self initializeDefaultData];
    
    if (_dataSource) {
        // 총 개수
        _count = [_dataSource countForImageSlider];
        
        // 스크롤 상태
        if ([_dataSource respondsToSelector:@selector(scrollStateForImageSlider)]) {
            _scrollState = [_dataSource scrollStateForImageSlider];
        }
        
        // Indicator 상태
        if ([_dataSource respondsToSelector:@selector(indicatorStateForImageSlider)]) {
            _indicatorState = [_dataSource indicatorStateForImageSlider];
        }
    }
    
    // self.images(이미지 array) 생성, 초기화
    NSInteger imagesCount = [self getImagesCount];
    _images = [[NSMutableArray alloc] initWithCapacity:imagesCount];
    for (int i=0; i<imagesCount; i++) {
        [_images addObject:[NSNull null]];
    }
}

- (void)loadData {
    
    // 무한스크롤이고 2개 이상일때 현재 index를 +1개
    if (_scrollState == HSImageSliderScrollStateInfinite && _count >= 2) {
        _currentIndex++;
    }
    
    [self loadImage];
    [self moveToScrollPage];
    [self updateIndicator];
}

/**
 *  이미지 로드(현재위치, 이전, 다음)
 */
- (void)loadImage {
    [self loadImageAtIndex:_currentIndex];
    [self loadPrevImageAtIndex:_currentIndex];
    [self loadNextImageAtIndex:_currentIndex];
}

/**
 *  이전 이미지 로드
 */
- (void)loadPrevImageAtIndex:(NSInteger)index {
    if (index == 0) {
        return;
    } else {
        [self loadImageAtIndex:--index];
    }
}

/**
 *  다음 이미지 로드
 */
- (void)loadNextImageAtIndex:(NSInteger)index {
    if (index == ([self getImagesCount] - 1)) {
        return;
    } else {
        [self loadImageAtIndex:++index];
    }
}

/**
 *  index에 이미지 로드
 *
 *  @param index 로드할 이미지 index
 */
- (void)loadImageAtIndex:(NSInteger)index {
    id object = [_images objectAtIndex:index];
    if ([object isEqual:[NSNull null]]) {
        if (_dataSource) {
            NSInteger originalIndex = [self getOriginalIndexWithIndex:index];
            UIImage *image = [_dataSource imageAtIndex:originalIndex];
            
            // 이미지 없으면 image not found 이미지로 대체
            if (!image) {
                image = [UIImage imageNamed:kDefaultImageNotFound];
            }
            
            [_images replaceObjectAtIndex:index withObject:image];
            
            CGFloat scrollViewWidth = _scrollView.frame.size.width;
            CGRect imageViewRect = CGRectMake(scrollViewWidth * index, 0, scrollViewWidth, _scrollView.frame.size.height);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = image;
            
            [_imageViews replaceObjectAtIndex:index withObject:imageView];
            
            [_scrollView addSubview:imageView];
        }
    }
}

/**
 *  애니메이션 없이 원래 위치로 이동하기
 */
- (void)moveToScrollPage {
    if (_count == 1) {
        return;
    }
    
    if (_scrollState == HSImageSliderScrollStateInfinite) {
        NSInteger imagesCount = [self getImagesCount];
        CGFloat scrollViewWidth = _scrollView.frame.size.width;
        CGPoint contentPoint;
        if (_currentIndex == 0) {
            contentPoint = CGPointMake(scrollViewWidth * (imagesCount - 2), 0);
            _currentIndex = imagesCount - 2;
        } else if (_currentIndex == imagesCount-1) {
            contentPoint = CGPointMake(scrollViewWidth * 1, 0);
            _currentIndex = 1;
        } else {
            contentPoint = CGPointMake(scrollViewWidth * _currentIndex, 0);
        }
        [_scrollView setContentOffset:contentPoint animated:NO];
        
        [self loadImage];
        
    } else {
        return;
    }
}

/**
 *  스크롤 페이지 개수 리턴
 *
 *  @return 스크롤 페이지 개수
 */
- (NSInteger)getScrollPageCount {
    // 페이지개수랑 이미지개수랑 같아서 썼음
    return [self getImagesCount];
}

/**
 *  이미지 개수 리턴
 *
 *  @return 이미지 개수
 */
- (NSInteger)getImagesCount {
    if (_scrollState == HSImageSliderScrollStateInfinite && _count >= 2) {
        return _count + 2;
    } else {
        return _count;
    }
}

/**
 *  현재위치(currentIndex)의 실제 위치를 리턴
 */
- (NSInteger)getOriginalIndexAtCurrentIndex {
    return [self getOriginalIndexWithIndex:_currentIndex];
}

/**
 *  index의 원래 위치 리턴<br>
 *  이미지 개수가 2개 이상이고 무한스크롤일때 array 양쪽에 각 1개씩 아이템이 추가되서 2개가 추가됨<br>
 *  실제 위치랑 다르기 때문에 실제 위치를 찾기 위해서 만들었음
 *
 *  @param index 알고자하는 위치
 *
 *  @return 실제위치
 */
- (NSInteger)getOriginalIndexWithIndex:(NSInteger)index {
    if (_scrollState == HSImageSliderScrollStateInfinite) {
        if (_count == 1) {
            return 0;
        }
        
        NSInteger imagesCount = [self getImagesCount];;
        if (index == 0) {
            return imagesCount - 3;
        } else if (index == (imagesCount - 1)) {
            return 0;
        } else {
            return index - 1;
        }
        
    } else {
        return index;
    }
}

#pragma mark - Layout

- (void)layoutSubviews {
    [self removeAllViews];
    
    [self initializeData];
    [self initializeView];
}

#pragma mark - UI

/**
 *  모든 뷰 제거
 */
- (void)removeAllViews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

/**
 *  View 초기화
 */
- (void)initializeView {
    if (_count) {
        [self initializeScrollView];
        [self initializeIndicatorView];
        [self loadData];
    } else {
        [self initializeEmptyLabel];
    }
}

/**
 *  ScrollView 초기화
 */
- (void)initializeScrollView {
    
    // self.imageViews 생성, 초기화
    NSInteger scrollPageCount = [self getScrollPageCount];
    _imageViews = [[NSMutableArray alloc] initWithCapacity:scrollPageCount];
    for (int i=0; i<scrollPageCount; i++) {
        [_imageViews addObject:[NSNull null]];
    }
    
    CGRect scrollViewRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGSize scrollViewContentSize = CGSizeMake(scrollViewRect.size.width * scrollPageCount, scrollViewRect.size.height);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
    _scrollView.contentSize = scrollViewContentSize;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = self.autoresizingMask;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.delegate = self;
    
    /**
     * 싱글탭을 위한 GestureRecognizer 추가
     * 스크롤뷰에 추가해놓고 싱글탭 했을때 현재 페이지 번호로 구분
     */
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSingleTapped:)];
    [gestureRecognizer setNumberOfTapsRequired:1];
    [_scrollView addGestureRecognizer:gestureRecognizer];
    [_scrollView setUserInteractionEnabled:YES];
    
    [self addSubview:_scrollView];
}

/**
 *  하단 중앙에 보여줄 Indicator 초기화
 */
- (void)initializeIndicatorView {
    if (_indicatorState == HSImageSliderIndicatorStateVisible) {
        CGSize limitSize = CGSizeMake(self.frame.size.width, 50.0f);
        CGSize indicatorSize = [HSIndicatorView indicatorSizeWithTotalCount:_count limitSize:limitSize];
        
        CGRect indicatorRect = CGRectMake(0, 0, indicatorSize.width, indicatorSize.height);
        CGPoint indicatorCenterPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 70.0f);
        _indicatorView = [[HSIndicatorView alloc] initWithFrame:indicatorRect];
        _indicatorView.center = indicatorCenterPoint;
        
        [self addSubview:_indicatorView];
    }
}

/**
 *  이미지 개수 0개일때 보여줄 EmptyLabel 초기화
 */
- (void)initializeEmptyLabel {
    CGRect emptyLabelRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:emptyLabelRect];
    emptyLabel.backgroundColor = [UIColor whiteColor];
    emptyLabel.textColor = [UIColor blackColor];
    emptyLabel.font = [UIFont systemFontOfSize:kDefaultEmptyLabelFontSize];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([_dataSource respondsToSelector:@selector(emptyStringForImageSlider)]) {
        NSString *emptyString = [_dataSource emptyStringForImageSlider];
        emptyLabel.text = emptyString;
    } else {
        emptyLabel.text = kDefaultEmptyLabelString;
    }
    
    [self addSubview:emptyLabel];
}

/**
 *  Indicator 업데이트
 */
- (void)updateIndicator {
    NSInteger originalIndex = [self getOriginalIndexAtCurrentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 표시할 숫자는 +1개
        [_indicatorView setTitleWithCurrentIndex:(originalIndex + 1) totalCount:_count];
    });
}

#pragma mark - handle GestureRecognizer

/**
 *  이미지 싱글탭 했을때
 */
- (void)imageSingleTapped:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(didSelectImageAtIndex:)]) {
        NSInteger position = [self getOriginalIndexAtCurrentIndex];
        [_delegate didSelectImageAtIndex:position];
    }
}

#pragma mark - Protocol conformance
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 스크롤 페이지 번호 구하기
    CGFloat scrollViewWidth = _scrollView.frame.size.width;
    int page = floorf((_scrollView.contentOffset.x - scrollViewWidth/_count) / scrollViewWidth) + 1;
    
    // 현재 index 설정
    _currentIndex = page;
    
    // indicator 설정
    [self updateIndicator];
    
    // 이미지 이동했을때 delegate
    if ([_delegate respondsToSelector:@selector(didMoveToImageAtIndex:)]) {
        [_delegate didMoveToImageAtIndex:[self getOriginalIndexAtCurrentIndex]];
    }
    
    [self loadImage];
    [self moveToScrollPage];
}

@end
