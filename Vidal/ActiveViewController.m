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
@property (nonatomic, strong) ModelViewController *mvc;
@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic, strong) NSMutableArray *hello1;
@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (nonatomic, strong) NSMutableArray *forSearch;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (nonatomic, strong) IMQuickSearch *quickSearch;
@property (nonatomic, strong) NSArray *FilteredResults;
@property (nonatomic, strong) NSMutableArray *forS;

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
    CGFloat sizeCell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [super setLabel:@"Список препаратов"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    ((DocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((DocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((DocumentViewController *)self.childViewControllers.lastObject).tableView setTag:2];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    self.forS = [NSMutableArray array];
    self.forSearch = [NSMutableArray array];
    toDelete = [NSMutableIndexSet indexSet];
    ud = [NSUserDefaults standardUserDefaults];
    self.expandableSections = [NSMutableIndexSet indexSet];
    self.hello1 = [NSMutableArray array];
    self.sectionsArray = [NSMutableArray array];
    self.letters = [NSArray arrayWithObjects:@"Z", @"А", @"Б", @"В", @"Г", @"Д", @"Ж", @"З", @"И", @"Й", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Э", @"Я", nil];
    
    container = false;
    self.containerView.hidden = true;
    self.darkView.hidden = true;
    
    [self loadData:@"select * from Molecule order by Molecule.RusName"];
    
    
    for (int i = 0; i < [self.arrPeopleInfo count]; i++) {
        [self.hello1 addObject:[self.arrPeopleInfo[i] objectAtIndex:1]];
    }

    for (NSArray *key in result) {
        [self.sectionsArray addObject:key];
    }
    
    tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tableView:didCollapseSection:animated:)];
    
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
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
    [self.expandableSections addIndex:section];
    [tableView expandSection:section animated:YES];
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
//    if ([[result objectAtIndex:section] count] == 1){
//        if (!container) {
//            self.containerView.hidden = false;
//            container = true;
//            self.darkView.hidden = false;
//            [self.darkView addGestureRecognizer:tap];
//        }
//    } else {
        self.containerView.hidden = true;
        container = false;
        [self.darkView removeGestureRecognizer:tap];
        self.darkView.hidden = true;
        [((UITableView *)[self.view viewWithTag:2]) deselectRowAtIndexPath:selectedRowIndex animated:YES];
//    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1){
        return 60;
    } else if (tableView.tag == 2) {
        if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
            return sizeCell;
        } else {
            return 60;
        }
    } else {
        return 60;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return [result count];
    } else if (tableView.tag == 2) {
        return 1;
    } else if (tableView.tag == 3){
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return [[result objectAtIndex:section] count] + 1;
    } else if (tableView.tag == 2){
        NSInteger x = 0;
        for (int i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
            if (![[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""])
                x++;
        }
        return x;
    } else if (tableView.tag == 3){
        return self.FilteredResults.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1) {
        
        ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activeCell"];
        if (cell == nil) {
            cell = [[ActiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activeCell"];
        }
    
        NSArray *dataArray = result[indexPath.section];
        cell.name.text = [dataArray[indexPath.row - 1] objectAtIndex:2];
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
    } else if (tableView.tag == 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
            }
        
            // Set Content
            NSString *title, *subtitle;
            title = self.FilteredResults[indexPath.row];
            subtitle = self.FilteredResults[indexPath.row];
            cell.textLabel.text = title;
            cell.detailTextLabel.text = subtitle;
        
            // Return Cell
            return cell;
    } else {
        return nil;
    }

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1){
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!container) {
        
        nextPls = [result[indexPath.section][indexPath.row - 1] objectAtIndex:0];
        [ud setObject:nextPls forKey:@"molecule"];
        NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompaniesDescription, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозировки', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID INNER JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID WHERE Molecule.MoleculeID = %@", nextPls];
        [self getMol:request];
        
        if ([self.molecule count] != 0) {
            self.containerView.hidden = false;
            container = true;
            self.darkView.hidden = false;
            [self.darkView addGestureRecognizer:tap];
        }
        }
    } else if (tableView.tag == 2){
        selectedRowIndex = [indexPath copy];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 0)];
        NSString *string = [[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        label.attributedText = attributedString;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Lucida_Grande-Regular" size:17.f];
        [label sizeToFit];
        sizeCell = label.frame.size.height + 5;
        NSLog(@"%f", sizeCell);

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

#pragma MARK - Database Methods

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
    
    //    self.arrPeopleInfo = [self.arrPeopleInfo valueForKey:@"uppercaseString"];
    
    for (NSArray* key in self.arrPeopleInfo) {
        if (![[key objectAtIndex:2] isEqualToString:@""]) {
            keyString = [NSString stringWithFormat:@"%@", [[key objectAtIndex:2] substringToIndex:1]];
        } else {
            keyString = [NSString stringWithFormat:@"%@", [[key objectAtIndex:1] substringToIndex:1]];
        }
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
    
    if ([self.molecule count] != 0) {
    
    for (NSUInteger i = 0; i < [[self.molecule objectAtIndex:0] count]; i++) {
        if ([[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
            || [[[self.molecule objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"])
            [toDelete addIndex:i];
    }
    
    ((DocumentViewController *)self.childViewControllers.lastObject).latName.text = [[[self.molecule objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"];
    ((DocumentViewController *)self.childViewControllers.lastObject).name.text = [[[self.molecule objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"];
    if (![[[self.molecule objectAtIndex:0] objectAtIndex:2] isEqualToString:@""]) {
        ((DocumentViewController *)self.childViewControllers.lastObject).registred.text = [[self.molecule objectAtIndex:0] objectAtIndex:2];
        [toDelete addIndex:2];
    }

        
    [toDelete addIndex:0];
    [toDelete addIndex:1];
    
    [[self.molecule objectAtIndex:0] removeObjectsAtIndexes:toDelete];
    [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
    
    [((DocumentViewController *)self.childViewControllers.lastObject).tableView reloadData];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Неправильный данные" message:@"Повторите ввод" preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
        
                                     }];
                [alertController addAction:ok];
        
                [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.sectionsArray removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
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
