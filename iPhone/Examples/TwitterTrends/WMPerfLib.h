//
//  WMPerfLib.h
//  App Performance Library
//
//  Created by Alasdair Allan on 01/12/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <ifaddrs.h>
#include <arpa/inet.h>

#define WM_VERSION 0.1

// SYNTHESIZE_SINGLETON_FOR_CLASS
// Created by Matt Gallagher.
// http://cocoawithlove.com/2008/11/singletons-appdelegates-and-top-level.html
// Copyright 2008 Matt Gallagher. All rights reserved.
//
// Permission is given to use this source code file, free of charge, in any 
// project, commercial or otherwise, entirely at your risk, with the condition 
// that any redistribution (in part or whole) of source code must retain this 
// copyright and permission notice. Attribution in compiled projects is 
// appreciated but not required.

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
	
}

@property (nonatomic, retain) NSMutableArray *queue;

- (void)addResponse:(WMResponse *)response;
- (void)removeResponse:(WMResponse *)response;
- (WMResponse *)popResponse;

@end


#pragma mark -
#pragma mark WMPerfLib

@interface WMPerfLib : NSObject {

	BOOL libraryDebug;
	BOOL libraryOff;
	
	NSString *token;
	WMResponseQueue *queue;
	
}

@property (nonatomic, retain) WMResponseQueue *queue;
@property (nonatomic, retain) NSString *token;
@property (nonatomic) BOOL libraryDebug;
@property (nonatomic) BOOL libraryOff;

+ (WMPerfLib*) sharedWMPerfLib; 
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

- (void)dispatchResponse:(WMResponse *)response;

@end


