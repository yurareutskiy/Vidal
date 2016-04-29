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
    UIActivityIndicatorView *activityView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [super setLabel:@"Список активных веществ"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    self.forS = [NSMutableArray array];
    self.forSearch = [NSMutableArray array];
    toDelete = [NSMutableIndexSet indexSet];
    ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"listOfDrugs"];
    [ud removeObjectForKey:@"listOfDrugs"];
        [ud removeObjectForKey:@"info"];
    self.expandableSections = [NSMutableIndexSet indexSet];
    self.hello1 = [NSMutableArray array];
    self.sectionsArray = [NSMutableArray array];
    self.letters = [NSArray arrayWithObjects:@"А", @"Б", @"В", @"Г", @"Д", @"Ж", @"З", @"И", @"Й", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Э", @"Я", nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        activityView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activityView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2 - 80.0);
        [activityView startAnimating];
        [self.tableView addSubview:activityView];
        
        [self loadData:@"select Letter, Title from (select m.Letter, (select group_concat(t.RusName,', ') || '..'  from (select sm.RusName from (select upper(substr(m.RusName, 1, 1)) as Letter, m.MoleculeID, upper(substr(m.RusName, 1, 1)) || lower(substr(m.RusName, 2)) as RusName, upper(substr(m.LatName, 1, 1)) || lower(substr(m.LatName, 2)) as LatName, doc.DocumentID from Molecule_Document md inner join Molecule m on m.MoleculeID = md.MoleculeID inner join Document doc on doc.DocumentID = md.DocumentID where doc.ArticleID = 1) sm where sm.Letter = m.Letter order by sm.RusName limit 3) t) as Title from (select upper(substr(m.RusName, 1, 1)) as Letter, m.MoleculeID, upper(substr(m.RusName, 1, 1)) || lower(substr(m.RusName, 2)) as RusName, upper(substr(m.LatName, 1, 1)) || lower(substr(m.LatName, 2)) as LatName, doc.DocumentID from Molecule_Document md inner join Molecule m on m.MoleculeID = md.MoleculeID inner join Document doc on doc.DocumentID = md.DocumentID where doc.ArticleID = 1) m group by m.Letter) order by Letter"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [activityView removeFromSuperview];
            
            [self.tableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });

    
        self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(search)];
    
        self.navigationItem.rightBarButtonItem = self.searchButton;
    
    // Do any additional setup after loading the view.
    
    [ud removeObjectForKey:@"workWith"];
    [ud removeObjectForKey:@"activeID"];
    [ud removeObjectForKey:@"pharmaList"];
    [ud removeObjectForKey:@"comp"];
    [ud removeObjectForKey:@"info"];
    [ud removeObjectForKey:@"from"];
    [ud removeObjectForKey:@"molecule"];
    [ud removeObjectForKey:@"letterDrug"];
    
}

- (void) search {
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [ud removeObjectForKey:@"workWith"];
    [ud removeObjectForKey:@"activeID"];
    
    if (nextPls) {
        [ud setObject:nextPls forKey:@"molecule"];
    }
    
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

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

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
        
        ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activeCell"];
        if (cell == nil) {
            cell = [[ActiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activeCell"];
        }
    
    cell.name.text = [self clearString:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1]];
        cell.letter.text = [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0];
        
        return cell;
    

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//
//        
//        nextPls = [result[indexPath.section][indexPath.row - 1] objectAtIndex:0];
//        [ud setObject:nextPls forKey:@"molecule"];
//        NSString *request = [NSString stringWithFormat:@"SELECT Document.RusName, Document.EngName, Document.CompaniesDescription, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозирования', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Molecule_Document ON Document.DocumentID = Molecule_Document.DocumentID INNER JOIN Molecule ON Molecule_Document.MoleculeID = Molecule.MoleculeID WHERE Document.DocumentID = %@", nextPls];
//        [self getMol:request];
    
    [self performSegueWithIdentifier:@"newWindow" sender:self];
    [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] forKey:@"letterActive"];
    
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
//        if (![[key objectAtIndex:2] isEqualToString:@""]) {
//            keyString = [NSString stringWithFormat:@"%@", [[key objectAtIndex:2] substringToIndex:1]];
//        } else {
            keyString = [NSString stringWithFormat:@"%@", [[key objectAtIndex:1] substringToIndex:1]];
//        }
        keyString = [keyString valueForKey:@"uppercaseString"];
        NSLog(@"%@", keyString);
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
    
    ((DocumentViewController *)self.childViewControllers.lastObject).latName.text = [self clearString:[[[self.molecule objectAtIndex:0] objectAtIndex:2] valueForKey:@"lowercaseString"]];
    ((DocumentViewController *)self.childViewControllers.lastObject).name.text = [self clearString:[[[self.molecule objectAtIndex:0] objectAtIndex:1] valueForKey:@"lowercaseString"]];

        
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

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    NSRange range = NSMakeRange(0, 1);
    text = [text stringByReplacingCharactersInRange:range withString:[[text substringToIndex:1] valueForKey:@"uppercaseString"]];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"newWindow"]) {
        
        ListOfViewController *lovc = [segue destinationViewController];
        
        lovc.dataBase = self.dbManager.arrColumnNames;
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
