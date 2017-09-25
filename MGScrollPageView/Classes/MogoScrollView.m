//
//  MogoScrollView.m
//  MogoRenter
//
//  Created by song on 16/3/29.
//  Copyright © 2016年 MogoRoom. All rights reserved.
//

#import "MogoScrollView.h"

@implementation MogoScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSArray *)excludeGestureClasss{
    if (!_excludeGestureClasss) {
        _excludeGestureClasss = [NSArray array];
    }
    return _excludeGestureClasss;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture
{
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gesture;
        CGPoint translation = [panGesture translationInView:self];
//        CGPoint location = [panGesture locationInView:self];
        //贴边右滑都是切换回上一页
        if(translation.x > 0 && translation.x > translation.y && self.contentOffset.x < 5)
        {
            return NO;
        }
    }
    return [super gestureRecognizerShouldBegin:gesture];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([self.excludeGestureClasss containsObject:NSStringFromClass([touch.view class])]) {
        return  NO;
    }
    return YES;
}


@end
