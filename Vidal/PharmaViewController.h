//
//  PharmaViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import <SLExpandableTableView.h>
#import "PharmaTableViewCell.h"
#import "DBManager.h"

@interface PharmaViewController : ModelViewController<SLExpandableTableViewDatasource, SLExpandableTableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet SLExpandableTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *darkView;

@end
