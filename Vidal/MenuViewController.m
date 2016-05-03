//
//  MenuViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController {
    UITapGestureRecognizer *singleFingerTap;
    NSUserDefaults *ud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.revealViewController.delegate = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    
    [[self.vidal imageView] setContentMode:UIViewContentModeScaleAspectFit];
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width - 80.0;
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController
                                            action:@selector(revealToggle:)];
    //    [self.view addGestureRecognizer:singleFingerTap];
    
    [self.revealViewController.frontViewController.view addGestureRecognizer:singleFingerTap];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [self.revealViewController.frontViewController.view removeGestureRecognizer:singleFingerTap];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reveal)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.revealViewController.frontViewController.view addGestureRecognizer:swipe];
    
}

- (void)reveal {
    
    [self.revealViewController revealToggleAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)toNews:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toNews" sender:self];
    
}

- (IBAction)toDrugs:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toDrugs" sender:self];
    
}

- (IBAction)toActive:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toActive" sender:self];
    
}

- (IBAction)toInteractions:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toInteractions" sender:self];
    
}

- (IBAction)toPharma:(UIButton *)sender {
    
    [ud removeObjectForKey:@"howTo"];
    [self performSegueWithIdentifier:@"toPharma" sender:self];
    
}

- (IBAction)toProducers:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toProducers" sender:self];
    
}

- (IBAction)toAbout:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toAbout" sender:self];
    
}

- (IBAction)toProfile:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toProfile" sender:self];
    
}

- (IBAction)toFavourite:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toFavourite" sender:self];
    
}

- (IBAction)toReference:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toReference" sender:self];
    
}

- (IBAction)registration:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toReg" sender:self];
}

- (IBAction)toVidal:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toVidal" sender:self];
}
@end
