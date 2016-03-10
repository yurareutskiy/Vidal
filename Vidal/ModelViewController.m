//
//  ModelViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelViewController ()

@property (strong, nonatomic) MenuViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;

@end

@implementation ModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureMenu];
    [self customNavBar];
    
    // Do any additional setup after loading the view.
}

- (void)customNavBar {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:183.0/255.0 green:1.0/255.0 blue:57.0/255.0 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)configureMenu {
    
    self.reveal = self.revealViewController;
    
    if (!self.reveal) {
        return;
    }
    
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self.revealViewController
                                                      action:@selector(revealToggle:)];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
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
