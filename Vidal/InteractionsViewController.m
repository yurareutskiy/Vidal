//
//  InteractionsViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "InteractionsViewController.h"

@interface InteractionsViewController ()

@end

@implementation InteractionsViewController {
    
    BOOL textField1;
    BOOL textField2;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string = self.info1.text;
    self.info1.numberOfLines = 0;
    self.info1.text = string;
    [self.info1 sizeToFit];
    
    textField1 = false;
    textField2 = false;
    
    self.hello1 = @[@"hello1", @"heo2", @"helo3", @"helo4", @"hel5", @"hllo6", @"ello7"];
    [self setUpQuickSearch];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchField.delegate = self;
    self.secondInput.delegate = self;
    
    self.secondInput.hidden = true;
    self.secondLine.hidden = true;
    self.secondLabel.hidden = true;
    
    self.tableView.hidden = true;
    
    self.FilteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    
    // Do any additional setup after loading the view.
}

- (void)setUpQuickSearch {
    // Create Filters
    IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:self.hello1 keys:@[@"description"]];
    self.quickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter]];
}

- (void)filterResults {
    // Asynchronously
    [self.quickSearch asynchronouslyFilterObjectsWithValue:self.searchField.text completion:^(NSArray *filteredResults) {
        [self updateTableViewWithNewResults:filteredResults];
    }];
    
    // Synchronously
    //[self updateTableViewWithNewResults:[self.QuickSearch filteredObjectsWithValue:self.searchTextField.text]];
}

- (void)updateTableViewWithNewResults:(NSArray *)results {
    self.FilteredResults = results;
    [self.tableView reloadData];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.FilteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (textField1) {
        self.searchField.text = self.FilteredResults[indexPath.row];
    } else if (textField2) {
        self.secondInput.text = self.FilteredResults[indexPath.row];
    }
    self.tableView.hidden = true;
    self.secondInput.hidden = false;
    self.secondLine.hidden = false;
    self.secondLabel.hidden = false;
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.tableView.hidden = true;
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        textField1 = true;
        textField2 = false;
    } else if (textField.tag == 2) {
        textField2 = true;
        textField1 = false;
    }
    self.tableView.hidden = false;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.input resignFirstResponder];
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
