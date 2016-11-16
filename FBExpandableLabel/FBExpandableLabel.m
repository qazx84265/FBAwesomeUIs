//
//  FBExpandableLabel.m
//  ARSeek
//
//  Created by fb on 16/11/14.
//  Copyright © 2016年 ARSeeds. All rights reserved.
//

#import "FBExpandableLabel.h"

#define kDefaultMaxLines 3
#define kDefaultFont 12.0f
#define kDefaultSubfix @"... 更多..."

@interface FBExpandableLabel() {
    BOOL _mIsExpand;
}
@property (nonatomic, copy) NSString* string;
@end

@implementation FBExpandableLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.maxLinesWhenUnexpand = kDefaultMaxLines;
        self.subfixWhenUnexpand = kDefaultSubfix;
        self.subfixColor = [UIColor blackColor];
        
        _mIsExpand = NO;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand)];
        [self addGestureRecognizer:tapper];
    }
    
    return self;
}

- (void)setTruncatingText:(NSString *)string {
    self.string = string;
    
    [self expand];
}


-(void)expand {
    
    CGRect frame = self.frame;
    
    if (self.string==nil || [self.string isEqualToString:@""]) {
        frame.size = CGSizeZero;
        self.frame = frame;
        return;
    }
    
    if (_mIsExpand) {
        NSString* subfix = @"  收起";
        NSMutableString *truncatedString = [self.string mutableCopy];
        [truncatedString appendString:subfix];
        self.numberOfLines = 0;
        NSMutableAttributedString* mstr = [[NSMutableAttributedString alloc] initWithString:truncatedString];
        NSRange range = [truncatedString rangeOfString:@"收起"];
        [mstr addAttribute:NSForegroundColorAttributeName value:kApp_Theme_Color range:range];
        self.attributedText = mstr;
        
        CGFloat h = [truncatedString heightWithFont:self.font constrainedToWidth:self.frame.size.width];
        frame.size.height = h;
    }
    else {
        //
        NSMutableString *truncatedString = [self.string mutableCopy];
        int linesNeeded = [self numberOfLinesNeeded:truncatedString];
        if (linesNeeded > self.maxLinesWhenUnexpand) {
            self.numberOfLines = self.maxLinesWhenUnexpand;
            
            [truncatedString appendString:self.subfixWhenUnexpand];
            NSRange range = NSMakeRange(truncatedString.length - (self.subfixWhenUnexpand.length + 1), 1);
            while ([self numberOfLinesNeeded:truncatedString] > self.maxLinesWhenUnexpand) {
                [truncatedString deleteCharactersInRange:range];
                range.location--;
            }
            [truncatedString deleteCharactersInRange:range];  //need to delete one more to make it fit
            
            NSMutableAttributedString* mstr = [[NSMutableAttributedString alloc] initWithString:truncatedString];
            NSRange range1 = [truncatedString rangeOfString:@"更多..."];
            [mstr addAttribute:NSForegroundColorAttributeName value:self.subfixColor range:range1];
            self.attributedText = mstr;
        }
        else {
            self.numberOfLines = linesNeeded;
            self.text = truncatedString;
        }
        
        float oneLineHeight = [self heightOfSingleLine];
        frame.size.height = oneLineHeight * (linesNeeded > self.maxLinesWhenUnexpand ? self.maxLinesWhenUnexpand : linesNeeded) + 5;
    }
    self.frame = frame;
    
    _mIsExpand = !_mIsExpand;
}


#pragma Private Methods

- (int)numberOfLinesNeeded:(NSString *)s {
    float oneLineHeight = [self heightOfSingleLine];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: self.font,
                                 NSParagraphStyleAttributeName: paragraph};
    float totalHeight = [s boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                               context:nil].size.height;
    int lines = nearbyint(totalHeight/oneLineHeight);
    
    return lines;
}

- (CGFloat)heightOfSingleLine {
    return [@"中" sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
}


@end
