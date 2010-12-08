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

#define WMDEBUG 1
#define WMFLUSH 1

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
	
	NSString *url;
	
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
	
	CFTimeInterval initRequest;
	CFTimeInterval didReceiveResponse;
	CFTimeInterval didReceiveFirstData;
	CFTimeInterval didFinishLoading;
	
	int bytesReceived;
	
	BOOL error;
	NSString *errorString;
	int errorCode;
}

@property (nonatomic, retain) NSString *url;

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

	NSString *token;
	WMResponseQueue *queue;
	
}

@property (nonatomic, retain) WMResponseQueue *queue;
@property (nonatomic, retain) NSString *token;

+ (WMPerfLib*) sharedWMPerfLib; 

@end

#pragma mark -
#pragma mark WMURLConnection

@interface WMURLConnection : NSURLConnection {
	
	id _myDelegate;
	WMResponse *analytics;
	
	BOOL firstData;
	
}

@end

#pragma mark -
#pragma mark WMWebView

@protocol WMWebViewDelegate <UIWebViewDelegate>


@end

@interface WMWebView : UIWebView <WMWebViewDelegate> {
	
	id <WMWebViewDelegate> _myDelegate;
	
}

@end

#pragma mark -
#pragma mark WMUtil

@interface WMUtil : NSObject {
	
}

+ (NSString *)base64forData:(NSData*)theData;
+ (NSString *)getIPAddress;

@end

@interface WMUtil (Private)


@end


