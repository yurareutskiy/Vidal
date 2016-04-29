//
//  LoginViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 26/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *regButton;
- (IBAction)registration:(UIButton *)sender;
- (IBAction)login:(id)sender;
- (IBAction)withoutReg:(UIButton *)sender;
- (IBAction)forget:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *lead;
@property (strong, nonatomic) IBOutlet UITextField *emailInput;
@property (strong, nonatomic) IBOutlet UITextField *passInput;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *regHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logHeight;

@end

