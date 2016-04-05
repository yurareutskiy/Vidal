//
//  ProducersViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ProducersViewController.h"

@interface ProducersViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;

-(void)loadData:(NSString *)req;

@end

@implementation ProducersViewController {
    
    NSIndexPath *selectedRowIndex;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    NSString *request = @"SELECT InfoPage.RusName AS Name, InfoPage.RusAddress, InfoPage.PhoneNumber, InfoPage.Email, Country.RusName FROM InfoPage INNER JOIN InfoPage_Picture ON InfoPage.InfoPageID = InfoPage_Picture.InfoPageID INNER JOIN Picture ON InfoPage_Picture.PictureID = Picture.PictureID INNER JOIN Country ON InfoPage.CountryCode = Country.CountryCode ORDER BY Name";
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
        return 400;
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
    
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).nameUnhid.hidden = true;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).countryUnhid.hidden = true;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).nameHid.hidden = false;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).countryHid.hidden = false;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).image.hidden = false;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).addressHid.hidden = false;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).emailHid.hidden = false;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).phoneHid.hidden = false;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).listBtn.hidden = false;
    
    [self.tableView endUpdates];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView beginUpdates];
    
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).nameUnhid.hidden = false;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).countryUnhid.hidden = false;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).nameHid.hidden = true;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).countryHid.hidden = true;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).image.hidden = true;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).addressHid.hidden = true;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).emailHid.hidden = true;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).phoneHid.hidden = true;
    ((ProducersTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).listBtn.hidden = true;
    
    [self.tableView endUpdates];
    
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
