//
//  PNBar.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBar.h"
#import "PNColor.h"

@implementation PNBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        // Initialization code
        _chartLine              = [CAShapeLayer layer];
        _chartLine.lineCap      = kCALineCapButt;
        _chartLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth    = self.frame.size.width;
        _chartLine.strokeEnd    = 0.0;
        self.clipsToBounds      = YES;
        [self.layer addSublayer:_chartLine];
        self.barRadius = 2.0;
    }

    return self;
}

-(void)setBarRadius:(CGFloat)barRadius
{
    _barRadius = barRadius;
    self.layer.cornerRadius = _barRadius;
}


- (void)setGrade:(float)grade
{
    
    _grade = fabsf(grade);
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    NSLog(@"%f", (1 - _grade) * self.frame.size.height);

    CGPoint inicio = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height);
    CGPoint fim = CGPointMake(self.frame.size.width / 2.0, (1 - _grade) * self.frame.size.height);
    
    CGFloat alturaInicial = self.frame.size.height;
    CGFloat alturaFinal = (1 - _grade) * self.frame.size.height;
    if (_yMin < 0) {
        alturaInicial = self.frame.size.height / 2;
    }
    
    if (grade < 0) {
        alturaFinal = (self.frame.size.height / 2) - (_value / 10);
    } else if (_yMin < 0 &&  grade > 0){
        alturaFinal = alturaFinal - alturaInicial;
    }
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width / 2.0, alturaInicial)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width / 2.0, _value == 0 ? alturaInicial : alturaFinal)];

    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    _chartLine.path = progressline.CGPath;

    if (_barColor) {
        if (grade > 0) {
            _chartLine.strokeColor = [_barColor CGColor];
        } else {
            _chartLine.strokeColor = [PNRed CGColor];
        }
    }
    else {
        _chartLine.strokeColor = [PNGreen CGColor];
        
    }

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @1.0f;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

    _chartLine.strokeEnd = 1.0;
}


- (void)rollBack
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations: ^{
        _chartLine.strokeColor = [UIColor clearColor].CGColor;
    } completion:nil];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
}


@end
