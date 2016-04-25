//
//  PharmaViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import "PharmaTableViewCell.h"
#import "DBManager.h"

@interface PharmaViewController : ModelViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
