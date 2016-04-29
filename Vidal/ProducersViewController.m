//
//  ProducersViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ProducersViewController.h"

@interface ProducersViewController () <ProducersTableViewCellDelegate>

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;

-(void)loadData:(NSString *)req;

@end

@implementation ProducersViewController {
    
    NSIndexPath *selectedRowIndex;
    CGFloat sizeCell;
    NSUserDefaults *ud;
    BOOL open;
    
    NSString *nameToPass;
    NSString *countryToPass;
    NSString *addressToPass;
    NSString *emailToPass;
    NSString *phoneToPass;
    UIImage *imageToPass;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    open = false;
    
    [ud removeObjectForKey:@"listOfDrugs"];
    [ud removeObjectForKey:@"listOfDrugs"];
    
    [ud setValue:@"prod" forKey:@"howTo"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    NSString *request = @"select * from (select inf.*, cnt.RusName as CountryRusName, cnt.EngName as CountryEngName, p.Image from InfoPage inf left join Country cnt on inf.CountryCode = cnt.CountryCode left join Picture p on inf.PictureID = p.PictureID) order by RusName";
    [self loadData:request];
    
    self.navigationItem.title = @"Производители";
    
    [ud removeObjectForKey:@"workWith"];
    [ud removeObjectForKey:@"workActive"];
    [ud removeObjectForKey:@"activeID"];
    [ud removeObjectForKey:@"pharmaList"];
    [ud removeObjectForKey:@"comp"];
    [ud removeObjectForKey:@"from"];
    [ud removeObjectForKey:@"letterActive"];
    
    
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [ud setValue:@"prod" forKey:@"howTo"];
}

- (void) viewDidDisappear:(BOOL)animated {
    [ud setValue:@"0" forKey:@"howTo"];
}

- (void) viewWillDisappear:(BOOL)animated {
    [ud setValue:@"0" forKey:@"howTo"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(ProducersTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    ProducersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"producersCell" forIndexPath:indexPath];
    
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];

    NSInteger indexOfRusName = [self.dbManager.arrColumnNames indexOfObject:@"CountryRusName"];

    NSInteger indexOfImage = [self.dbManager.arrColumnNames indexOfObject:@"Image"];
    
    NSInteger indexPicture = [self.dbManager.arrColumnNames indexOfObject:@"PictureID"];
    
    
    // Set the loaded data to the appropriate cell labels.
    cell.nameHid.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName]]];
    if (![[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfRusName] isEqualToString:@""]) {
        cell.countryHid.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfRusName]]];
    } else {
        cell.countryHid.text = @"";
    }
    if (![[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexPicture] isEqualToString:@""]) {
        if (![[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfImage] isKindOfClass:[NSString class]]) {
            [cell.image setImage:[UIImage imageWithData:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfImage]]];
        } else {
            [cell.image setImage:[UIImage imageNamed:@"company"]];
        }
    } else {
        [cell.image setImage:[UIImage imageNamed:@"company"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    return cell;
}

-(void)loadData:(NSString *)req{
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    
    // Reload the table view.
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrPeopleInfo.count;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProducersTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger indexOfAddress = [self.dbManager.arrColumnNames indexOfObject:@"RusAddress"];
    NSInteger indexOfEmail = [self.dbManager.arrColumnNames indexOfObject:@"Email"];
    NSInteger indexOfPhone = [self.dbManager.arrColumnNames indexOfObject:@"PhoneNumber"];
    
    nameToPass = cell.nameHid.text;
    countryToPass = cell.countryHid.text;
    addressToPass = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfAddress]]];
    emailToPass = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfEmail]]];
    phoneToPass = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPhone]]];
    imageToPass = cell.image.image;
    
    NSInteger indexOfID = [self.dbManager.arrColumnNames indexOfObject:@"InfoPageID"];
    
    [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfID] forKey:@"info"];
    
    [self performSegueWithIdentifier:@"toCompany" sender:self];

}

- (CGFloat) labelSize:(NSString *)text  {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 0)];
    NSString *string = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0.5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    label.attributedText = attributedString;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Lucida_Grande-Regular" size:15.f];
    [label sizeToFit];
    CGFloat result = label.frame.size.height;
    
    return result;
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];

}

- (void) perfSeg: (ProducersViewController *) sender {
    
    [self performSegueWithIdentifier:@"toList" sender:self];
    
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toCompany"]) {
        CompanyViewController *cvc = [segue destinationViewController];
        
        cvc.name = nameToPass;
        cvc.country = countryToPass;
        cvc.address = addressToPass;
        cvc.email = emailToPass;
        cvc.phone = phoneToPass;
        cvc.logo = imageToPass;
    
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
