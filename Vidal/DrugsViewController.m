//
//  DrugsViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "DrugsViewController.h"

@interface DrugsViewController ()

@property (nonatomic, strong) NSArray *firstSectionStrings;
@property (nonatomic, strong) NSArray *secondSectionStrings;
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) NSMutableIndexSet *expandableSections;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic, strong) NSMutableArray *hello1;

-(void)loadData:(NSString *)req;

@end

@implementation DrugsViewController {
    
    NSMutableDictionary *result;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    _firstSectionStrings = @[@"Гадовист", @"Галидор", @"Гордокс"];
//    _secondSectionStrings = @[@"Тест", @"Тест", @"Тест"];
    
    _expandableSections = [NSMutableIndexSet indexSet];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];

    [super setLabel:@"Список препаратов"];
    
    [self loadData:@"SELECT * FROM Document INNER JOIN Product ON Document.DocumentID = Product.ProductID ORDER BY Product.RusName"];
    
    self.hello1 = [NSMutableArray array];
    
    for (int i = 0; i < [self.arrPeopleInfo count]; i++) {
        [self.hello1 addObject:[self.arrPeopleInfo[i] objectAtIndex:1]];
    }
    
    self.sectionsArray = [NSMutableArray array];
    
    for (NSArray *key in result) {
        [self.sectionsArray addObject:key];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SLExpandableTableViewDatasource

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    return ![self.expandableSections containsIndex:section];
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"drugsCell";
    DrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[DrugsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:section] objectAtIndex:indexOfFirstname]];
    
    return cell;
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.expandableSections addIndex:section];
        [tableView expandSection:section animated:YES];
    //});
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
    [self.expandableSections removeIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *dataArray = self.sectionsArray[section];
//    return dataArray.length + 1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *dataArray = self.sectionsArray[indexPath.section];
    cell.textLabel.text = dataArray[indexPath.row - 1];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.sectionsArray removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadData:(NSString *)req{
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    
    result = [NSMutableDictionary dictionary];
    NSString *keyString;
    NSMutableArray *needit = [NSMutableArray array];
    
    for (NSArray* key in self.arrPeopleInfo) {
        
        keyString = [NSString stringWithFormat:@"%@", [[key objectAtIndex:1] substringToIndex:1]];
        NSLog(@"%@", keyString);
        if ([result objectForKey:keyString]) {
            needit = [result objectForKey:keyString];
            [needit addObject:key];
            [result setValue:needit forKey:keyString];
        } else {
            [result setValue:key forKey:keyString];
        }
    }

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

//for (NSArray* key in self.arrPeopleInfo) {
//    
//    keyString = [NSString stringWithFormat:@"%@", [[key objectAtIndex:1] substringToIndex:1]];
//    NSLog(@"%@", keyString);
//    if ([result objectForKey:keyString]) {
//        needit = [[result objectForKey:keyString] mutableCopy];
//        [needit addObject:key];
//        [result setValue:needit forKey:keyString];
//    } else {
//        [result setValue:key forKey:keyString];
//    }
//}


@end
