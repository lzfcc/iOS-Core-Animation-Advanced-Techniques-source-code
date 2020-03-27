//
//  ViewController.m
//
//  Created by Nick Lockwood on 03/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (nonatomic, strong) UIImageView *shipView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *shipImage = [UIImage imageNamed:@"Ship.png"];
    self.shipView = [[UIImageView alloc] initWithImage:shipImage];
    self.shipView.frame = CGRectMake(40, 40, 100, 100);

    [self addAnimation];

    [self.view addSubview:self.shipView];
}

- (void)addAnimation {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;

    [self.shipView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (IBAction)performTransition
{
    //preserve the current view snapshot
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();

    //insert snapshot view in front of this one
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    //update the view (we'll simply randomize the layer background color)
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.view.backgroundColor = [UIColor colorWithRed:red
                                                green:green
                                                 blue:blue
                                                alpha:1.0];

    //perform animation (anything you like)
    [UIView animateWithDuration:5 animations:^{
        
        //scale, rotate and fade the view
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;

    } completion:^(BOOL finished){

        //remove the cover view now we're finished with it
        [coverView removeFromSuperview];
    }];
}

@end
