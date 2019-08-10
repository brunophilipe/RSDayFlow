//
// RSDFDatePickerCollectionViewLayout.m
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

#import "RSDFDatePickerCollectionViewLayout.h"

@interface RSDFDatePickerCollectionViewLayout ()

@property (assign, nonatomic) RSDFDatePickerCollectionViewLayoutDirection direction;

@end

@implementation RSDFDatePickerCollectionViewLayout

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInitializer];
        _direction = RSDFDatePickerCollectionViewLayoutDirectionLeftToRight;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitializer];
        _direction = RSDFDatePickerCollectionViewLayoutDirectionLeftToRight;
    }
    return self;
}

- (instancetype)initWithDirection:(RSDFDatePickerCollectionViewLayoutDirection)direction
{
    self = [super init];
    if (self) {
        [self commonInitializer];
        _direction = direction;
    }
    return self;
}

- (void)commonInitializer
{
    _numberOfItemsPerRow = 7;
    self.minimumLineSpacing = [self selfMinimumLineSpacing];
    self.minimumInteritemSpacing = [self selfMinimumInteritemSpacing];
}

#pragma mark - Attributes of the Layout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
    
    if (self.direction == RSDFDatePickerCollectionViewLayoutDirectionRightToLeft) {
        for (UICollectionViewLayoutAttributes *attributes in superAttributes) {
            CGRect frame = attributes.frame;
            frame.origin.x = CGRectGetWidth(rect) - CGRectGetWidth(attributes.frame) - CGRectGetMinX(attributes.frame);
            attributes.frame = frame;
        }
    }
    
    return superAttributes;
}

- (CGSize)selfHeaderReferenceSize
{
    CGFloat selfHeaderReferenceWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat selfHeaderReferenceHeight = 64.0f;
    
    return (CGSize){ selfHeaderReferenceWidth, selfHeaderReferenceHeight };
}

- (CGSize)itemSizeForIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger numberOfItemsPerRow = [self numberOfItemsPerRow];
    CGFloat totalInteritemSpacing = [self minimumInteritemSpacing] * (CGFloat)(numberOfItemsPerRow - 1);

    UIEdgeInsets layoutMargins = [[self collectionView] layoutMargins];
    CGFloat usefulWidth = UIEdgeInsetsInsetRect([[self collectionView] frame], layoutMargins).size.width;

    CGFloat selfItemWidth = (usefulWidth - totalInteritemSpacing) / (CGFloat)numberOfItemsPerRow;
    selfItemWidth = floor(selfItemWidth * 1000) / 1000;
    CGFloat selfItemHeight = 70.0f;

    if (indexPath.item % numberOfItemsPerRow == 0) { // First in row, inset from left
        selfItemWidth += layoutMargins.left;
    }
    else if (indexPath.item % numberOfItemsPerRow == numberOfItemsPerRow - 1) { // Last in row, inset from right
        selfItemWidth += layoutMargins.right;
    }
    
    return CGSizeMake(selfItemWidth, selfItemHeight);
}

- (CGFloat)selfMinimumLineSpacing
{
    return 2.0f;
}

- (CGFloat)selfMinimumInteritemSpacing
{
    return 2.0f;
}

@end
