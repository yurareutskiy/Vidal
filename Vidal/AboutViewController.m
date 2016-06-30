//
//  AboutViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (nonatomic, strong) NSMutableArray *IDs;

-(void)loadData:(NSString *)req;

@end

@implementation AboutViewController {
    
    NSUserDefaults *ud;
    int ind;
}

-(instancetype)init {
    self = [super init];
    self.demoAccount = YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.image.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    ind = 5;
    
    ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:@"about" forKey:@"howTo"];
    self.navigationItem.title = @"О Такеда";
    
    NSString *string1 = self.takeda.text;
    self.takeda.numberOfLines = 0;
    self.takeda.text = string1;
    [self.takeda sizeToFit];
    
    NSString *string2 = self.drug.text;
    self.drug.numberOfLines = 0;
    self.drug.text = string2;
    [self.drug sizeToFit];
    
    [self setLabel:@"О Такеда"];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    NSString *request = @"select DocumentListView.RusName as RusName, DocumentListView.CompiledComposition as CompiledComposition, Picture.Image, DocumentListView.DocumentID as DocumentID, DocumentListView.EngName as EngName, DocumentListView.CompaniesDescription as CompaniesDescription, DocumentListView.Elaboration as Elaboration, DocumentListView.CategoryName as Category, DocumentListView.PhInfluence as PhInfluence, DocumentListView.PhKinetics as PhKinetics, DocumentListView.Indication as Indication, DocumentListView.Dosage as Dosage, DocumentListView.SideEffects as SideEffects, DocumentListView.ContraIndication as ContraIndication, DocumentListView.Lactation as Lactation, DocumentListView.SpecialInstruction as SpecialInstruction, DocumentListView.OverDosage as OverDosage, DocumentListView.Interaction as Interaction, DocumentListView.PharmDelivery as PharmDelivery, DocumentListView.StorageCondition as StorageCondition, InfoPage.RusName as InfoPageName FROM DocumentListView INNER JOIN Document_InfoPage ON Document_InfoPage.DocumentID = DocumentListView.DocumentID INNER JOIN InfoPage ON Document_InfoPage.InfoPageID = InfoPage.InfoPageID INNER JOIN Product ON DocumentListView.DocumentID = Product.DocumentID LEFT JOIN Product_Picture ON Product.ProductID  = Product_Picture.ProductID LEFT JOIN Picture ON Product_Picture.PictureID = Picture.PictureID WHERE InfoPage.InfoPageID = 63 GROUP BY DocumentListView.RusName";
    
    [self loadData:request];
    
    self.IDs = [NSMutableArray array];
    for (int i = 0; i < [self.arrPeopleInfo count]; i++) {
        
        [self.IDs addObject:[[self.arrPeopleInfo objectAtIndex:i] objectAtIndex:3]];
        NSLog(@"%@", [[self.arrPeopleInfo objectAtIndex:i] objectAtIndex:3]);
    }
    
    [self.image setImage:[UIImage imageWithData:[self.results[ind] valueForKey:@"image"]] forState:UIControlStateNormal];
    [self.name setText:[self.results[ind] valueForKey:@"nameOf"]];
    [self.drug setText:[self.results[ind] valueForKey:@"drug"]];
    
    [ud removeObjectForKey:@"workWith"];
    [ud removeObjectForKey:@"workActive"];
    [ud removeObjectForKey:@"activeID"];
    [ud removeObjectForKey:@"pharmaList"];
    [ud removeObjectForKey:@"info"];
    [ud removeObjectForKey:@"from"];
    [ud removeObjectForKey:@"letterActive"];
    [ud removeObjectForKey:@"letterDrug"];
    
    // Do any additional setup after loading the view.
}

- (void) viewDidDisappear:(BOOL)animated
{
        [ud removeObjectForKey:@"howTo"];
}


-(void)loadData:(NSString *)req{
    // Form the query.
    NSString *query = [NSString stringWithFormat:req];
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    self.results = [NSMutableArray array];
    for (NSArray *key in self.arrPeopleInfo) {
        NSMutableDictionary *material = [NSMutableDictionary dictionary];
        [material setValue:[self clearString:[key objectAtIndex:0]] forKey:@"nameOf"];
        [material setValue:[self clearString:[key objectAtIndex:1]] forKey:@"drug"];
        [material setValue:[key objectAtIndex:2] forKey:@"image"];
        [self.results addObject:material];
    }

}

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    
    text = [text stringByReplacingOccurrencesOfString:@"<TD colSpan=\"2\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<sup>&trade;</sup>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"<SUP>&trade;</SUP>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"&trade;" withString:@"™"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)toList:(UIButton *)sender {
    
    [ud setObject:@"63" forKey:@"info"];
    [ud removeObjectForKey:@"howTo"];
    [self performSegueWithIdentifier:@"toList" sender:self];
    
}



