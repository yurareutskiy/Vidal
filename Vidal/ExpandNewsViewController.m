//
//  ExpandNewsViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ExpandNewsViewController.h"

@interface ExpandNewsViewController ()

@end

@implementation ExpandNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Новости";
    
    NSString *string = self.newsText.text;
    self.newsText.numberOfLines = 0;
    self.newsText.text = string;
    [self.newsText sizeToFit];
    
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

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
    
}
@end
