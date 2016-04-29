//
//  PharmaViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "PharmaViewController.h"

@interface PharmaViewController ()

@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (nonatomic, strong) NSMutableArray *secondArray;
@property (nonatomic, strong) NSArray *tryArray;
@property (nonatomic, strong) NSMutableArray *data;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;

@end

@implementation PharmaViewController {

    NSUserDefaults *ud;
    NSString *req;
    BOOL isEmptyDrugsList;
    NSInteger level;

}

#pragma mark - viewLoads

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    self.navigationItem.title = @"Фармакологические группы";
    
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
                                                            style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(search)];
    
    if ([ud valueForKey:@"level"] != 0 && ![[ud valueForKey:@"howTo"] isEqualToString:@"search"]) {
        [self addBackButton];
    }
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    if ([[ud valueForKey:@"howTo"] isEqualToString:@"search"]) {
        [self customNavBar];
    } else {
        [ud removeObjectForKey:@"level"];
        [self customNavBar];
        [self configureMenu];
    }
    [ud removeObjectForKey:@"workWith"];
    [ud removeObjectForKey:@"workActive"];
    [ud removeObjectForKey:@"activeID"];
    [ud removeObjectForKey:@"pharmaList"];
    [ud removeObjectForKey:@"comp"];
    [ud removeObjectForKey:@"info"];
    [ud removeObjectForKey:@"from"];
    [ud removeObjectForKey:@"molecule"];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self refreshDb];
}

- (void) viewDidDisappear:(BOOL)animated {
    [ud removeObjectForKey:@"howTo"];
//    [ud removeObjectForKey:@"level"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrPeopleInfo count];
}

#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PharmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pharmaCell" forIndexPath:indexPath];

    cell.name.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:2]]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    isEmptyDrugsList = false;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *parentStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:1]];
    NSString *levelStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:3]];
    NSString *pointIDStr = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0]];
    
    NSString *req2 = [NSString stringWithFormat:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = %d AND ClinicoPhPointers.ParentCode = '%@' ORDER BY ClinicoPhPointers.Name", (int)[levelStr integerValue] + 1, parentStr];
    
    BOOL goNext = [self checkData:req2];
    
    if (!goNext) {
        
        NSString *request = [NSString stringWithFormat:@"SELECT Document.DocumentID, Document.RusName, Document.EngName, Document.CompaniesDescription, Document.CompiledComposition AS 'Описание состава и форма выпуска', Document.YearEdition AS 'Год издания', Document.PhInfluence AS 'Фармакологическое действие', Document.PhKinetics AS 'Фармакокинетика', Document.Dosage AS 'Режим дозирования', Document.OverDosage AS 'Передозировка', Document.Lactation AS 'При беременности, родах и лактации', Document.SideEffects AS 'Побочное действие', Document.StorageCondition AS 'Условия и сроки хранения', Document.Indication AS 'Показания к применению', Document.ContraIndication AS 'Противопоказания', Document.SpecialInstruction AS 'Особые указания', Document.PharmDelivery AS 'Условия отпуска из аптек' FROM Document INNER JOIN Document_ClPhPointers ON Document.DocumentID = Document_ClPhPointers.DocumentID INNER JOIN ClinicoPhPointers ON Document_ClPhPointers.ClPhPointerID = ClinicoPhPointers.ClPhPointerID WHERE ClinicoPhPointers.ClPhPointerID = %@", pointIDStr];
        [self getMol:request];
        
        if (isEmptyDrugsList) {
            return;
        } else {
            [ud setObject:self.molecule forKey:@"pharmaList"];
            [self performSegueWithIdentifier:@"toList" sender:self];
        }
    } else if (goNext){
        [ud setObject:levelStr forKey:@"level"];
        if ([[ud objectForKey:@"level"] integerValue] == 1) {
            [ud setObject:parentStr forKey:@"parent2"];
        } else if ([[ud objectForKey:@"level"] integerValue] == 2) {
            [ud setObject:parentStr forKey:@"parent3"];
        } else if ([[ud objectForKey:@"level"] integerValue] == 3) {
            [ud setObject:parentStr forKey:@"parent4"];
        }
        [self addBackButton];
        [self refreshDb];
        [self reloadTableView];
    }
    
}

#pragma mark - DBManager

-(void)loadData:(NSString *)req {
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    
    if ([self.arrPeopleInfo count] == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Нет данных" message:@"Отсутствует информация о группе" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        [self reloadTableView];
    }
    
    // Reload the table view.
}

-(BOOL)checkData:(NSString *)req {
    
    // Get the results.
    if (self.tryArray != nil) {
        self.tryArray = nil;
    }
    self.tryArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    
    if ([self.tryArray count] == 0){
        return NO;
    } else {
        return YES;
    }
}

- (void) getMol:(NSString *)mol {
    if (self.molecule != nil) {
        self.molecule = nil;
    }
    self.molecule = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:mol]];
    
    if ([self.molecule count] == 0) {
        isEmptyDrugsList = true;
        [self refreshDb];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Нет данных" message:@"Отсутствует информация о группе" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}


- (void) refreshDb {
    if ([ud valueForKey:@"level"] != nil) {
        level = [[ud objectForKey:@"level"] integerValue];
    } else {
        level = 0;
    }
    
    if (level + 1 == 1) {
        req = @"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = 1 ORDER BY ClinicoPhPointers.Name";
    } else if (level + 1 == 2) {
        req = [NSString stringWithFormat:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.ParentCode = '%@' ORDER BY ClinicoPhPointers.Name", [ud objectForKey:@"parent2"]];
    } else if (level + 1 == 3) {
        req = [NSString stringWithFormat:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = %ld AND ClinicoPhPointers.ParentCode = '%@' ORDER BY ClinicoPhPointers.Name", level + 1, [ud objectForKey:@"parent3"]];
    } else if (level + 1 == 4) {
        req = [NSString stringWithFormat:@"Select * From ClinicoPhPointers WHERE ClinicoPhPointers.Level = %ld AND ClinicoPhPointers.ParentCode = '%@' ORDER BY ClinicoPhPointers.Name", level + 1, [ud objectForKey:@"parent4"]];
    }
    
    [self loadData:req];
    
}

#pragma mark - Additional Methods

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (void) search
{
    [self performSegueWithIdentifier:@"toSearch" sender:self];
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

- (void) addBackButton{

//    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back"]  landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    
    self.navigationItem.leftBarButtonItem = self.backButton;
    
}

- (void) backMethod {
    
    [ud setInteger:([[ud objectForKey:@"level"] integerValue] - 1) forKey:@"level"];
    [self refreshDb];
    if ([[ud objectForKey:@"level"] integerValue] == 0) {
        self.navigationItem.leftBarButtonItem = nil;
        [self configureMenu];
    }
}

- (void) reloadTableView {
    
    [UIView transitionWithView:self.tableView
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.tableView reloadData];
                    } completion:nil];
    
}

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

@end
