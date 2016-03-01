//
//  RegViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 28/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HSDatePickerViewController.h>

@interface RegViewController : UIViewController<HSDatePickerViewControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *month;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentSize;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *agree;
@property (strong, nonatomic) IBOutlet UIButton *worker;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

- (IBAction)callDatePicker:(UIButton*)sender;
- (IBAction)regButton:(UIButton *)sender;


@end
