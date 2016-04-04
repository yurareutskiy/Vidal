//
//  ReferenceViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ReferenceViewController.h"

@interface ReferenceViewController ()

@end

@implementation ReferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Новости";
    
    NSString *string = self.takeda.text;
    self.takeda.numberOfLines = 0;
    self.takeda.text = string;
    [self.takeda sizeToFit];
    
    [super setLabel:@"Справка"];
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
