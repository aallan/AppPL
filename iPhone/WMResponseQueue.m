//
//  WMResponseQueue.m
//  App Performance Library
//
//  Created by Alasdair Allan on 06/12/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "WMPerfLib.h"


@implementation WMResponseQueue

@synthesize queue;

- (id)init {
	
	if( self = [super init] ) {
		queue = [[NSMutableArray alloc] init];
		
		// check for saved state in database, 
		// create database if it doesn't exist
		
		// Check database exists
		NSArray *directoryPaths = 
		NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDirectory = [directoryPaths objectAtIndex:0];
		
		// Build the path to the database file
		databasePath = [[NSString alloc] initWithString: [documentDirectory stringByAppendingPathComponent: @"queue.db"]];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if ([fileManager fileExistsAtPath: databasePath ] == NO) {
			const char *dbpath = [databasePath UTF8String];
			
			if (sqlite3_open(dbpath, &queueDB) == SQLITE_OK) {
				char *errMsg;
				const char *sql_stmt = "CREATE TABLE IF NOT EXISTS QUEUE (ID INTEGER PRIMARY KEY AUTOINCREMENT, ENTRY TEXT)";
				
				if (sqlite3_exec(queueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
					if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
						NSLog(@"WMResponseQueue: init: Failed to create queue.db table.");
					}
				}
				sqlite3_close(queueDB);
				
			} else {
				if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
					NSLog(@"WMResponseQueue: init: Failed to open/create queue.db");
				}
			}
		}
		[fileManager release];
		
		// Grab contents of database
		
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[queue release];
}

- (void)addResponse:(WMResponse *)response {
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		//NSLog(@"WMResponseQueue: addResponse: Adding response to queue: %@", response);
		NSLog(@"WMResponseQueue: addResponse: Adding response to queue");
	}
	[self.queue addObject:response];

	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMResponseQueue: addResponse: Attempting to flush response to acceptor");
	}
	
	if ( [WMPerfLib sharedWMPerfLib].waitForWiFi ) {

		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMResponseQueue: addResponse: waitForWiFi = %d", 
				  [WMPerfLib sharedWMPerfLib].waitForWiFi );
		}
		
		if ( [[WMUtil connectionType] isEqualToString:@"wifi"] ) {
			WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
			[dispatch dispatchResponseQueue:self];		
			if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: Flushed response to acceptor"); 
			}	  
		} else {
			if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: Queued response for future delivery"); 
			}	 			
		}
	} else {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMResponseQueue: addResponse: waitForWiFi = %d, ctype = %@", 
				  [WMPerfLib sharedWMPerfLib].waitForWiFi,[WMUtil connectionType]);
		}	
		if ([[WMUtil connectionType] isEqualToString:@"wifi"] ||
			[[WMUtil connectionType] isEqualToString:@"wwan"] ) {
			WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
			[dispatch dispatchResponseQueue:self];			
			if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: Flushed response to acceptor"); 
			}	  
		} else {
			if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: No Internet connection. Queued."); 
			}	  
			
		}

	}
		
}

- (void)removeResponse:(WMResponse *)response {
	[self.queue removeObject:response];
}

- (WMResponse *)popResponse {
	
	WMResponse *response = nil;
	if( self.queue.count >= 1 ) {
		response = 	[self.queue objectAtIndex:0];
		[self.queue removeObjectAtIndex:0];
	}
    return response;
	
}

- (int)sizeOfQueue {
	return [self.queue count];
	
}

- (void)flushQueue {
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMResponseQueue: flushQueue: Flushing response queue to acceptor");
	}
	WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
	[dispatch dispatchResponseQueue:self];	
	
}

- (void)saveQueue {
	
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMResponseQueue: saveQueue: Saving queue to database.");
	}
													  
/*
 
 const char *dbpath = [databasePath UTF8String];
 
 if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
 {
 NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO CONTACTS (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")", name.text, address.text, phone.text];
 
 const char *insert_stmt = [insertSQL UTF8String];
 
 sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
 if (sqlite3_step(statement) == SQLITE_DONE)
 {
 status.text = @"Contact added";
 name.text = @"";
 address.text = @"";
 phone.text = @"";
 } else {
 status.text = @"Failed to add contact";
 }
 sqlite3_finalize(statement);
 sqlite3_close(contactDB);
 }
 */
	
}

@end
