//
//  MenuViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MenuViewController : UIViewController <SWRevealViewControllerDelegate, UIGestureRecognizerDelegate>

- (IBAction)toNews:(UIButton *)sender;
- (IBAction)toDrugs:(UIButton *)sender;
- (IBAction)toActive:(UIButton *)sender;
- (IBAction)toInteractions:(UIButton *)sender;
- (IBAction)toPharma:(UIButton *)sender;
- (IBAction)toProducers:(UIButton *)sender;
- (IBAction)toAbout:(UIButton *)sender;
- (IBAction)toProfile:(UIButton *)sender;
- (IBAction)toFavourite:(UIButton *)sender;
- (IBAction)toReference:(UIButton *)sender;
- (IBAction)registration:(UIButton *)sender;
- (IBAction)toVidal:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *news;
@property (strong, nonatomic) IBOutlet UIImageView *drugs;
@property (strong, nonatomic) IBOutlet UIImageView *active;
@property (strong, nonatomic) IBOutlet UIImageView *inter;
@property (strong, nonatomic) IBOutlet UIImageView *pharma;
@property (strong, nonatomic) IBOutlet UIImageView *producer;
@property (strong, nonatomic) IBOutlet UIImageView *info;
@property (strong, nonatomic) IBOutlet UIImageView *profile;
@property (strong, nonatomic) IBOutlet UIImageView *fave;
@property (strong, nonatomic) IBOutlet UIButton *vidal;

@end
