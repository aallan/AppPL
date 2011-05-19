//
//  WMAppPL.h
//  App Performance Library
//
//  Created by Alasdair Allan on 01/12/2010.
//  Copyright 2010 WatchMouse. All rights reserved.
//  This code is released under the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

/* 
 
 Documentation
	- Sample applications
	- How-to install AppPL in your application
	- How-to configure AppPL for your application
	- How-to expose ON/OFF to user in preference bundle of your app
	- Screencast
 
 */

#import <Foundation/Foundation.h>

#include <ifaddrs.h>
#include <arpa/inet.h>


#define WM_VERSION 0.9
#define ISO_TIMEZONE_UTC_FORMAT @"Z"
#define ISO_TIMEZONE_OFFSET_FORMAT @"+%02d%02d"

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

@interface WMResponse : NSObject <NSCoding> {
	
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

    BOOL waitForNextFlush;
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

@property (nonatomic) BOOL waitForNextFlush;

@end


#pragma mark -
#pragma mark WMResponseQueue


@interface WMResponseQueue : NSObject <NSCoding> {
	
	NSMutableArray *queue;
		
}

@property (nonatomic, retain) NSMutableArray *queue;

- (void)addResponse:(WMResponse *)response;
- (void)removeResponse:(WMResponse *)response;
- (WMResponse *)popResponse;
- (int)sizeOfQueue;

@end


#pragma mark -
#pragma mark WMAppPL

@protocol WMAppPLDelegate <NSObject>

@optional
- (void)flushCompletedWithResponse:(NSString *)json;
- (void)flushFailedWithError:(NSError *)error andResponse:(NSString *)json;

@end


@interface WMAppPL : NSObject {

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

+ (WMAppPL*) sharedWMAppPL; 
+ (id) delegate;	
+ (void) setDelegate:(id)newDelegate;

- (void) status;
- (void) archiveQueue;
- (void) restoreQueue;
- (void) flushQueue;

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
+ (NSString *)documentsDirectoryPath;

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


