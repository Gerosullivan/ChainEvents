//
//  CircleLineButton.m
//  ChainEvents
//
//  Created by Gerald O'Sullivan on 15/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "CircleLineButton.h"

@interface CircleLineButton ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *currentColor;


@end

@implementation CircleLineButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawCircleButton:(UIColor *)color {
    self.color = color;
    self.currentColor = self.color;
    
    [self setTitleColor:color forState:UIControlStateNormal];
    
    self.circleLayer = [CAShapeLayer layer];
    
    [self.circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self bounds].size.width, [self bounds].size.height)];
    
    [self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
                                                                           
    [self.circleLayer setPath:[path CGPath]];
    
//    [self.circleLayer setStrokeColor:[color CGColor]];
    
    [self.circleLayer setLineWidth:2.0f];
    [self.circleLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    [[self layer] addSublayer:self.circleLayer];
    
}

- (void)setHighlighted:(BOOL)highlighted {
//    NSLog(highlighted ? @"setHighlighted true" : @"setHighlighted false");
    if (highlighted) {
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.circleLayer setFillColor:self.currentColor.CGColor];
    } else {
        [self.circleLayer setFillColor:[UIColor whiteColor].CGColor];
        self.titleLabel.textColor = self.currentColor;
    }
}

- (void)changeToSecondaryColor:(UIColor *)color {
    // NSLog(@"CircleButton changeToSecondaryColor: %@", color);
    self.currentColor = color;
    self.titleLabel.textColor = self.currentColor;
    [self setTitleColor:self.currentColor forState:UIControlStateNormal];
}

- (void)changeToPrimaryColor {
    // NSLog(@"CircleButton changeToPrimaryColor");
    self.currentColor = self.color;
    self.titleLabel.textColor = self.currentColor;
    [self setTitleColor:self.currentColor forState:UIControlStateNormal];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([self bounds].size.width, [self bounds].size.height);
}

//- (void)setEnabled:(BOOL)enabled {
//    [self.circleLayer setFillColor:[UIColor whiteColor].CGColor];
//    if (enabled) {
//        self.titleLabel.textColor = self.color;
//    } else {
//        self.titleLabel.textColor = [UIColor lightGrayColor];
//    }
//}

@end
