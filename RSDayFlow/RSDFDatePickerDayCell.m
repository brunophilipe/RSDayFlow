//
// RSDFDatePickerDayCell.m
//
// Copyright (c) 2013 Evadne Wu, http://radi.ws/
// Copyright (c) 2013-2016 Ruslan Skorb, http://ruslanskorb.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RSDFDatePickerDayCell.h"

CGFloat roundOnBase(CGFloat x, CGFloat base) {
    return round(x * base) / base;
}

@interface RSDFDatePickerDayCell ()

+ (NSCache *)imageCache;
+ (id)fetchObjectForKey:(id)key withCreator:(id(^)(void))block;

@property (nonatomic, readonly, strong) UIImageView *selectedDayImageView;
@property (nonatomic, readonly, strong) UIImageView *overlayImageView;
@property (nonatomic, readonly, strong) UIImageView *markImageView;
@property (nonatomic, readonly, strong) UIImageView *dividerImageView;

@end

@implementation RSDFDatePickerDayCell

@synthesize dateLabel = _dateLabel;
@synthesize selectedDayImageView = _selectedDayImageView;
@synthesize overlayImageView = _overlayImageView;
@synthesize markImage = _markImage;
@synthesize markImageColor = _markImageColor;
@synthesize markImageView = _markImageView;
@synthesize dividerImageView = _dividerImageView;

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (void)commonInitializer
{
    self.backgroundColor = [self selfBackgroundColor];
    
    [self addSubview:self.selectedDayImageView];
    [self addSubview:self.overlayImageView];
    [self addSubview:self.markImageView];
    [self addSubview:self.dividerImageView];
    [self addSubview:self.dateLabel];
    
    [self updateSubviews];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    if ([_selectedDayImageView translatesAutoresizingMaskIntoConstraints]) {
        [_selectedDayImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self installDateViewConstraintsOntoView:_selectedDayImageView];
    }

    if ([_overlayImageView translatesAutoresizingMaskIntoConstraints]) {
        [_overlayImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self installDateViewConstraintsOntoView:_overlayImageView];
    }

    if ([_markImageView translatesAutoresizingMaskIntoConstraints]) {
        [_markImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self installMarkImageConstraintsOntoView:_markImageView];
    }

    if ([_dateLabel translatesAutoresizingMaskIntoConstraints]) {
        [_dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self installDateViewConstraintsOntoView:_dateLabel];
    }

    [super updateConstraints];
}

- (void)layoutSubviews
{
    self.dividerImageView.frame = [self dividerImageViewFrame];

    [super layoutSubviews];

    [self updateImages];
    [self updateSubviews];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateSubviews];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateSubviews];
}

#pragma mark - Custom Accessors

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (UIImageView *)dividerImageView
{
    if (!_dividerImageView) {
        _dividerImageView = [[UIImageView alloc] initWithFrame:[self dividerImageViewFrame]];
        _dividerImageView.contentMode = UIViewContentModeCenter;
    }
    return _dividerImageView;
}

- (CGRect)dividerImageViewFrame
{
    return CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame) + 3.0f, roundOnBase(0.5f, [UIScreen mainScreen].scale));
}

- (void)installMarkImageConstraintsOntoView:(UIView *)view
{
    UIView *superview = [view superview];
    CGFloat scale = [UIScreen mainScreen].scale;

    assert(superview);

    [NSLayoutConstraint activateConstraints:@[
        [[[superview layoutMarginsGuide] centerXAnchor] constraintEqualToAnchor:[view centerXAnchor]],
        [[view topAnchor] constraintEqualToAnchor:[superview topAnchor] constant:roundOnBase(45.5f, scale)],
        [[view widthAnchor] constraintEqualToConstant:9.0f],
        [[view heightAnchor] constraintEqualToConstant:9.0f],
    ]];
}

- (UIImage *)markImage
{
    if (!_markImage) {
        NSString *markImageKey = [NSString stringWithFormat:@"img_mark_%@", [self.markImageColor description]];
        _markImage = [self ellipseImageWithKey:markImageKey
                                         frame:self.markImageView.frame
                                         color:self.markImageColor];
    }
    return _markImage;
}

- (UIColor *)markImageColor
{
    if (!_markImageColor) {
        _markImageColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
    }
    return _markImageColor;
}

- (UIImageView *)markImageView
{
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _markImageView.backgroundColor = [UIColor clearColor];
        _markImageView.contentMode = UIViewContentModeCenter;
    }
    return _markImageView;
}

- (UIImageView *)overlayImageView
{
    if (!_overlayImageView) {
        _overlayImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _overlayImageView.backgroundColor = [UIColor clearColor];
        _overlayImageView.opaque = NO;
        _overlayImageView.alpha = 0.5f;
        _overlayImageView.contentMode = UIViewContentModeCenter;
    }
    return _overlayImageView;
}

