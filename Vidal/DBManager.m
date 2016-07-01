//
//  DBManager.m
//  Vidal
//
//  Created by Anton Scherbakov on 01/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "DBManager.h"

@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrResults;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation DBManager {
    sqlite3 *db;
    sqlite3 *unencrypted_DB;
    NSString *databaseURL;
    NSUserDefaults *ud;
}

-(instancetype)initWithDatabaseFilename{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    
    // Set the database file path.
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"vidal.cardio.db3"];
    NSLog(@"database path %@", databasePath);
    
    ud = [NSUserDefaults standardUserDefaults];
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &db);
    if(openDatabaseResult == SQLITE_OK) {
        
        const char* key = [[ud valueForKey:@"pass"] UTF8String];
        NSLog(@"key - %s", key);
        sqlite3_exec(db, "PRAGMA cipher_default_kdf_iter = 4000;", nil, nil, nil);
        sqlite3_key(db, key, (int)strlen(key));
        sqlite3_exec(db, "PRAGMA cipher_page_size = 4096;", nil, nil, nil);

        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(db, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // In this case data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars;
                        NSData *data;
                        
                        if ([[ud valueForKey:@"howTo"] isEqualToString:@"about"]) {
                            if (i == 2) {
//                            dbDataAsChars = (char *)sqlite3_column_blob(compiledStatement, i);
                                data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, i) length:sqlite3_column_bytes(compiledStatement, i)];
                            } else {
                                dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                            }
                        } else if ([[ud valueForKey:@"howTo"] isEqualToString:@"prod"]) {
                            if (i == 11) {
                                //                            dbDataAsChars = (char *)sqlite3_column_blob(compiledStatement, i);
                                data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, i) length:sqlite3_column_bytes(compiledStatement, i)];
                            } else {
                                dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                            }
                        } else {
                            dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        }
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            if ([[ud valueForKey:@"howTo"] isEqualToString:@"about"]) {
                                if (i == 2) {
                                    [arrDataRow addObject:data];
                                } else {
                                    [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                                }
                            } else if ([[ud valueForKey:@"howTo"] isEqualToString:@"prod"]) {
                                if (i == 11) {
                                    [arrDataRow addObject:data];
                                } else {
                                    [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                                }
                            } else {
                                [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                            }
                        } else {
                            [arrDataRow addObject:@""];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                
                // Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == 101) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(db);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(db);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(db));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(db));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(db);
}

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrResults;
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

-(id)copyWithZone:(NSZone *)zone {
    DBManager *copy = [[DBManager alloc] init];
    copy.arrColumnNames = [_arrColumnNames copyWithZone:zone];
    copy.affectedRows = self.affectedRows;
    copy.lastInsertedRowID = self.lastInsertedRowID;
    return copy;
}

@end
