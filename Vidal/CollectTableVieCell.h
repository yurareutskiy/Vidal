//
//  CollectTableVieCell.h
//  Vidal
//
//  Created by Anton Scherbakov on 06/05/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectTableVieCell;
@protocol CollectTableVieCellDelegate <NSObject>

- (void) perfSeg3: (CollectTableVieCell *) sender;
- (void) perfSeg4: (CollectTableVieCell *) sender;

@end

@interface CollectTableVieCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *desc;

- (void) rotateImage: (double) degree;


@property (nonatomic, weak) id <CollectTableVieCellDelegate> delegate;

@end
