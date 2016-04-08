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

-(void)copyDatabaseIntoDocumentsDirectory;

@property (nonatomic, strong) NSMutableArray *arrResults;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation DBManager {
    sqlite3 *db;
    sqlite3 *unencrypted_DB;
    NSString *databaseURL;
}

-(instancetype)initWithDatabaseFilename{
    self = [super init];
    if (self) {
        
        //[self encryptDB];
        //[self openCipherDB];
        
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = @"vidal.cardio.encrypt.db3";
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
        
    }
    return self;
}

- (void) openCipherDB
{
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"unencrypted.db3"];
    NSLog(@"database path %@", databasePath);
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)
    {
        //const char* key = [@"#test_db_key" UTF8String];
        int sqlite3_key(sqlite3 *db, const void *pKey, int nKey);       //i added this after seeing SO
        //sqlite3_key(db, key, strlen(key));
        if (sqlite3_exec(db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
            // password is correct, or, database has been initialized
            NSLog(@"database initialize");
        }
        else
        {
            NSLog(@"incorrect pass");
            // incorrect password!
        }
        
        sqlite3_close(db);
    }
}

- (void)encryptDB
{
    //sqlite3 *unencrypted_DB;
    NSString *path_u = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                        stringByAppendingPathComponent:@"unencrypted.db3"];
    
    NSString *sql1 = [NSString stringWithFormat:@"ATTACH DATABASE '%s' AS encrypted KEY '%s';", [databaseURL UTF8String], "#test_db_key"];
    //NSString *sql2 = [NSString stringWithFormat:@"DETACH DATABASE '%s';", [databaseURL UTF8String]];
    
    if (sqlite3_open([path_u UTF8String], &unencrypted_DB) == SQLITE_OK) {
        NSLog(@"Database Opened");
        // Attach empty encrypted database to unencrypted database
        NSLog(@"String is %@", sql1);
        sqlite3_exec(unencrypted_DB, [sql1 UTF8String], NULL, NULL, NULL);
        
        NSLog(@"%s", sqlite3_errmsg(unencrypted_DB));
        
        // export database
        sqlite3_exec(unencrypted_DB, "SELECT sqlcipher_export('encrypted');", NULL, NULL, NULL);
        
        NSLog(@"%s", sqlite3_errmsg(unencrypted_DB));
        
        // Detach encrypted database
        sqlite3_exec(unencrypted_DB, "DETACH DATABASE encrypted;", NULL, NULL, NULL);
        
        NSLog(@"%s", sqlite3_errmsg(unencrypted_DB));
        
        NSLog (@"End database copying");
        sqlite3_close(unencrypted_DB);
    }
    else {
        sqlite3_close(unencrypted_DB);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(unencrypted_DB));
    }
}

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Create a sqlite object.
    //sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
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
    
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &db);
    if(openDatabaseResult == SQLITE_OK) {
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
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
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

@end
