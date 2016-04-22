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
    CGFloat sizeCell;
    int check;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((SecondDocumentViewController *)self.childViewControllers.lastObject).tableView setTag:2];
    
    self.letters = [NSArray arrayWithObjects:@"А", @"Б", @"В", @"Г", @"Д", @"Ж", @"З", @"И", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Э", @"Ю", @"L", nil];
    
    toDelete = [NSMutableIndexSet indexSet];
    ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"workActive"];
    [ud removeObjectForKey:@"listOfDrugs"];
        [ud removeObjectForKey:@"info"];
    
    self.expandableSections = [NSMutableIndexSet indexSet];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];

    [super setLabel:@"Список препаратов"];
    
    [self loadData:@"SELECT * FROM Document INNER JOIN Product ON Document.DocumentID = Product.DocumentID GROUP BY Product.RusName"];
    
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
    
//    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
//                                                         style:UIBarButtonItemStyleDone
//                                                        target:self
//                                                        action:@selector(search)];
    
//    self.navigationItem.rightBarButtonItem = self.searchButton;
    
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
    
    cell.name.text = [self clearString:text];
    cell.letter.text = [NSString stringWithFormat:@"%@.", [self.letters objectAtIndex:section]];
    
    return cell;
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    [ud setObject:result[section] forKey:@"workWith"];
    
    [self performSegueWithIdentifier:@"newWindow" sender:self];
//        [self.expandableSections addIndex:section];
//        [tableView expandSection:section animated:YES];

}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
        self.containerView.hidden = true;
        container = false;
        [self.darkView removeGestureRecognizer:tap];
        self.darkView.hidden = true;
        [((UITableView *)[self.view viewWithTag:2]) deselectRowAtIndexPath:selectedRowIndex animated:YES];

}

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
        return [[result objectAtIndex:section] count] + 1;
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
    cell.name.text = [self clearString:[dataArray[indexPath.row - 1] objectAtIndex:1]];
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
        
        cell.title.text = [NSString stringWithFormat:@"%@", [self clearString:[self.dbManager.arrColumnNames objectAtIndex:indexPath.row]]];
        cell.desc.text = [self clearString:[[self.molecule objectAtIndex:0] objectAtIndex:indexPath.row]];
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
//            [ud setObject:nextPls forKey:@"molecule"];
            [ud setObject:nextPls forKey:@"id"];
            NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompaniesDescription, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозировки', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document WHERE Document.DocumentID = %@", nextPls];
//            INNER JOIN Product ON Document.DocumentID = Product.DocumentID
            NSLog(@"%@", request);
            [self getMol:request];
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

-(void)loadData:(NSString *)req {
    
    check = 0;
    
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
        check++;
        NSLog(@"%d", check);
    }

    // Reload the table view.
    [self.tableView reloadData];
}

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    text = [text stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"»"];
    text = [text stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    text = [text stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&-nb-sp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"–"];
    text = [text stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"–"];
    text = [text stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    text = [text stringByReplacingOccurrencesOfString:@"&loz;" withString:@"◊"];
    text = [text stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    text = [text stringByReplacingOccurrencesOfString:@"<SUP>&reg;</SUP>" withString:@"®"];
    text = [text stringByReplacingOccurrencesOfString:@"<sup>&reg;</sup>" withString:@"®"];
    text = [text stringByReplacingOccurrencesOfString:@"<P>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<B>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<I>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TR>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TD>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</P>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</B>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<BR />" withString:@"\n"];
    text = [text stringByReplacingOccurrencesOfString:@"<FONT class=\"F7\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</FONT>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</I>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</TR>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</TD>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TABLE width=\"100%\" border=\"1\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</TABLE>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</SUB>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<SUB>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<P class=\"F7\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    
    return text;
    
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
    
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).latName.text = [self clearString:[[[self.molecule objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"]];
    ((SecondDocumentViewController *)self.childViewControllers.lastObject).name.text = [self clearString:[[[self.molecule objectAtIndex:0] objectAtIndex:0] valueForKey:@"lowercaseString"]];
    if (![[[self.molecule objectAtIndex:0] objectAtIndex:2] isEqualToString:@""]) {
        ((SecondDocumentViewController *)self.childViewControllers.lastObject).registred.text = [self clearString:[[self.molecule objectAtIndex:0] objectAtIndex:2]];
        [toDelete addIndex:2];
    }
    
    if ([((NSArray *)[ud objectForKey:@"favs"]) containsObject:[ud objectForKey:@"id"]]) {
        NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:((SecondDocumentViewController *)self.childViewControllers.lastObject).fav.titleLabel.text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255.0 green:0.0 blue:57.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        
        [((SecondDocumentViewController *)self.childViewControllers.lastObject).fav setAttributedTitle:resultText forState:UIControlStateNormal];
        [((SecondDocumentViewController *)self.childViewControllers.lastObject).fav setImage:[UIImage imageNamed:@"favRed"] forState:UIControlStateNormal];
    } else {
        NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithString:((SecondDocumentViewController *)self.childViewControllers.lastObject).fav.titleLabel.text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        
        [((SecondDocumentViewController *)self.childViewControllers.lastObject).fav setAttributedTitle:resultText forState:UIControlStateNormal];
        [((SecondDocumentViewController *)self.childViewControllers.lastObject).fav setImage:[UIImage imageNamed:@"favGrey"] forState:UIControlStateNormal];
    }

    
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
