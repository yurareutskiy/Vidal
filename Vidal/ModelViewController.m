//
//  ModelViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelViewController ()

@property (strong, nonatomic) MenuViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (strong, nonatomic) SWRevealViewController *reveal;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *letters;

@end

@implementation ModelViewController {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureMenu];
    [self customNavBar];
    
//    self.hello2 = [NSMutableArray array];
//    
//    self.tableView1.delegate = self;
//    self.tableView1.dataSource = self;
//    self.searchBar.delegate = self;
    
    
//    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
//    
//    self.letters = [NSArray arrayWithObjects:@"N", @"А", @"Б", @"В", @"Г", @"Д", @"Е", @"Ж", @"З", @"И", @"Й", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Ч", @"Ш", @"Э", @"Я", nil];
//    
//    [self loadData:@"select * from Molecule order by Molecule.RusName"];
//    
//    [self setUpQuickSearch:self.result];
//    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    
    // Добавить в hello2 все по препаратам
    // Do any additional setup after loading the view.
}

//- (void)setUpQuickSearch:(NSMutableArray *)work {
//    // Create Filters
//    IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:@[@"hey", @"helloooo", @"heheheh"] keys:@[@"description"]];
//    self.quickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter]];
//}
//
//- (void)filterResults {
//    // Asynchronously
//        [self.quickSearch asynchronouslyFilterObjectsWithValue:self.searchBar.text completion:^(NSArray *filteredResults) {
//            [self updateTableViewWithNewResults:filteredResults];
//        }];
//    }
//
//- (void)updateTableViewWithNewResults:(NSArray *)results {
//    self.FilteredResults = results;
//    [self.tableView1 reloadData];
//}

#pragma mark - TableView
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.FilteredResults.count;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
//    }
//    
//    // Set Content
//    NSString *title, *subtitle;
//    title = self.FilteredResults[indexPath.row];
//    subtitle = self.FilteredResults[indexPath.row];
//    cell.textLabel.text = title;
//    cell.detailTextLabel.text = subtitle;
//    
//    // Return Cell
//    return cell;
//}

- (void)customNavBar {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:183.0/255.0 green:0.0/255.0 blue:57.0/255.0 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
}

- (void)configureMenu {
    
    self.reveal = self.revealViewController;
    
    if (!self.reveal) {
        return;
    }
    
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"burger"] scaledToSize:CGSizeMake(20, 20)]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self.revealViewController
                                                      action:@selector(revealToggle:)];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}

- (void) setLabel:(NSString *)label {
//    UILabel* labelName = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
//    labelName.textAlignment = NSTextAlignmentCenter;
//    labelName.text = NSLocalizedString(label, @"");
//    labelName.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = labelName;
    self.navigationItem.title = label;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)loadData:(NSString *)req{
//    
//    // Get the results.
//    if (self.hello2 != nil) {
//        self.hello2 = nil;
//    }
//    self.hello2 = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
//    
//    self.result = [NSMutableArray arrayWithCapacity:[self.letters count]];
//    
//    NSString *keyString;
//    
//    for (int i = 0; i < [self.letters count]; i++) {
//        NSMutableArray *tempArray = [NSMutableArray array];
//        [self.result addObject:tempArray];
//    }
//    
//    self.hello2 = [self.hello2 valueForKey:@"uppercaseString"];
//    
//    for (NSArray* key in self.hello2) {
//        
//        keyString = [NSString stringWithFormat:@"%@", [[key objectAtIndex:2] substringToIndex:1]];
//        NSInteger ind = [self.letters indexOfObject:keyString];
//        [[self.result objectAtIndex:ind] addObject:key];
//    }
//    
//    // Reload the table view.
//    //[self.tableView reloadData];
//}
//
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
//    return YES;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
