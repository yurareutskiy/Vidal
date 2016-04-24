//
//  NewsViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController {
    NSArray *array;
    NSString *newsID;
    NSUserDefaults *ud;
    ModelViewController *mvc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    mvc = [[ModelViewController alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [super setLabel:@"Новости"];

    
    array = [NSArray array];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://www.vidal.ru/api/news-raw"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            array = [NSArray arrayWithArray:responseObject];
            [self.tableView reloadData];
        }
    }];
    [dataTask resume];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NewsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    
    cell.name.text = [[array objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, cell.frame.size.height - 1.0, self.view.frame.size.width + 5.0, 1.0)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:line];
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateNews = [date dateFromString:[[array objectAtIndex:indexPath.row] objectForKey:@"date"]];
    [date setDateFormat:@"dd MMMM yyyy HH:mm"];
    NSString *resultDate = [date stringFromDate:dateNews];
    cell.date.text = resultDate;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [array count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [ud setObject:[[array objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"news"];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"toExpandNews" sender:self];
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
