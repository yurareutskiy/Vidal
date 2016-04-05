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
@property (nonatomic, strong) NSArray *tryArray;

@end

@implementation PharmaViewController {

    BOOL container;
    UITapGestureRecognizer *tap;
    NSUserDefaults *ud;
    NSString *req;
    
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
                                            action:@selector(close)];
    
    
    req = @"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = 1 ORDER BY ClinicoPhPointers.Name";
    
    [self loadData:req];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SLExpandableTableViewDelegate

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self segueToBe:indexPath.row];
    [self loadData:req];
    
    
}

- (void) segueToBe:(NSInteger)xid
{
    
    NSInteger product = [self.dbManager.arrColumnNames indexOfObject:@"ShowInProduct"];
    NSInteger parent = [self.dbManager.arrColumnNames indexOfObject:@"Code"];
    NSInteger level = [self.dbManager.arrColumnNames indexOfObject:@"Level"];
    NSInteger pointID = [self.dbManager.arrColumnNames indexOfObject:@"ClPhPointerID"];
    
    // Set the loaded data to the appropriate cell labels.
    
    NSString *productStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:product]];
    NSString *parentStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:parent]];
    NSString *levelStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:level]];
    NSString *pointIDStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:xid] objectAtIndex:pointID]];
    
    NSString *req2 = [NSString stringWithFormat:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = %ld AND ClinicoPhPointers.ParentCode = '%@' ORDER BY ClinicoPhPointers.Name", [levelStr integerValue] + 1, parentStr];
    
    BOOL goNext = [self checkData:req2];
    
    if (!goNext) {
        if (!container) {
            self.containerView.hidden = false;
            container = true;
            self.darkView.hidden = false;
            [self.darkView addGestureRecognizer:tap];
        }
        NSLog(@"лекарств нет");
        [ud setObject:pointIDStr forKey:@"id"];
        
        
    } else if (goNext){
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

-(BOOL)checkData:(NSString *)req {
    // Form the query.
    NSString *query = [NSString stringWithFormat:req];
    
    // Get the results.
    if (self.tryArray != nil) {
        self.tryArray = nil;
    }
    self.tryArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if ([self.tryArray count] == 0){
        return NO;
    } else {
        return YES;
    }
}

- (void) close {
    self.containerView.hidden = true;
    container = false;
    [self.darkView removeGestureRecognizer:tap];
    self.darkView.hidden = true;
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
