//
//  DBManager.h
//  Vidal
//
//  Created by Anton Scherbakov on 01/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject <NSCopying>

-(instancetype)initWithDatabaseFilename;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@end
