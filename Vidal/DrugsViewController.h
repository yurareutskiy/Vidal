//
//  DrugsViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import <SLExpandableTableView.h>
#import "DrugsTableViewCell.h"
#import "DBManager.h"
#import "DocsTableViewCell.h"
#import "SecondDocumentViewController.h"

@interface DrugsViewController : ModelViewController <SLExpandableTableViewDatasource, SLExpandableTableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet SLExpandableTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
