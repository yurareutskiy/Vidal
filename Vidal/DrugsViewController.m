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
@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (strong, nonatomic) UIBarButtonItem *searchButton;


-(void)loadData:(NSString *)req;

@end

@implementation DrugsViewController {

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
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView setTag:2];
    
    self.letters = [NSArray arrayWithObjects:@"А", @"Б", @"В", @"Г", @"Д", @"Ж", @"З", @"И", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Ц", @"Э", @"Ю", nil];
    
    toDelete = [NSMutableIndexSet indexSet];
    ud = [NSUserDefaults standardUserDefaults];
    
    self.expandableSections = [NSMutableIndexSet indexSet];
    
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
    
    container = false;
    self.containerView.hidden = true;
    self.darkView.hidden = true;
    
    tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tableView:didCollapseSection:animated:)];
    
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(30, 20)]
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    // Do any additional setup after loading the view.
}

- (void) search {
    [self performSegueWithIdentifier:@"toSearch" sender:self];
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
    
    NSString *text = [NSString stringWithFormat:@"%@", [[[result objectAtIndex:section] objectAtIndex:0] objectAtIndex:1]];
    if ([[result objectAtIndex:section] count] > 1) {
        text = [NSString stringWithFormat:@"%@, %@", text, [[[result objectAtIndex:section] objectAtIndex:1] objectAtIndex:1]];
        if ([[result objectAtIndex:section] count] > 2) {
            text = [NSString stringWithFormat:@"%@, %@", text, [[[result objectAtIndex:section] objectAtIndex:2] objectAtIndex:1]];
        }
    }
    
    cell.name.text = text;
    cell.letter.text = [NSString stringWithFormat:@"%@.", [self.letters objectAtIndex:section]];
    
    return cell;
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    
        [self.expandableSections addIndex:section];
        [tableView expandSection:section animated:YES];

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
        self.containerView.hidden = true;
        container = false;
        [self.darkView removeGestureRecognizer:tap];
        self.darkView.hidden = true;
        [((UITableView *)[self.view viewWithTag:2]) deselectRowAtIndexPath:selectedRowIndex animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1){
        return 60;
    } else if (tableView.tag == 2) {
        if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            return self.tableView.rowHeight;
        } else {
            return 60;
        }
    } else {
        return 60;
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
    static NSString *CellIdentifier = @"drugsCell";
    
    DrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DrugsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *dataArray = result[indexPath.section];
    cell.name.text = [dataArray[indexPath.row - 1] objectAtIndex:1];
    cell.letter.text = @"";
        
        return cell;
    
    } else if (tableView.tag == 2){
        
        if ([[[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row] isEqualToString:@""]) {
            return nil;
        }
        
        DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell"];
        if (cell == nil) {
            cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"docCell"];
        };
        
        cell.title.text = [NSString stringWithFormat:@"%@", [self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
        cell.desc.text = [[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        return nil;
    }
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
    if (tableView.tag == 1){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if (!container) {
            self.containerView.hidden = false;
            container = true;
            self.darkView.hidden = false;
            [self.darkView addGestureRecognizer:tap];
            
            nextPls = [result[indexPath.section][indexPath.row - 1] objectAtIndex:0];
            [ud setObject:nextPls forKey:@"molecule"];
            NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозировки', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Product ON Document.DocumentID = Product.DocumentID WHERE Product.ProductID = %@", nextPls];
            [self getMol:request];
        }
    } else if (tableView.tag == 2){
        selectedRowIndex = [indexPath copy];
        
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
    
    self.arrPeopleInfo = [self.arrPeopleInfo valueForKey:@"lowercaseString"];
    
    result = [NSMutableArray arrayWithCapacity:[self.letters count]];
    
    NSString *keyString;
    
    for (int i = 0; i < [self.letters count]; i++) {
        NSMutableArray *tempArray = [NSMutableArray array];
        [result addObject:tempArray];
    }
    
    for (NSArray* key in self.arrPeopleInfo) {
        
        keyString = [NSString stringWithFormat:@"%@", [[key objectAtIndex:1] substringToIndex:1]];
        keyString = [keyString valueForKey:@"uppercaseString"];
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
        if ([[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
            || [[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
            [toDelete addIndex:i];
    }
    
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).latName.text = [[[self.molecule objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"];
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).name.text = [[[self.molecule objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"];
    
    [toDelete addIndex:0];
    [toDelete addIndex:1];
    
    [[self.molecule objectAtIndex:0] removeObjectsAtIndexes:toDelete];
    [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
    
    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView reloadData];
    
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
