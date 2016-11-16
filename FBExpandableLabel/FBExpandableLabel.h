//
//  FBExpandableLabel.h
//  ARSeek
//
//  Created by fb on 16/11/14.
//  Copyright © 2016年 ARSeeds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBExpandableLabel : UILabel

@property (nonatomic, assign) NSInteger maxLinesWhenUnexpand; //收起状态最大行数

@property (nonatomic, copy) NSString* subfixWhenUnexpand; //收起状态下的后缀

@property (nonatomic, strong) UIColor* subfixColor;

- (void)setTruncatingText:(NSString*)string;

@end
