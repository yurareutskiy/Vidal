//
//  LoginViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 26/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Server.h"

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *regButton;
- (IBAction)registration:(UIButton *)sender;
- (IBAction)login:(UIButton *)sender;
- (IBAction)withoutReg:(UIButton *)sender;
@property (strong, nonatomic) NSDictionary *result;

@end

