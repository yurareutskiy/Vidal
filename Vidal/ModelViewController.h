//
//  ModelViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "MenuViewController.h"
#import "IMQuickSearch.h"
#import "DBManager.h"

@interface ModelViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

- (void) setLabel:(NSString *)label;

@property (nonatomic, strong) IMQuickSearch *quickSearch;
@property (nonatomic, strong) NSMutableArray *hello1;
@property (nonatomic, strong) NSArray *FilteredResults;

@end
