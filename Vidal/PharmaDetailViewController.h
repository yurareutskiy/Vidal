//
//  PharmaDetailViewController.h
//  Vidal
//
//  Created by Yura Reutskiy Work on 6/24/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PharmaDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSString *parentCode;
@property (assign, nonatomic) NSInteger level;
@property (strong, nonatomic) NSString *pharmaName;

@property (strong, nonatomic) NSMutableArray *molecule;

-(IBAction)showListGroupsActions:(id)sender;

@end
