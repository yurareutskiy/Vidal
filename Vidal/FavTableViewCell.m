//
//  FavTableViewCell.m
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "FavTableViewCell.h"

@implementation FavTableViewCell

- (void)awakeFromNib {
    
    NSString *string = self.information.text;
    self.information.numberOfLines = 0;
    self.information.text = string;
    [self.information sizeToFit];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
