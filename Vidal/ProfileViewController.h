//
//  ProfileViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"

@interface ProfileViewController : ModelViewController
@property (strong, nonatomic) IBOutlet UITextField *surname;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UILabel *bd;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UITextField *spec;
@property (strong, nonatomic) IBOutlet UIButton *changeButton;

- (IBAction)change:(UIButton *)sender;

@end