- (UIImageView *)selectedDayImageView
{
    if (!_selectedDayImageView) {
        _selectedDayImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _selectedDayImageView.backgroundColor = [UIColor clearColor];
        _selectedDayImageView.contentMode = UIViewContentModeCenter;
    }
    return _selectedDayImageView;
}

- (void)installDateViewConstraintsOntoView:(UIView *)view
{
    UIView *superview = [view superview];
    CGFloat scale = [UIScreen mainScreen].scale;

    assert(superview);

    [NSLayoutConstraint activateConstraints:@[
        [[[superview layoutMarginsGuide] centerXAnchor] constraintEqualToAnchor:[view centerXAnchor]],
        [[view topAnchor] constraintEqualToAnchor:[superview topAnchor] constant:roundOnBase(5.5, scale)],
        [[view widthAnchor] constraintEqualToConstant:35.0f],
        [[view heightAnchor] constraintEqualToConstant:35.0f],
    ]];
}

- (void)setMarkImage:(UIImage *)markImage
{
    if (![_markImage isEqual:markImage]) {
        _markImage = markImage;
        
        [self updateSubviews];
    }
}

- (void)setMarkImageColor:(UIColor *)markImageColor
{
    if (![_markImageColor isEqual:markImageColor]) {
        _markImageColor = markImageColor;
        _markImage = nil;
        
        [self updateSubviews];
    }
}

#pragma mark - Private

- (void)updateSubviews
{
    self.selectedDayImageView.hidden = !self.isSelected || self.isNotThisMonth || self.isOutOfRange;
    self.overlayImageView.hidden = !self.isHighlighted || self.isNotThisMonth || self.isOutOfRange;
    self.markImageView.hidden = !self.isMarked || self.isNotThisMonth || self.isOutOfRange;
    self.dividerImageView.hidden = self.isNotThisMonth;

    if (self.isNotThisMonth) {
        self.dateLabel.textColor = [self notThisMonthLabelTextColor];
        self.dateLabel.font = [self dayLabelFont];
    } else {
        if (self.isOutOfRange) {
            self.dateLabel.textColor = [self outOfRangeDayLabelTextColor];
            self.dateLabel.font = [self outOfRangeDayLabelFont];
        } else {
            if (!self.isSelected) {
                if (!self.isToday) {
                    self.dateLabel.font = [self dayLabelFont];
                    if (!self.dayOff) {
                        if (self.isPastDate) {
                            self.dateLabel.textColor = [self pastDayLabelTextColor];
                        } else {
                            self.dateLabel.textColor = [self dayLabelTextColor];
                        }
                    } else {
                        if (self.isPastDate) {
                            self.dateLabel.textColor = [self pastDayOffLabelTextColor];
                        } else {
                            self.dateLabel.textColor = [self dayOffLabelTextColor];
                        }
                    }
                } else {
                    self.dateLabel.font = [self todayLabelFont];
                    self.dateLabel.textColor = [self todayLabelTextColor];
                }
                
            } else {
                if (!self.isToday) {
                    self.dateLabel.font = [self selectedDayLabelFont];
                    self.dateLabel.textColor = [self selectedDayLabelTextColor];
                    self.selectedDayImageView.image = [self selectedDayImage];
                } else {
                    self.dateLabel.font = [self selectedTodayLabelFont];
                    self.dateLabel.textColor = [self selectedTodayLabelTextColor];
                    self.selectedDayImageView.image = [self selectedTodayImage];
                }
            }
            
            if (self.marked) {
                self.markImageView.image = self.markImage;
            } else {
                self.markImageView.image = nil;
            }
        }
    }

}

- (void)updateImages
{
    _dividerImageView.image = [self dividerImage];
    _markImageView.image = [self markImage];
    _overlayImageView.image = [self overlayImage];
    _selectedDayImageView.image = [self selectedDayImage];
}

+ (NSCache *)imageCache
{
    static NSCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSCache new];
    });
    return cache;
}

+ (id)fetchObjectForKey:(id)key withCreator:(id(^)(void))block
{
    id answer = [[self imageCache] objectForKey:key];
    if (!answer) {
        answer = block();
        if (answer) {
            [[self imageCache] setObject:answer forKey:key];
        }
    }
    return answer;
}

- (UIImage *)ellipseImageWithKey:(NSString *)key frame:(CGRect)frame color:(UIColor *)color
{
    if ([self window] == nil || frame.size.width == 0 || frame.size.height == 0) {
        return nil;
    }

    UIImage *ellipseImage = [[self class] fetchObjectForKey:key withCreator:^id{
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, self.window.screen.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGRect rect = frame;
        rect.origin = CGPointZero;
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillEllipseInRect(context, rect);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }];
    return ellipseImage;
}

