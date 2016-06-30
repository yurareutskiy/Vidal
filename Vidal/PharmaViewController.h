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
#import "SWRevealViewController.h"
#import "MenuViewController.h"
#import "ListOfViewController.h"

@interface PharmaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger level;
@property (strong, nonatomic) NSString *code;


@end
