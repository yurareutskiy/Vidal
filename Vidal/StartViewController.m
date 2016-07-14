//
//  StartViewController.m
//  Vidal
//
//  Created by Yura Reutskiy Work on 6/28/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.navigationController.navigationBar setHidden:YES];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([[ud valueForKey:@"reg"] isEqualToString:@"2"]) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"revealMenu"];
        [self presentViewController:vc animated:NO completion:nil];
    } else {
        [self performSegueWithIdentifier:@"reg" sender:nil];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
