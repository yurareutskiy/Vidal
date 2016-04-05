//
//  ActiveViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ActiveViewController.h"

@interface ActiveViewController ()

@property (nonatomic, strong) NSArray *firstSectionStrings;
@property (nonatomic, strong) NSArray *secondSectionStrings;
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) NSMutableIndexSet *expandableSections;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *arrPeopleInfo;
@property (nonatomic, strong) NSMutableDictionary *info;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableArray *iteration;

@end

@implementation ActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _firstSectionStrings = @[@"Тест", @"Тест", @"Тест"];
    _secondSectionStrings = @[@"Тест", @"Тест", @"Тест"];
    _sectionsArray = @[_firstSectionStrings, _secondSectionStrings].mutableCopy;
    _expandableSections = [NSMutableIndexSet indexSet];
    
    [super setLabel:@"Указатель активных веществ"];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    [self loadData];
    
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
    static NSString *CellIdentifier = @"activeCell";
    ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ActiveTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.name.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:section] objectAtIndex:indexOfFirstname]];
    cell.letter.text = [[NSString stringWithFormat:@"%@.", self.keys[section]] uppercaseString];
    
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
//    return self.sectionsArray.count;
    //NSLog(@"%@", [self.info count]);
    return [self.info count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.info[self.keys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activeCell" forIndexPath:indexPath];
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.name.text = [NSString stringWithFormat:@"%@", [self.info[self.keys[indexPath.row]] objectAtIndex:indexOfFirstname]];
    cell.letter.text = @"";
    
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

-(void)loadData{
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"select * from Molecule order by Molecule.RusName"];
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    self.arrPeopleInfo = [self.arrPeopleInfo valueForKey:@"lowercaseString"];
    
    self.info = [NSMutableDictionary dictionary];
    self.iteration = [NSMutableArray array];
    NSString *keyString;
    
    for (NSArray* key in self.arrPeopleInfo) {
        
        
        keyString = [NSString stringWithFormat:@"%@", [key[2] substringToIndex:1]];
        if ([self.info objectForKey:keyString] != nil) {
            
            [self.iteration setArray:[[self.info objectForKey:keyString] arrayByAddingObject:key]];
            [self.info setObject:self.iteration forKey:keyString];
        } else {
            
            [self.info setObject:key forKey:keyString];
        }
        [self.info setObject:key forKey:keyString];
    }
    
    //[self sortKeysOnTheBasisOfLanguageAlphabetically:self.info];
    
    NSArray *try = [self.info allKeys];
    self.keys = [try sortedArrayUsingSelector:@selector(compare:)];
    
    // Reload the table view.
    [self.tableView reloadData];
}

-(void) sortKeysOnTheBasisOfLanguageAlphabetically:(NSDictionary *)check{
    
    //Method of NSDictionary class which sorts the keys using the logic given by the comparator block
    NSArray * sortArray = [check keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        //We do case insensitive comparision of two strings as we are not really concerned about
        //the "content" of the strings (please see sortKeysOnTheBasisOfNationalIncome method where
        //we would like to do the comparision with numeric search as an extra option)
        NSComparisonResult result = [[obj1 objectAtIndex:2] caseInsensitiveCompare:[obj2 objectAtIndex:2]];
        return result;
    }];
    
    //Show Result in the Output Panel: Country Name and its Language Name
    for (int i = 0; i < [sortArray count]; i++) {
        NSLog(@"Country Name:%@ -- Language:%@",[sortArray objectAtIndex:i],
              [[check valueForKey:[sortArray objectAtIndex:i]] objectAtIndex:2]);
    }
    
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
