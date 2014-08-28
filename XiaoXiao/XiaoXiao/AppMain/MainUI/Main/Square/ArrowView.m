//
//  ArrowView.m
//  ArrowAnimation
//
//  Created by aclct on 14-2-17.
//  Copyright (c) 2014年 AC. All rights reserved.
//

#import "ArrowView.h"

@interface ArrowView ()

@property (nonatomic,retain)UIImageView *imgView1;
@property (nonatomic,retain)UIImageView *imgView2;
@property (nonatomic,retain)UIImageView *imgView3;
@property (nonatomic,assign)CGPoint centerPoint;
@property (nonatomic,assign)CGPoint lastPoint;
@property (nonatomic,assign)CGPoint jianPoint;
@property (nonatomic,retain)UIView *pointView;
@property (nonatomic,assign)BOOL is_Moving;

@end

@implementation ArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = rgb(30,42,49,1);
        self.imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(130,0, 60, 356)];
        self.imgView1.image = [UIImage imageNamed:@"begin.png"];
        [self addSubview:self.imgView1];

        
//        self.imgView1.backgroundColor = [UIColor redColor];
        
        self.imgView3 = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-93)/2,(frame.size.height-331)/2, 93, 331)];
        self.imgView3.image = [UIImage imageNamed:@"move.png"];
        //        self.imgView3.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.imgView3];
        self.imgView3.hidden = YES;

        self.imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(127,(356-18)/2, 180, 18)];
        self.imgView2.image = [UIImage imageNamed:@"arrow.png"];
        [self addSubview:self.imgView2];
        self.jianPoint = self.imgView2.frame.origin;

        tieTop = [[UIImageView alloc]init];
        tieTop.frame = CGRectMake(127,10,17,8);
        tieTop.image = [UIImage imageNamed:@"tie_top.png"];
        [self addSubview:tieTop];
        
        tieBottom = [[UIImageView alloc]init];
        tieBottom.frame = CGRectMake(127,335,17,8);
        tieBottom.image = [UIImage imageNamed:@"tie_top.png"];
        [self addSubview:tieBottom];
        
        self.pointView = [[UIView alloc]initWithFrame:CGRectMake(121,(356-18)/2-6,30,30)];
//        self.pointView.backgroundColor = [UIColor redColor];
        [self addSubview:self.pointView];
        self.is_Moving = NO;
        self.centerPoint = CGPointMake(95,self.jianPoint.y);
        
        
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);
    CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);
    CGContextFillRect(context, self.frame);
    
    CGContextTranslateCTM(context,0,self.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(context, 1.0);
    
    if (self.is_Moving) {
        CGContextMoveToPoint(context,115,35);
        CGContextAddLineToPoint(context, self.centerPoint.x,self.centerPoint.y+10);
        CGContextAddLineToPoint(context,121,330);
        
        tieTop.frame = CGRectMake(115,30,10,4);
        tieBottom.frame = CGRectMake(115,319,10,4);
        
    }else{
        CGContextMoveToPoint(context,132,27);
        CGContextAddLineToPoint(context,134,self.centerPoint.y);
        CGContextAddLineToPoint(context, 132,333);
        
        tieTop.frame = CGRectMake(131,20,10,4);
        tieBottom.frame = CGRectMake(131,325,10,4);
    }
    CGContextStrokePath(context);
    
    //CGContextRestoreGState(context);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.pointView.frame,touchLocation)) {
        self.lastPoint = touchLocation;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    if (self.lastPoint.x != 0) {
        
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        
        if (self.lastPoint.x > touchLocation.x && touchLocation.x >= 48) {
            
            self.imgView1.hidden = YES;
            self.imgView3.hidden = NO;
            self.imgView2.hidden = NO;
            
            self.is_Moving = YES;
            
            UITouch *touch = [touches anyObject];
            CGPoint touchLocation = [touch locationInView:self];
            
            CGRect oldArrowFrame = self.imgView2.frame;
            
            CGFloat originX = self.lastPoint.x-touchLocation.x;
            
            self.imgView2.frame = CGRectMake(self.imgView2.frame.origin.x-originX,self.imgView2.frame.origin.y,oldArrowFrame.size.width,oldArrowFrame.size.height);
            
            self.centerPoint = CGPointMake(self.imgView2.frame.origin.x+8,(356-18)/2);
            
            self.lastPoint = touchLocation;
            [self setNeedsDisplay];
            
            //
            [XXSimpleAudio playPullShootEffect];
        }
    }
    

    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.is_Moving) {
        self.userInteractionEnabled = NO;
        [XXSimpleAudio playShootNowEffect];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.imgView2.frame = CGRectMake(320, self.imgView2.frame.origin.y, 180, 18);
        
        self.centerPoint = CGPointMake(132, 180);
        self.imgView3.hidden = YES;
        self.imgView1.hidden = NO;
        self.is_Moving = NO;
        [self setNeedsDisplay];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0];
        
        [self performSelector:@selector(restjianpoint) withObject:self afterDelay:1.0];
    }else{
        self.is_Moving = NO;
    }
}

- (void)restjianpoint
{
    [self setNeedsDisplay];
    self.jianPoint = CGPointMake(124, 172);
    self.lastPoint = self.centerPoint;
    tieTop.frame = CGRectMake(131,20,10,4);
    tieBottom.frame = CGRectMake(131,325,10,4);
    
    self.imgView2.frame = CGRectMake(127,self.imgView2.frame.origin.y,180,18);
    self.pointView.frame = CGRectMake(121,(356-18)/2-6,30,30);
    [self finished];
    self.userInteractionEnabled = YES;
}

- (void)finished
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(arrowMoveFinished:)]) {
        [self.delegate arrowMoveFinished:self];
    }
}


@end
