//
//  ActiveViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import <SLExpandableTableView.h>
#import "ActiveTableViewCell.h"
#import "DBManager.h"
#import "DocumentViewController.h"
#import "DocsTableViewCell.h"
#import "ListOfViewController.h"

@interface ActiveViewController : ModelViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
