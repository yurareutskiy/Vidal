//
//  DocumentViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 06/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavouriteViewController.h"
#import "DocsTableViewCell.h"
#import "DBManager.h"

@interface DocumentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *registred;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)toList:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *latName;

@property (strong, nonatomic) NSMutableArray *info;
@property (strong, nonatomic) NSMutableArray *columns;

@end
