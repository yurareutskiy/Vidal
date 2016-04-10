//
//  Server.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "Server.h"

@implementation Server

- (void) registration:(NSDictionary *)data {
    
}

- (void) login:(NSDictionary *)data {
    
        AFHTTPRequestSerializer *requestSerializerTry = [AFHTTPRequestSerializer serializer];
        [requestSerializerTry setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setRequestSerializer:requestSerializerTry];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [manager setResponseSerializer:responseSerializer];
    
        NSDictionary *params = @{@"username":@"avscherbakov@icloud.com", //- email участника (bin@bk.ru)
                                 @"password":@"123456"}; //- его пароль в открытом виде (mySuperPw)
    
        [manager POST:@"http://vidal.ru/api/user/add" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    
}

- (id) getSpec {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.vidal.ru/api/specialties" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.dictSpec = [[NSDictionary alloc] initWithDictionary:responseObject];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    return self.dictSpec;
}

- (NSDictionary *) getUniver {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.vidal.ru/api/universities" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    return nil;
}

@end
