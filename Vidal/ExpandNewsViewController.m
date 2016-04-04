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

@implementation ExpandNewsViewController {
    
    SocialNetworkManagerVC *vc;
    NSDictionary *array;
    NSString *pls;
    NSUserDefaults *ud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Новости";
    
    vc = [[SocialNetworkManagerVC alloc] init];
    ud = [NSUserDefaults standardUserDefaults];
    self.newsId = [ud objectForKey:@"news"];
    
    array = [NSDictionary dictionary];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.vidal.ru/api/news/%@", self.newsId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            array = [responseObject copy];
        }
    }];
    [dataTask resume];
    
    [super setLabel:@"Новости"];
    
    // Do any additional setup after loading the view.
}



- (void) viewDidAppear:(BOOL)animated {
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateNews = [date dateFromString:[array objectForKey:@"date"]];
    [date setDateFormat:@"dd MMMM yyyy HH:mm"];
    NSString *resultDate = [date stringFromDate:dateNews];
    
    self.date.text = resultDate;
    self.newsTitle.text = [array objectForKey:@"title"];
    self.newsText.text = [array objectForKey:@"body"];
    
    self.newsText.numberOfLines = 0;
    self.newsTitle.numberOfLines = 0;
    [self.newsText sizeToFit];
    [self.newsTitle sizeToFit];
    
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

- (IBAction)shareNews:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"share" sender:self];
    //[self presentViewController:vc animated:YES completion:nil];
}
@end
