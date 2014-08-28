//
//  LonelyShootView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-19.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "LonelyShootView.h"

@implementation LonelyShootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.gongFirstState = [[UIImageView alloc]initWithFrame:CGRectMake(130,0, 60, 356)];
        self.gongFirstState.image = [UIImage imageNamed:@"begin.png"];
        [self addSubview:self.gongFirstState];
        //        self.imgView1.backgroundColor = [UIColor redColor];
        self.arrow = [[UIImageView alloc]initWithFrame:CGRectMake(135,(356-18)/2, 180, 18)];
        self.arrow.image = [UIImage imageNamed:@"arrow.png"];
        [self addSubview:self.arrow];
        self.gongSecondState = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-93)/2,(frame.size.height-331)/2, 93, 331)];
        self.gongSecondState.image = [UIImage imageNamed:@"move.png"];
        [self addSubview:self.gongSecondState];
        self.gongSecondState.hidden = YES;
        self.tapView = [[UIView alloc]initWithFrame:CGRectMake(self.arrow.frame.origin.x,self.arrow.frame.origin.y, 20, 20)];
        self.tapView.backgroundColor = [UIColor redColor];
        [self addSubview:self.tapView];

        //default
        self.isPulling  = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);
    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextFillRect(context, self.frame);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context,0,self.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(context, 1.5);
    if (self.isPulling) {
        CGContextMoveToPoint(context,95,65);
        CGContextAddLineToPoint(context, self.tapView.center.x,self.tapView.center.y);
        CGContextAddLineToPoint(context,95,350);
    }else{
        CGContextMoveToPoint(context,132,40);
        CGContextAddLineToPoint(context,134,self.tapView.center.y);
        CGContextAddLineToPoint(context, 132,350);
    }
    CGContextStrokePath(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint tapPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.tapView.frame,tapPoint)) {
        
        self.tapView.center = CGPointMake(tapPoint.x,self.arrow.frame.origin.y);
        CGRect oldArrowFrame = self.arrow.frame;
        self.arrow.frame = CGRectMake(self.tapView.frame.origin.x,self.tapView.frame.origin.y,oldArrowFrame.size.width,oldArrowFrame.size.height);
    
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
