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
#import "CompanyViewController.h"
#import "PharmaViewController.h"

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView1;
@property (nonatomic, strong) IBOutlet UITableView *tableView2;
@property (strong, nonatomic) IBOutlet UITableView *tableView3;
@property (strong, nonatomic) IBOutlet UITableView *tableView4;
@property (nonatomic, strong) IBOutlet UIButton *button1;
@property (nonatomic, strong) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *line2;
@property (strong, nonatomic) IBOutlet UIView *line1;
@property (strong, nonatomic) IBOutlet UIView *line3;
@property (strong, nonatomic) IBOutlet UIView *line4;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)toDrugs:(UIButton *)sender;
- (IBAction)toMolecule:(UIButton *)sender;
- (IBAction)toPharma:(UIButton *)sender;
- (IBAction)toProd:(UIButton *)sender;
- (IBAction)left:(UIButton *)sender;
- (IBAction)right:(UIButton *)sender;

@end
