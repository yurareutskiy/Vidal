//
//  FavouriteViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import "DBManager.h"
#import "SecondDocumentViewController.h"
#import "FavTableViewCell.h"

@interface FavouriteViewController : ModelViewController<UITableViewDataSource, UITableViewDelegate, FavTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (weak, nonatomic) IBOutlet UIView *containerView;



@end
