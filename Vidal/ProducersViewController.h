//
//  ProducersViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import "DBManager.h"
#import "ProducersTableViewCell.h"
#import "CompanyViewController.h"

@interface ProducersViewController : ModelViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
