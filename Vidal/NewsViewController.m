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
    UIActivityIndicatorView *activityView;
    BOOL isConnectionAvailable;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshButton.hidden = YES;
    
    ud = [NSUserDefaults standardUserDefaults];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [super setLabel:@"Новости"];
    
    array = [NSArray array];
    
    [self refreshAction];
    
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
    [date setDateFormat:@"dd MMMM yyyy"];
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
    if ([[ud valueForKey:@"reg"] isEqualToString:@"2"]) {
        [self performSegueWithIdentifier:@"toExpandNews" sender:self];
    } else {
        [self performSegueWithIdentifier:@"toExpandNews_demo" sender:self];
    }}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) refreshAction {
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        isConnectionAvailable = false;
    } else {
        isConnectionAvailable = true;
    }
    
    if (isConnectionAvailable) {
        self.refreshButton.hidden = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            activityView = [[UIActivityIndicatorView alloc]
                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            activityView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2 - 80.0);
            
            
            [activityView startAnimating];
            [self.tableView addSubview:activityView];
            
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
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [activityView removeFromSuperview];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        });
        
    } else {
        [self showAlert:@"Отсутствует Интернет-соединение" mess:@"Попробуйте зайти позже"];
        self.refreshButton.hidden = NO;
    }
    
    
    
}

- (IBAction)refresh:(UIButton *)sender {
    [self refreshAction];
}

- (void) showAlert:(NSString *)alert  mess:(NSString *)mess {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alert message:mess preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             
                         }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
