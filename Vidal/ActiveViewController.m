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
@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic, strong) NSMutableArray *hello1;
@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, strong) NSMutableArray *molecule;

-(void)loadData:(NSString *)req;

@end

@implementation ActiveViewController {
    
    NSMutableArray *result;
    BOOL container;
    UITapGestureRecognizer *tap;
    NSIndexPath *selectedRowIndex;
    NSUserDefaults *ud;
    NSString *nextPls;
    NSMutableIndexSet *toDelete;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    toDelete = [NSMutableIndexSet indexSet];
    
    self.searchBar.delegate = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    
    ((DocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((DocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((DocumentViewController *)self.childViewControllers.lastObject).tableView setTag:2];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.letters = [NSArray arrayWithObjects:@"N", @"А", @"Б", @"В", @"Г", @"Д", @"Е", @"Ж", @"З", @"И", @"Й", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Ч", @"Ш", @"Э", @"Я", nil];
    
    self.expandableSections = [NSMutableIndexSet indexSet];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    [super setLabel:@"Список препаратов"];
    
    [self loadData:@"select * from Molecule order by Molecule.RusName"];
    
    self.hello1 = [NSMutableArray array];
    
    for (int i = 0; i < [self.arrPeopleInfo count]; i++) {
        [self.hello1 addObject:[self.arrPeopleInfo[i] objectAtIndex:1]];
    }
    
    self.sectionsArray = [NSMutableArray array];
    
    for (NSArray *key in result) {
        [self.sectionsArray addObject:key];
    }
    
    
    
    container = false;
    self.containerView.hidden = true;
    self.darkView.hidden = true;
    
    tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tableView:didCollapseSection:animated:)];
    
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
    
    NSString *text = [NSString stringWithFormat:@"%@", [[[result objectAtIndex:section] objectAtIndex:0] objectAtIndex:2]];
    if ([[result objectAtIndex:section] count] > 1) {
        text = [NSString stringWithFormat:@"%@, %@", text, [[[result objectAtIndex:section] objectAtIndex:1] objectAtIndex:2]];
        if ([[result objectAtIndex:section] count] > 2) {
            text = [NSString stringWithFormat:@"%@, %@", text, [[[result objectAtIndex:section] objectAtIndex:2] objectAtIndex:2]];
        }
    }
    
    cell.name.text = text;
    cell.letter.text = [NSString stringWithFormat:@"%@.", [self.letters objectAtIndex:section]];
    
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
    if ([[result objectAtIndex:section] count] == 1){
        if (!container) {
            
            self.containerView.hidden = false;
            container = true;
            self.darkView.hidden = false;
            [self.darkView addGestureRecognizer:tap];
        }
    } else {
        
        //[self.expandableSections removeIndex:section];
        self.containerView.hidden = true;
        container = false;
        [self.darkView removeGestureRecognizer:tap];
        self.darkView.hidden = true;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1){
        return 60;
    } else if (tableView.tag == 2) {
        if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
            return 300;
        } else {
            NSLog(@"%ld", (long)indexPath.row);
            NSLog(@"%ld", (long)selectedRowIndex.row);
            return 60;
        }
    } else {
        return 44;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return [result count];
    } else if (tableView.tag == 2) {
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return [[result objectAtIndex:section] count];
    } else if (tableView.tag == 2){
        NSInteger x = 0;
        for (int i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
            if (![[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""])
                x++;
        }
        return x;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        static NSString *CellIdentifier = @"activeCell";
        
        ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ActiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
        NSArray *dataArray = result[indexPath.section];
        cell.name.text = [dataArray[indexPath.row - 1] objectAtIndex:2];
        cell.letter.text = @"";
        
        return cell;
    } else if (tableView.tag == 2){
        
        if ([[[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row] isEqualToString:@""]) {
            return nil;
        }
        
        static NSString *CellIdentifier = @"docCell";
        DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        };
        
        cell.title.text = [NSString stringWithFormat:@"%@", [self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
        cell.desc.text = [[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
    
    return nil;
    }

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
    if (tableView.tag == 1){
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!container) {
        self.containerView.hidden = false;
        container = true;
        self.darkView.hidden = false;
        [self.darkView addGestureRecognizer:tap];
        
        nextPls = [result[indexPath.section][indexPath.row - 1] objectAtIndex:0];
        [ud setObject:nextPls forKey:@"molecule"];
        NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозировки', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID INNER JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID WHERE Molecule.MoleculeID = %@", nextPls];
        [self getMol:request];
    }
    }
    else if (tableView.tag == 2){
    selectedRowIndex = [indexPath copy];

    [tableView beginUpdates];
    
    [tableView endUpdates];
    }
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 2) {
    [tableView beginUpdates];
    
    [tableView endUpdates];
    }
    
}

-(void)loadData:(NSString *)req{
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    
    result = [NSMutableArray arrayWithCapacity:[self.letters count]];
    
    NSString *keyString;
    
    for (int i = 0; i < [self.letters count]; i++) {
        NSMutableArray *tempArray = [NSMutableArray array];
        [result addObject:tempArray];
    }
    
    self.arrPeopleInfo = [self.arrPeopleInfo valueForKey:@"uppercaseString"];
    
    for (NSArray* key in self.arrPeopleInfo) {
        
        keyString = [NSString stringWithFormat:@"%@", [[key objectAtIndex:2] substringToIndex:1]];
        NSInteger ind = [self.letters indexOfObject:keyString];
        [[result objectAtIndex:ind] addObject:key];
    }
    
    // Reload the table view.
    [self.tableView reloadData];
}

- (void) getMol:(NSString *)mol {
    if (self.molecule != nil) {
        self.molecule = nil;
    }
    self.molecule = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:mol]];
    
    for (NSUInteger i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
        if ([[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""])
            [toDelete addIndex:i];
    }
    
    [[self.molecule objectAtIndex:0] removeObjectsAtIndexes:toDelete];
    [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
    
    [((DocumentViewController *)self.childViewControllers.lastObject).tableView reloadData];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
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
