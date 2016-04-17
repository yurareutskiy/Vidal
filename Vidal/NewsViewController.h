//
//  NewsViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import "AFNetworking.h"
#import "NewsTableViewCell.h"
#import "ExpandNewsViewController.h"

@interface NewsViewController : ModelViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
