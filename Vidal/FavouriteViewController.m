//
//  FavouriteViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "FavouriteViewController.h"

@interface FavouriteViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (strong, nonatomic) UIBarButtonItem *searchButton;

-(void)loadData:(NSString *)req;

@end

@implementation FavouriteViewController {
    
    BOOL container;
    UITapGestureRecognizer *tap;
    NSUserDefaults *ud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    ((DocumentViewController *)self.childViewControllers.lastObject).tableView.delegate = self;
    ((DocumentViewController *)self.childViewControllers.lastObject).tableView.dataSource = self;
    [((DocumentViewController *)self.childViewControllers.lastObject).tableView setTag:2];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    
    NSString *request = @"";
    NSArray *data = [NSArray arrayWithArray:[ud objectForKey:@"favs"]];
    NSLog(@"%@", [ud objectForKey:@"favs"]);
    NSLog(@"%@", data);
    if ([data count] == 1) {
        request = [NSString stringWithFormat:@"SELECT * FROM ClinicoPhPointers WHERE ClinicoPhPointers.ClPhPointerID = %@", [data objectAtIndex:0]];
    }
    if ([data count] > 1) {
        request = [NSString stringWithFormat:@"SELECT * FROM ClinicoPhPointers WHERE ClinicoPhPointers.ClPhPointerID = %@", [data objectAtIndex:0]];
        for (int i = 1; i < [data count]; i++) {
            request = [NSString stringWithFormat:@"%@ OR ClinicoPhPointers.ClPhPointerID = %@", request, [data objectAtIndex:i]];
        }
    }
    [self loadData:request];
    
    
    [self setLabel:@"Список препаратов"];
    
    container = false;
    self.containerView.hidden = true;
    self.darkView.hidden = true;
    
    tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(close)];
    
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(30, 20)]
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
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

- (void) close {
    self.containerView.hidden = true;
    container = false;
    [self.darkView removeGestureRecognizer:tap];
    self.darkView.hidden = true;
}

- (void) setLabel:(NSString *)label {
    UILabel* labelName = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    labelName.textAlignment = NSTextAlignmentLeft;
    labelName.text = NSLocalizedString(label, @"");
    labelName.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = labelName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    
    static NSString *CellIdentifier = @"activeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
    
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName];
    
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
    
    if ([self.arrPeopleInfo count] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert title" message:@"Alert message" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [self.navigationController popViewControllerAnimated:YES];
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    // Reload the table view.
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrPeopleInfo.count;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
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
