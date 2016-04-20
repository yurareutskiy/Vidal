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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    NSString *request = @"SELECT InfoPage.InfoPageID, InfoPage.RusName AS Name, InfoPage.RusAddress, InfoPage.PhoneNumber, InfoPage.Email, Country.RusName FROM InfoPage INNER JOIN Picture ON InfoPage.PictureID = Picture.PictureID INNER JOIN Country ON InfoPage.CountryCode = Country.CountryCode ORDER BY Name";
    [self loadData:request];
    
    [super setLabel:@"Производители"];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    if(selectedRowIndex && indexPath.row == selectedRowIndex.row) {
        return sizeCell;
    }
    return 80;

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
    
    
    // Set the loaded data to the appropriate cell labels.
    cell.nameUnhid.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName]];
    cell.countryUnhid.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfRusName]];
    cell.nameHid.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName]];
    cell.countryHid.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfRusName]];
    cell.addressHid.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfAddress]];
    cell.emailHid.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfEmail]];
    cell.phoneHid.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPhone]];
    
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
    selectedRowIndex = [indexPath copy];
    
    [self.tableView beginUpdates];
    
    ProducersTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    sizeCell = [self labelSize:cell.nameHid.text] + [self labelSize:cell.countryHid.text] + cell.listBtn.frame.size.height + [self labelSize:cell.addressHid.text] + [self labelSize:cell.emailHid.text] + [self labelSize:cell.phoneHid.text] + 25;
    
    NSInteger indexOfID = [self.dbManager.arrColumnNames indexOfObject:@"InfoPageID"];
    
    [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfID] forKey:@"info"];
    
    cell.nameUnhid.hidden = true;
    cell.countryUnhid.hidden = true;
    
    cell.nameHid.hidden = false;
    cell.countryHid.hidden = false;
    cell.image.hidden = false;
    cell.addressHid.hidden = false;
    cell.emailHid.hidden = false;
    cell.phoneHid.hidden = false;
    cell.listBtn.hidden = false;
    
    [self.tableView endUpdates];
    

}

- (CGFloat) labelSize:(NSString *)text  {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 0)];
    NSString *string = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    label.attributedText = attributedString;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Lucida_Grande-Regular" size:17.f];
    [label sizeToFit];
    CGFloat result = label.frame.size.height + 5;
    
    return result;
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView beginUpdates];
    
    ProducersTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.nameUnhid.hidden = false;
    cell.countryUnhid.hidden = false;
    
    cell.nameHid.hidden = true;
    cell.countryHid.hidden = true;
    cell.image.hidden = true;
    cell.addressHid.hidden = true;
    cell.emailHid.hidden = true;
    cell.phoneHid.hidden = true;
    cell.listBtn.hidden = true;
    
    [self.tableView endUpdates];

}

- (void) perfSeg: (ProducersViewController *) sender {
    
    [self performSegueWithIdentifier:@"toList" sender:self];
    
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
