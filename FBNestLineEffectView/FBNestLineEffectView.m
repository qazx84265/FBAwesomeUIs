//
//  FBNestLineEffectView.m
//  Just4Test
//
//  Created by ARSeeds on 16/8/11.
//  Copyright © 2016年 ARSeeds. All rights reserved.
//

#import "FBNestLineEffectView.h"
#import "FBNestPoint.h"

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define ARC4RANDOM_MAX 0xFFFFFFFF

@interface FBNestLineEffectView()
@property (nonatomic, strong) NSMutableArray* nestPoints;
@property (nonatomic, strong) FBNestPoint* currentPoint;
@end

@implementation FBNestLineEffectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}


- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    [self initNestPoints];
}

- (void)initNestPoints {
    
    self.currentPoint = [[FBNestPoint alloc] init];
    self.currentPoint.x = -1;
    self.currentPoint.y = -1;
    self.currentPoint.maxDist = 20000;
    
    self.nestPoints = [[NSMutableArray alloc] init];
    
    for (int i=0; i<50; i++) {
        FBNestPoint* p = [[FBNestPoint alloc] init];
        p.x = (double)arc4random() / ARC4RANDOM_MAX * kScreenWidth;
        p.y = (double)arc4random() / ARC4RANDOM_MAX * kScreenHeight;
        p.xa = 2 * (double)arc4random() / ARC4RANDOM_MAX - 1;
        p.ya = 2 * (double)arc4random() / ARC4RANDOM_MAX - 1;
        p.maxDist = 6000;
        
        [self.nestPoints addObject:p];
    }
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawNest)];
    displayLink.frameInterval = 4;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)drawNest {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    
    //-- clear
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    for (int i=0; i<self.nestPoints.count; i++) {
        FBNestPoint* p = [self.nestPoints objectAtIndex:i];
        p.x += p.xa;
        p.y += p.ya;
        p.xa *= p.x>kScreenWidth || p.x < 0 ? -1 : 1;//碰到边界，反向反弹
        p.ya *= p.y>kScreenHeight || p.y < 0 ? -1 : 1;

        //绘制一个宽高为1的点
        CGContextAddRect(context, CGRectMake(p.x-0.5, p.y-0.5, 1, 1));
        //设置点颜色
        [[UIColor whiteColor] set];
        //绘制
        CGContextDrawPath(context, kCGPathFillStroke);

        //从下一个点开始
        for (int j=i+1; j<self.nestPoints.count; j++) {
            FBNestPoint* np = [self.nestPoints objectAtIndex:j];
            CGFloat xdist = p.x - np.x;
            CGFloat ydist = p.y - np.y;
            CGFloat dist = xdist * xdist + ydist*ydist;
            if (np.x != -1 && np.y != -1) {
                if (dist < np.maxDist) {
                    
//                    if (np.x==self.currentPoint.x && np.y==self.currentPoint.y && dist>=np.maxDist) {
//                        p.x -= 0.03 * xdist;
//                        p.y -= 0.03 * ydist;
//                    }
                    
                    CGFloat wd = (np.maxDist - dist) / np.maxDist;
                    CGContextMoveToPoint(context, p.x, p.y);
                    CGContextAddLineToPoint(context, np.x, np.y);
                    [[UIColor orangeColor] set];
                    CGContextSetLineWidth(context, wd/2);
                    CGContextStrokePath(context);
                }
            }
        }
    }
    
    UIGraphicsEndImageContext();
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch* touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    self.currentPoint.x = p.x;
//    self.currentPoint.y = p.y;
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch* touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    self.currentPoint.x = p.x;
//    self.currentPoint.y = p.y;
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.currentPoint.x = -1;
//    self.currentPoint.y = -1;
//}

@end
