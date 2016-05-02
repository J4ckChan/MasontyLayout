//
//  MasontyLayout.h
//  MasontyLayout
//
//  Created by ChanLiang on 5/2/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasontyLayout;

@protocol MasontyLayoutDelegate <NSObject>

@required
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(MasontyLayout *)masontyLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface MasontyLayout : UICollectionViewFlowLayout

@property (nonatomic,assign) id<MasontyLayoutDelegate> delegate;
@property (nonatomic,assign) NSUInteger numberOfColumns;
@property (nonatomic,assign) CGFloat spacingOfItem;

@end
