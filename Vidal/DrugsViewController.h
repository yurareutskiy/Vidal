//
//  DrugsViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import <SLExpandableTableView.h>

@interface DrugsViewController : ModelViewController<UITableViewDelegate, UITableViewDataSource, SLExpandableTableViewDatasource, SLExpandableTableViewDelegate>

@property (strong, nonatomic) IBOutlet SLExpandableTableView *tableView;

@end
