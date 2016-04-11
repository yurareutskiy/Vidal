//
//  SearchViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 11/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "IMQuickSearch.h"
#import "DocumentViewController.h"
#import "SecondDocumentViewController.h"
#import "DocsTableViewCell.h"

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView1;
@property (nonatomic, strong) IBOutlet UITableView *tableView2;
@property (nonatomic, strong) IBOutlet UIButton *button1;
@property (nonatomic, strong) IBOutlet UIButton *button2;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UIView *containerView2;

- (IBAction)toDrugs:(UIButton *)sender;
- (IBAction)toMolecule:(UIButton *)sender;

@end
