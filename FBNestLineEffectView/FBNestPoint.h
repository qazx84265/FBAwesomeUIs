//
//  FBNestPoint.h
//  Just4Test
//
//  Created by ARSeeds on 16/8/11.
//  Copyright © 2016年 ARSeeds. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@interface FBNestPoint : NSObject
@property (nonatomic, assign) CGFloat x; //
@property (nonatomic, assign) CGFloat y; //
@property (nonatomic, assign) CGFloat xa; //x轴随机位移
@property (nonatomic, assign) CGFloat ya; //y轴随机位移
@property (nonatomic, assign) CGFloat maxDist; //点之间最大黏性距离
@end
