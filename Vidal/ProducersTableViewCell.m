//
//  ProducersTableViewCell.m
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ProducersTableViewCell.h"

@implementation ProducersTableViewCell

- (void)awakeFromNib {
    
    NSString *string = self.name.text;
    self.name.numberOfLines = 0;
    self.name.text = string;
    [self.name sizeToFit];
    
    NSString *string1 = self.country.text;
    self.country.numberOfLines = 0;
    self.country.text = string1;
    [self.country sizeToFit];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
