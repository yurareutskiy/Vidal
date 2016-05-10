//
//  CollectTableVieCell.m
//  Vidal
//
//  Created by Anton Scherbakov on 06/05/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "CollectTableVieCell.h"

@implementation CollectTableVieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.delegate perfSeg3:self];
    [self.delegate perfSeg4:self];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) rotateImage: (double) degree {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.image.transform = CGAffineTransformMakeRotation(degree);
    }];
}

@end
