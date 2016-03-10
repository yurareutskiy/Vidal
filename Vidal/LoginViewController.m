//
//  LoginViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 26/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.regButton.layer.borderWidth = 1.0;
    self.regButton.layer.borderColor = [UIColor colorWithRed:148.0/255.0 green:0 blue:0 alpha:1.0].CGColor;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registration:(UIButton *)sender {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"revealMenu"];
    [self presentViewController:vc animated:false completion:nil];
    
}
@end