- (UIImage *)rectImageWithKey:(NSString *)key frame:(CGRect)frame color:(UIColor *)color
{
    if ([self window] == nil || frame.size.width == 0 || frame.size.height == 0) {
        return nil;
    }

    UIImage *rectImage = [[self class] fetchObjectForKey:key withCreator:^id{
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, self.window.screen.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, frame);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }];
    return rectImage;
}

#pragma mark - Atrributes of the View

- (UIColor *)selfBackgroundColor
{
    return [UIColor clearColor];
}

#pragma mark - Attributes of Subviews

- (UIFont *)dayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)dayLabelTextColor
{
	if (@available(iOS 13.0, *)) {
		return [UIColor labelColor];
	} else {
		return [UIColor blackColor];
	}
}

- (UIColor *)dayOffLabelTextColor
{
	if (@available(iOS 13.0, *)) {
		return [UIColor secondaryLabelColor];
	} else {
		return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
	}
}

- (UIColor *)outOfRangeDayLabelTextColor
{
	if (@available(iOS 13.0, *)) {
		return [UIColor tertiaryLabelColor];
	} else {
		return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
	}
}

- (UIFont *)outOfRangeDayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)notThisMonthLabelTextColor
{
    return [UIColor clearColor];
}

- (UIColor *)pastDayLabelTextColor
{
    return [self dayLabelTextColor];
}

- (UIColor *)pastDayOffLabelTextColor
{
    return [self dayOffLabelTextColor];
}

- (UIFont *)todayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)todayLabelTextColor
{
    return [UIColor systemBlueColor];
}

- (UIFont *)selectedTodayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
}

- (UIColor *)selectedTodayLabelTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)selectedTodayImageColor
{
    return [UIColor systemBlueColor];
}

- (UIImage *)customSelectedTodayImage
{
    return nil;
}

- (UIImage *)selectedTodayImage
{
    UIImage *selectedTodayImage = [self customSelectedTodayImage];
    if (!selectedTodayImage) {
        UIColor *selectedTodayImageColor = [self selectedTodayImageColor];
        NSString *selectedTodayImageKey = [NSString stringWithFormat:@"img_selected_today_%@", [selectedTodayImageColor description]];
        selectedTodayImage = [self ellipseImageWithKey:selectedTodayImageKey
                                                 frame:self.selectedDayImageView.frame
                                                 color:selectedTodayImageColor];
    }
    return selectedTodayImage;
}

- (UIFont *)selectedDayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
}

- (UIColor *)selectedDayLabelTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)selectedDayImageColor
{
    return [UIColor systemRedColor];
}

- (UIImage *)customSelectedDayImage
{
    return nil;
}

- (UIImage *)selectedDayImage
{
    UIImage *selectedDayImage = [self customSelectedDayImage];
    if (!selectedDayImage) {
        UIColor *selectedDayImageColor = [self selectedDayImageColor];
        NSString *selectedDayImageKey = [NSString stringWithFormat:@"img_selected_day_%@", [selectedDayImageColor description]];
        selectedDayImage = [self ellipseImageWithKey:selectedDayImageKey
                                               frame:self.selectedDayImageView.frame
                                               color:selectedDayImageColor];
    }
    return selectedDayImage;
}

- (UIColor *)overlayImageColor
{
    return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
}

- (UIImage *)customOverlayImage
{
    return nil;
}

- (UIImage *)overlayImage
{
    UIImage *overlayImage = [self customOverlayImage];
    if (!overlayImage) {
        UIColor *overlayImageColor = [self overlayImageColor];
        NSString *overlayImageKey = [NSString stringWithFormat:@"img_overlay_%@", [overlayImageColor description]];
        overlayImage = [self ellipseImageWithKey:overlayImageKey frame:self.overlayImageView.frame color:overlayImageColor];
    }
    return overlayImage;
}

- (UIColor *)dividerImageColor
{
	if (@available(iOS 13.0, *)) {
		return [UIColor systemFillColor];
	} else {
		return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];
	}
}

- (UIImage *)customDividerImage
{
    return nil;
}

- (UIImage *)dividerImage
{
    UIImage *dividerImage = [self customDividerImage];
    if (!dividerImage) {
        UIColor *dividerImageColor = [self dividerImageColor];
        NSString *dividerImageKey = [NSString stringWithFormat:@"img_divider_%@_%g", [dividerImageColor description], CGRectGetWidth(self.dividerImageView.frame)];
        dividerImage = [self rectImageWithKey:dividerImageKey
                                        frame:self.dividerImageView.frame
                                        color:dividerImageColor];
    }
    return dividerImage;
}

@end
