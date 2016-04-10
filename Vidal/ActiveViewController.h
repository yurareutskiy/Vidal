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

@interface ActiveViewController : ModelViewController<SLExpandableTableViewDatasource, SLExpandableTableViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet SLExpandableTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *darkView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UISearchBar *searchBar1;

@end
