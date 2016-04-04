//
//  PharmaViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "PharmaViewController.h"

@interface PharmaViewController ()

@property (nonatomic, strong) NSArray *firstSectionStrings;
@property (nonatomic, strong) NSArray *secondSectionStrings;
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) NSMutableIndexSet *expandableSections;
@property (nonatomic, strong) NSMutableArray *arrPeopleInfo;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *tryArray;

@end

@implementation PharmaViewController {

    BOOL container;
    UITapGestureRecognizer *tap;
    NSUserDefaults *ud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    
//    _firstSectionStrings = @[@"Тест", @"Тест", @"Тест"];
//    _secondSectionStrings = @[@"Тест", @"Тест", @"Тест"];
//    _sectionsArray = @[_firstSectionStrings, _secondSectionStrings].mutableCopy;
//    _expandableSections = [NSMutableIndexSet indexSet];
    
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    [super setLabel:@"Фармакологические группы"];
    
    self.containerView.hidden = true;
    self.darkView.hidden = true;
    container = false;
    
    tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tableView:didCollapseSection:animated:)];
    
    //[self segueToBe:1 request:@""];
    
    [self loadData:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = 1 ORDER BY ClinicoPhPointers.Name"];
    
    // Do any additional setup after loading the view.
}

//- (void)close {
//    
//    self.darkView.hidden = true;
//    self.containerView.hidden = true;
//    container = false;
//    [self.darkView removeGestureRecognizer:tap];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
//{
//    return YES;
//}
//
//- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
//{
//    return ![self.expandableSections containsIndex:section];
//}

//- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
//{
//    static NSString *CellIdentifier = @"pharmaCell";
//    PharmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (!cell) {
//        cell = [[PharmaTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }
//    
//    //cell.textLabel.text = [NSString stringWithFormat:@"Section %ld", (long)section];
//    
//    return cell;
//}

#pragma mark - SLExpandableTableViewDelegate

//- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
//{
//    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    if (!container) {
//        [self.expandableSections addIndex:section];
//        [tableView expandSection:section animated:YES];
//    }
//}

//- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
//{
//    [self.expandableSections removeIndex:section];
//    self.containerView.hidden = true;
//    container = false;
//    [self.darkView removeGestureRecognizer:tap];
//    self.darkView.hidden = true;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrPeopleInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PharmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pharmaCell" forIndexPath:indexPath];
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.name.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname]];
    
    return cell;
}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        [self.sectionsArray removeObjectAtIndex:indexPath.section];
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (!container) {
//        self.containerView.hidden = false;
//        container = true;
//        self.darkView.hidden = false;
//        [self.darkView addGestureRecognizer:tap];
//    }
    
    [self segueToBe:indexPath.row request:@""];
    
    
    
}

- (void) segueToBe:(NSInteger)xid request:(NSString *)req {
    
    NSInteger product = [self.dbManager.arrColumnNames indexOfObject:@"ShowInProduct"];
    NSInteger parent = [self.dbManager.arrColumnNames indexOfObject:@"Code"];
    NSInteger level = [self.dbManager.arrColumnNames indexOfObject:@"Level"];
    
//    NSString *sql = [NSString stringWithFormat:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = 2 AND ClinicoPhPointers.ParentCode = '%@' ORDER BY ClinicoPhPointers.Name", parent];
    
    // Set the loaded data to the appropriate cell labels.
    
    NSString *productStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:product]];
    NSString *parentStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:parent]];
    NSString *levelStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:level]];
    
    // Get the results.
    if (self.tryArray != nil) {
        self.tryArray = nil;
    }
    //self.tryArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:sql]];
    
    if ([productStr isEqualToString:@"0"]) {
        //делать запрос
        //открывать контейнер вью
    } else {
        [ud setObject:levelStr forKey:@"level"];
        [ud setObject:parentStr forKey:@"parent"];
        [self performSegueWithIdentifier:@"toLevel" sender:self];
        NSLog(@"%d %@", levelStr.intValue + 1, parentStr);
    }
    
}

-(void)loadData:(NSString *)req{
    // Form the query.
    NSString *query = [NSString stringWithFormat:req];
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
