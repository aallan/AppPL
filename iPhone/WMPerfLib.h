//
//  WMPerfLib.h
//  App Performance Library
//
//  Created by Alasdair Allan on 01/12/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

/* 
 
 TO DO: Version 1 (still outstanding as of 8/Mar/11)
 
 * Implement serialisation of queue on applicaiton quit/suspend
 * Documentation
	- Sample applications
	- How-to install AppPL in your application
	- How-to configure AppPL for your application
	- How-to expose ON/OFF to user in preference bundle of your app
	- Screencast
 
 */

#import <Foundation/Foundation.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sqlite3.h>


#define WM_VERSION 0.9
#define ISO_TIMEZONE_UTC_FORMAT @"Z"
#define ISO_TIMEZONE_OFFSET_FORMAT @"%+02d%02d"

#define WM_SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
[[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
}

#pragma mark -
#pragma mark WMResponse

@interface WMResponse : NSObject {
	
	NSURL *url;
	
	NSString *uniqueIdentifier;
	NSString *name;
	NSString *systemName;
	NSString *systemVersion; 
	NSString *model;
	NSString *localizedModel;
	
	NSString *carrierName;
	NSString *isoCountryCode;
	NSString *mobileCountryCode;
	NSString *mobileNetworkCode;
	
	NSString *ipAddress;
	NSString *connectionType;
	
	NSString *when;
	CFTimeInterval initRequest;
	CFTimeInterval didReceiveResponse;
	CFTimeInterval didReceiveFirstData;
	CFTimeInterval didFinishLoading;
	
	int bytesReceived;
	
	BOOL error;
	NSString *errorString;
	int errorCode;
}

@property (nonatomic, retain) NSURL *url;

@property (nonatomic, retain) NSString *uniqueIdentifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *systemName;
@property (nonatomic, retain) NSString *systemVersion; 
@property (nonatomic, retain) NSString *model;
@property (nonatomic, retain) NSString *localizedModel;

@property (nonatomic, retain) NSString *carrierName;
@property (nonatomic, retain) NSString *isoCountryCode;
@property (nonatomic, retain) NSString *mobileCountryCode;
@property (nonatomic, retain) NSString *mobileNetworkCode;

@property (nonatomic, retain) NSString *ipAddress;
@property (nonatomic, retain) NSString *connectionType;

@property (nonatomic, retain) NSString *when;
@property (nonatomic) CFTimeInterval initRequest;
@property (nonatomic) CFTimeInterval didReceiveResponse;
@property (nonatomic) CFTimeInterval didReceiveFirstData;
@property (nonatomic) CFTimeInterval didFinishLoading;

@property (nonatomic) int bytesReceived;

@property (nonatomic) BOOL error;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic) int errorCode;

@end


#pragma mark -
#pragma mark WMResponseQueue


@interface WMResponseQueue : NSObject {
	
	NSMutableArray *queue;
	
	NSString *databasePath;
	sqlite3 *queueDB;
	
}

@property (nonatomic, retain) NSMutableArray *queue;

- (void)addResponse:(WMResponse *)response;
- (void)removeResponse:(WMResponse *)response;
- (WMResponse *)popResponse;
- (int)sizeOfQueue;
- (void)flushQueue;
- (void)saveQueue;

@end


#pragma mark -
#pragma mark WMPerfLib

@protocol WMPerfLibDelegate <NSObject>

@optional
- (void)flushedResponseQueue:(NSString *)jsonString;
- (void)flushFailedWithError:(NSError *)error;

@end


@interface WMPerfLib : NSObject {

	BOOL libraryDebug;
	BOOL libraryOff;
	BOOL waitForWiFi;
	
	NSString *token;
	WMResponseQueue *queue;
	
}

@property (nonatomic, retain) WMResponseQueue *queue;
@property (nonatomic, retain) NSString *token;
@property (nonatomic) BOOL libraryDebug;
@property (nonatomic) BOOL libraryOff;
@property (nonatomic) BOOL waitForWiFi;

+ (WMPerfLib*) sharedWMPerfLib; 
+ (id) delegate;	
+ (void) setDelegate:(id)newDelegate;

- (void) status;

@end

#pragma mark -
#pragma mark WMURLConnection

@interface WMURLConnection : NSURLConnection {
	
	id _myDelegate;
	WMResponse *analytics;
	
	BOOL firstData;
	NSMutableData *responseData;	
}

@end

#pragma mark -
#pragma mark WMWebView

@protocol WMWebViewDelegate <UIWebViewDelegate>


@end

@interface WMWebView : UIWebView <WMWebViewDelegate> {
	
	id <WMWebViewDelegate> _myDelegate;
	WMResponse *analytics;
	
}

@end

#pragma mark -
#pragma mark WMUtil

@interface WMUtil : NSObject {
	
}

+ (NSString *)base64forData:(NSData*)theData;
+ (NSString *)getIPAddress;
+ (NSString *)connectionType;
+ (NSString *)stringFromDate:(NSDate *)theDate;
+ (NSDate *)dateFromString:(NSString *)theString;

@end

@interface WMUtil (Private)


@end

#pragma mark -
#pragma mark WMDispatch

@interface WMDispatch : NSObject {

	WMResponse *analytics;
	NSMutableData *responseData;
	NSURL *theURL;
	
}

- (void)dispatchResponseQueue:(WMResponseQueue *)responseQueue;

@end


