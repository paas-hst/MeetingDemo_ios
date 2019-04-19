//
//  VideoHorizontalFlowLayout.m
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import "VideoHorizontalFlowLayout.h"

@interface VideoHorizontalFlowLayout ()

@property (nonatomic, strong) NSMutableArray *allAttributes;    // 存储所有item的布局属性
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;

@end

@implementation VideoHorizontalFlowLayout

- (void)prepareLayout {
    [super prepareLayout];

    if (self.allAttributes.count) {
        [_allAttributes removeAllObjects];
    }

    CGSize size = self.collectionView.frame.size;
    _itemWidth = (size.width - (_columnSpacing * (_column - 1))) / _column;
    _itemHeight = (size.height - (_lineSpacing * (_row - 1))) / _row;

    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = _lineSpacing;
    self.minimumInteritemSpacing = _columnSpacing;
    self.itemSize = CGSizeMake(_itemWidth, _itemHeight);

    NSUInteger section = [self.collectionView numberOfSections];
    for (int i = 0; i < section; i++) {
        NSUInteger items = [self.collectionView numberOfItemsInSection:i];
        for (int item = 0; item < items; item++) {
            // 获取每一个item的布局属性
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:i];
            UICollectionViewLayoutAttributes *itemAttribute = [self layoutAttributesForItemAtIndexPath:indexPath];
            [_allAttributes addObject:itemAttribute];
        }
    }
}


- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 计算单页item的布局属性，多页后面加入
    NSUInteger item = indexPath.item;
    NSUInteger row = item / _column;
    NSUInteger cloumn = item % _column;
    // 每个item的 x = cloumn *（列间 + itemWidth）
    CGFloat x = cloumn * (self.minimumInteritemSpacing + _itemWidth);
    // 每个item的 y = row *（行间 + itemHeight）
    CGFloat y = row * (self.minimumLineSpacing + _itemHeight);
    attribute.frame = CGRectMake(x, y, _itemWidth, _itemHeight);

    return attribute;
}


// 返回可视视图的rect
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _allAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSMutableArray *)allAttributes {
    if (!_allAttributes) {
        _allAttributes = [[NSMutableArray alloc] initWithCapacity:0];
    }

    return _allAttributes;
}

@end