- (IBAction)right:(UIButton *)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.image setAlpha:0.0];
        [self.name setAlpha:0.0];
        [self.drug setAlpha:0.0];
    } completion:^(BOOL finished) {
        if (ind < [self.results count] - 1) {
            if ([[self.results[ind+1] valueForKey:@"image"] length] > 0) {
                [self.image setImage:[UIImage imageWithData:[self.results[ind+1] valueForKey:@"image"]] forState:UIControlStateNormal];
            } else {
                [self.image setImage:[UIImage imageNamed:@"company"] forState:UIControlStateNormal];
            }
            [self.name setText:[self.results[ind+1] valueForKey:@"nameOf"]];
            [self.drug setText:[self.results[ind+1] valueForKey:@"drug"]];
            ind++;
        } else if (ind == [self.results count] - 1) {
            if ([[self.results[0] valueForKey:@"image"] length] > 0) {
                [self.image setImage:[UIImage imageWithData:[self.results[0] valueForKey:@"image"]] forState:UIControlStateNormal];
            } else {
                [self.image setImage:[UIImage imageNamed:@"company"] forState:UIControlStateNormal];
            }
            [self.name setText:[self.results[0] valueForKey:@"nameOf"]];
            [self.drug setText:[self.results[0] valueForKey:@"drug"]];
            ind = 0;
        }
        [UIView animateWithDuration:0.1 animations:^{
            [self.image setAlpha:1.0];
            [self.name setAlpha:1.0];
            [self.drug setAlpha:1.0];
        }];
    }];
    
}

- (IBAction)left:(UIButton *)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.image setAlpha:0.0];
        [self.name setAlpha:0.0];
        [self.drug setAlpha:0.0];
    } completion:^(BOOL finished) {
        if (ind > 0) {
            if ([[self.results[ind-1] valueForKey:@"image"] length] > 0) {
                [self.image setImage:[UIImage imageWithData:[self.results[ind-1] valueForKey:@"image"]] forState:UIControlStateNormal];
            } else {
                [self.image setImage:[UIImage imageNamed:@"company"] forState:UIControlStateNormal];
            }
            [self.name setText:[self.results[ind-1] valueForKey:@"nameOf"]];
            [self.drug setText:[self.results[ind-1] valueForKey:@"drug"]];
            ind--;
        } else if (ind == 0) {
            if ([[self.results[[self.results count] - 1] valueForKey:@"image"] length] > 0) {
                [self.image setImage:[UIImage imageWithData:[self.results[[self.results count] - 1] valueForKey:@"image"]] forState:UIControlStateNormal];
            } else {
                [self.image setImage:[UIImage imageNamed:@"company"] forState:UIControlStateNormal];
            }
            [self.name setText:[self.results[[self.results count] - 1] valueForKey:@"nameOf"]];
            [self.drug setText:[self.results[[self.results count] - 1] valueForKey:@"drug"]];
            ind = (int)[self.results count] - 1;
        }
        [UIView animateWithDuration:0.1 animations:^{
            [self.image setAlpha:1.0];
            [self.name setAlpha:1.0];
            [self.drug setAlpha:1.0];
        }];
    }];
    
}

- (IBAction)toPreparat:(UIButton *)sender {
    
    self.molecule = [NSMutableArray arrayWithArray:[self.arrPeopleInfo objectAtIndex:ind]];
    [ud setObject:[self.IDs objectAtIndex:ind] forKey:@"id"];
    [self performSegueWithIdentifier:@"toDrug" sender:self];
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toDrug"]) {
        
        SecondDocumentViewController *sdvc = [segue destinationViewController];
        NSLog(@"%@", self.molecule);
        
        sdvc.info = [self.molecule mutableCopy];
        DBManager *manager = [[DBManager alloc] init];
        manager.arrColumnNames = [self.dbManager.arrColumnNames mutableCopy];
        manager.affectedRows = self.dbManager.affectedRows;
        manager.lastInsertedRowID = self.dbManager.lastInsertedRowID;
        sdvc.dbManager = manager;
        
    }
    
}
@end
