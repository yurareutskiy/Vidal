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
    UIActivityIndicatorView *activityView;
    NSString *drug;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"workActive"];
    [ud removeObjectForKey:@"listOfDrugs"];
    [ud removeObjectForKey:@"info"];
    
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];

    [super setLabel:@"Препараты"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        activityView = [[UIActivityIndicatorView alloc]
                                                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activityView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2 - 80.0);
        
        
        [activityView startAnimating];
        [self.tableView addSubview:activityView];
        
        [self loadData:@"select Letter, Title from AlfabetDocumentListView order by Letter"];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [activityView removeFromSuperview];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
    
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    [ud removeObjectForKey:@"workActive"];
    [ud removeObjectForKey:@"activeID"];
    [ud removeObjectForKey:@"pharmaList"];
    [ud removeObjectForKey:@"comp"];
    [ud removeObjectForKey:@"info"];
    [ud removeObjectForKey:@"from"];
    
    // Do any additional setup after loading the view.
}

- (void) viewWillDisappear:(BOOL)animated {
    [ud removeObjectForKey:@"howTo"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    
    static NSString *CellIdentifier = @"drugsCell";
    
    DrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DrugsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger indexOfLetter = [self.dbManager.arrColumnNames indexOfObject:@"Letter"];
    NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"Title"];
    
    cell.name.text = [self clearString:[[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfTitle] valueForKey:@"lowercaseString"]];
    cell.letter.text = [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfLetter];
        
        return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] forKey:@"letterDrug"];
    
    [self performSegueWithIdentifier:@"newWindow" sender:self];
}

-(void)loadData:(NSString *)req {
    
    check = 0;
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];

    // Reload the table view.
}

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    NSRange range = NSMakeRange(0, 1);
    text = [text stringByReplacingCharactersInRange:range withString:[[text substringToIndex:1] valueForKey:@"uppercaseString"]];
    text = [text stringByReplacingOccurrencesOfString:@"<TD colSpan=\"2\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
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
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
