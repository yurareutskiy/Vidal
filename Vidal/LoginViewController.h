//
//  LoginViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 26/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *regButton;
- (IBAction)registration:(UIButton *)sender;

@end

