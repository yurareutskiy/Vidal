//
//  Server.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface Server : NSObject

@property (strong, nonatomic) NSDictionary *dictSpec;

- (void) registration:(NSDictionary *)data;
- (void) login:(NSDictionary *)data;
- (id) getSpec;
- (NSDictionary *) getUniver;

@end
