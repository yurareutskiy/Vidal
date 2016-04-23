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
    
    NSString *request = @"SELECT Picture.Image, InfoPage.InfoPageID, InfoPage.RusName AS Name, InfoPage.RusAddress, InfoPage.PhoneNumber, InfoPage.Email, Country.RusName FROM InfoPage INNER JOIN Picture ON InfoPage.PictureID = Picture.PictureID INNER JOIN Country ON InfoPage.CountryCode = Country.CountryCode ORDER BY Name";
    [self loadData:request];
    
    [super setLabel:@"Производители"];
    
    
    
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    
    
    if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
        if (open) {
            return sizeCell;
        } else {
            return 90;
        }
    } else {
        return 90;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(ProducersTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    ProducersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"producersCell" forIndexPath:indexPath];
    
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
    NSInteger indexOfAddress = [self.dbManager.arrColumnNames indexOfObject:@"RusAddress"];
    NSInteger indexOfRusName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
    NSInteger indexOfEmail = [self.dbManager.arrColumnNames indexOfObject:@"Email"];
    NSInteger indexOfPhone = [self.dbManager.arrColumnNames indexOfObject:@"PhoneNumber"];
    NSInteger indexOfImage = [self.dbManager.arrColumnNames indexOfObject:@"Image"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.nameUnhid.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName]]];
    cell.countryUnhid.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfRusName]]];
    cell.nameHid.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName]]];
    cell.countryHid.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfRusName]]];
    cell.addressHid.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfAddress]]];
    cell.emailHid.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfEmail]]];
    cell.phoneHid.text = [self clearString:[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPhone]]];
    [cell.image setImage:[UIImage imageWithData:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfImage]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    return cell;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrPeopleInfo.count;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"toCompany" sender:self];
    
//    selectedRowIndex = [indexPath copy];
//    
//    [self.tableView beginUpdates];
//    
//    ProducersTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    
////    sizeCell = [self labelSize:cell.nameHid.text] + [self labelSize:cell.countryHid.text] + cell.listBtn.frame.size.height + [self labelSize:cell.addressHid.text] + [self labelSize:cell.emailHid.text] + [self labelSize:cell.phoneHid.text] + 25;
//    
//    sizeCell = 10.0 + 70.0 + 15.0 + 60.0 + 15.0 + [self labelSize:cell.addressHid.text] + 20.0 + [self labelSize:cell.emailHid.text] + 5.0 + [self labelSize:cell.phoneHid.text] + 5.0;
//    
//    NSInteger indexOfID = [self.dbManager.arrColumnNames indexOfObject:@"InfoPageID"];
//    
//    [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfID] forKey:@"info"];
//    
//    if (!open) {
//        open = true;
//    } else {
//        open = false;
//    }
//    
////    cell.nameUnhid.hidden = true;
////    cell.countryUnhid.hidden = true;
////    
////    cell.nameHid.hidden = false;
////    cell.countryHid.hidden = false;
////    cell.image.hidden = false;
////    cell.addressHid.hidden = false;
////    cell.emailHid.hidden = false;
////    cell.phoneHid.hidden = false;
////    cell.listBtn.hidden = false;
//    
//    [self.tableView endUpdates];
    

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
    
//    ProducersTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    
//    cell.nameUnhid.hidden = false;
//    cell.countryUnhid.hidden = false;
//    
//    cell.nameHid.hidden = true;
//    cell.countryHid.hidden = true;
//    cell.image.hidden = true;
//    cell.addressHid.hidden = true;
//    cell.emailHid.hidden = true;
//    cell.phoneHid.hidden = true;
//    cell.listBtn.hidden = true;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
