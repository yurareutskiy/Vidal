//
//  OnboardingViewController.h
//  Vidal
//
//  Created by Yura Reutskiy Work on 6/28/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *backSwipe;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

-(IBAction)nextButtonAction:(id)sender;
-(IBAction)doneButtonAction:(id)sender;

@end
