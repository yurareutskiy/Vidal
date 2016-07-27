//
//  OnboardingViewController.m
//  Vidal
//
//  Created by Yura Reutskiy Work on 6/28/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "OnboardingViewController.h"
#import "OnboardingScrollItem.h"

@interface OnboardingViewController ()

@property (strong, nonatomic) NSArray *viewsArray;
@property (assign, nonatomic) BOOL isDownloadDone;

@end

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDownloadDone = NO;
    self.viewsArray = [self createViewsArray];
    [self setLayout];

    [self.doneButton setAlpha:0.5f];
    
    [self.swipe addTarget:self action:@selector(swipeAction:)];
    [self.backSwipe addTarget:self action:@selector(swipeAction:)];
    
    [self.pageControl setNumberOfPages:[_viewsArray count]];
    
    if (self.view.frame.size.height == 480) {
        [self.pageControl setHidden:YES];
    }
}

- (NSArray*)createViewsArray {
    NSArray *contentArray = [self createContentArray];
    NSMutableArray *arrayTemp = [[NSMutableArray alloc] initWithArray:@[]];
    for (int i = 0; i < [contentArray count]; i++) {
        NSArray *contentItem = contentArray[i];
        OnboardingScrollItem *view = [[OnboardingScrollItem alloc] initWithContent:contentItem[0] AndImage:[UIImage imageNamed: contentItem[1]] WithScreenSize:self.view.frame.size];

        CGRect rect = view.frame;

        CGFloat xPoint = i * self.view.frame.size.width;
        rect.origin.x = xPoint;
        view.frame = rect;
        
        [arrayTemp addObject:view];
    }
    
    return arrayTemp;
}

- (void)swipeAction:(UISwipeGestureRecognizer*)sender {
    NSLog(@"%@", sender);
    BOOL back;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        back = NO;
    } else {
        back = YES;
    }
    [self swipeOnBack:back];
}

- (NSArray*)createContentArray {
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[]];
    [array addObject:@[@"Самый полный справочник кардиологических препаратов", @"1"]];
    [array addObject:@[@"Быстрый доступ к лекарственному  взаимодействию", @"2"]];
    [array addObject:@[@"Возможность поиска по активным веществам, фарм. группам и производителями", @"3"]];
    [array addObject:@[@"Узнавайте новости из мира  медицины и фармации первыми", @"4"]];
    return array;
}

- (void) setLayout {
    [self.scroll setBackgroundColor:[UIColor colorWithRed:183.f/255.f green:0.f/255.f blue:57.f/255.f alpha:1.f]];
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width * [_viewsArray count], self.view.frame.size.height);
    for (OnboardingScrollItem *item in self.viewsArray) {
        NSLog(@"%@", NSStringFromCGRect(item.frame));
        [self.scroll addSubview:item];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doneButtonAction:(id)sender {
    if (self.isDownloadDone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Подождите" message:@"Архив еще не загрузился." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

-(IBAction)nextButtonAction:(id)sender {
    [self swipeOnBack:NO];
}

- (void)swipeOnBack:(BOOL)isBackSwipe {
    CGPoint pointOffset = self.scroll.contentOffset;
    if (isBackSwipe && pointOffset.x > 0) {
        pointOffset.x -= self.view.frame.size.width;
        [self.pageControl setCurrentPage:self.pageControl.currentPage - 1];
    } else if (isBackSwipe == NO && pointOffset.x < self.view.frame.size.width * ([self.viewsArray count] - 1)) {
        pointOffset.x += self.view.frame.size.width;
        [self.pageControl setCurrentPage:self.pageControl.currentPage + 1];
    } else {
        return;
    }
    if (self.pageControl.currentPage == [self.viewsArray count] - 1) {
        [self.nextButton setHidden:YES];
        [self.doneButton setHidden:NO];
    } else if (self.pageControl.currentPage == [self.viewsArray count] - 2) {
        [self.nextButton setHidden:NO];
        [self.doneButton setHidden:YES];
    }

    [UIView animateWithDuration:0.2 animations:^{
        [self.scroll setContentOffset:pointOffset];
    }];
}

- (void)changeDoneButtonWithType:(BOOL)isDone {
    if (isDone) {
        [self.doneButton setAlpha:1];
        self.isDownloadDone = YES;
    }
}

@end
