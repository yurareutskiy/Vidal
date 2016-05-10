//
//  DocsTableViewCell.h
//  Vidal
//
//  Created by Test Account on 06/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DocsTableViewCell;
@protocol DocsTableViewCellDelegate <NSObject>

- (void) perfSeg: (DocsTableViewCell *) sender;
- (void) perfSeg2: (DocsTableViewCell *) sender;

@end

@interface DocsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) NSString *expanded;

- (void) rotateImage: (double) degree;


@property (nonatomic, weak) id <DocsTableViewCellDelegate> delegate;

@end
