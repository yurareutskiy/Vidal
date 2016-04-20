//
//  ProducersTableViewCell.m
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ProducersTableViewCell.h"

@implementation ProducersTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    
    NSString *string = self.nameUnhid.text;
    self.nameUnhid.numberOfLines = 0;
    self.nameUnhid.text = string;
    [self.nameUnhid sizeToFit];
    
    NSString *string1 = self.nameHid.text;
    self.nameHid.numberOfLines = 0;
    self.nameHid.text = string1;
    [self.nameHid sizeToFit];
    
    NSString *string2 = self.addressHid.text;
    self.addressHid.numberOfLines = 0;
    self.addressHid.text = string2;
    [self.addressHid sizeToFit];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toListDrugs:(UIButton *)sender {
    
    [self.delegate perfSeg:self];
    
}
@end
