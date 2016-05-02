//
//  MasontyLayout.m
//  MasontyLayout
//
//  Created by ChanLiang on 5/2/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

#import "MasontyLayout.h"

@interface MasontyLayout ()

@property (nonatomic,strong) NSMutableDictionary *maxYDict;
@property (nonatomic,strong) NSMutableDictionary *layoutInfoCacheDict;

@end

@implementation MasontyLayout

-(void)prepareLayout{
    [super prepareLayout];
    [self setupItemsAttributes];
}

- (void)setupItemsAttributes{
   
    _maxYDict            = [[NSMutableDictionary alloc]init];
    _layoutInfoCacheDict = [[NSMutableDictionary alloc]init];
    
    NSUInteger currentColumn = 0;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (self.numberOfColumns+1)*self.spacingOfItem)/self.numberOfColumns;
    NSUInteger numOfSections = [self.collectionView numberOfSections];
    NSIndexPath *indexPath;
    
    for (NSInteger section = 0; section < numOfSections; section++) {
        
        NSUInteger numOfItems = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < numOfItems; item++) {
            
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            //caculate every item frame
            CGFloat itemHeight = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
            CGFloat x = _spacingOfItem + (_spacingOfItem + itemWidth) * currentColumn;
            CGFloat y = [_maxYDict[@(currentColumn)] doubleValue];
            
            //store in dictionary
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(x, y, itemWidth, itemHeight);
            _layoutInfoCacheDict[indexPath] = itemAttributes;
            
            y += (itemHeight + _spacingOfItem);
            _maxYDict[@(currentColumn)] = @(y);
            
            currentColumn++;
            if (currentColumn == _numberOfColumns) {
                currentColumn = 0;
            }
        }
    }
}

- (CGSize)collectionViewContentSize{
    CGFloat maxY = 0;
    for (NSUInteger currentColumn = 0; currentColumn < _numberOfColumns; currentColumn++) {
        if ([_maxYDict[@(currentColumn)] doubleValue]> maxY) {
            maxY = [_maxYDict[@(currentColumn)] doubleValue];
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, maxY);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attributesArray = [[NSMutableArray alloc]init];
    
    [_layoutInfoCacheDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attributes = (UICollectionViewLayoutAttributes*)obj;
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArray addObject:attributes];
        }
    }];
    return attributesArray;
}

@end
