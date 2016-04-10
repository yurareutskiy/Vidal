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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"register[username]":@"avscherbakov@icloud.com", //- email участника (bin@bk.ru)
                             @"register[password]":@"mySuperPw", //- его пароль в открытом виде (mySuperPw)
                             @"register[firstName]":@"Щербаков", //- фамилия (Иван)
                             @"register[lastName]":@"Антон", //- имя (Иванов)
                             @"register[birthdate][day]":@"2", //- это день (1-31)
                             @"register[birthdate][month]":@"12", //- это номер месяца (1-12)
                             @"register[birthdate][year]":@"1996", //- это год (1999)
                             @"register[city]":@"Москва", //- это название города, см. выше (Москва)
                             @"register[primarySpecialty]":@"11"};
    [manager POST:@"http://vidal.ru/api/user/add" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
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

@end
