//
//  WMResponse.m
//  App Performance Library
//
//  Created by Alasdair Allan on 06/12/2010.
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

#import "WMAppPL.h"

@implementation WMResponse

@synthesize url;

@synthesize uniqueIdentifier;
@synthesize name;
@synthesize systemName;
@synthesize systemVersion; 
@synthesize model;
@synthesize localizedModel;

@synthesize carrierName;
@synthesize isoCountryCode;
@synthesize mobileCountryCode;
@synthesize mobileNetworkCode;

@synthesize ipAddress;
@synthesize connectionType;

@synthesize when;
@synthesize initRequest;
@synthesize didReceiveResponse;
@synthesize didReceiveFirstData;
@synthesize didFinishLoading;

@synthesize bytesReceived;

@synthesize error;
@synthesize errorString;
@synthesize errorCode;

@synthesize waitForNextFlush;

- (id)init {

	if( (self = [super init]) ) {

		self.uniqueIdentifier = [UIDevice currentDevice].uniqueIdentifier;
		self.name = [UIDevice currentDevice].name;
		self.systemName  = [UIDevice currentDevice].systemName;
		self.systemVersion = [UIDevice currentDevice].systemVersion; 
		self.model = [UIDevice currentDevice].model;
		self.localizedModel = [UIDevice currentDevice].localizedModel;

		CTTelephonyNetworkInfo *netInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
		CTCarrier *carrier = [netInfo subscriberCellularProvider];

		self.carrierName = [carrier carrierName];
		self.isoCountryCode = [carrier isoCountryCode];
		self.mobileCountryCode = [carrier mobileCountryCode];
		self.mobileNetworkCode = [carrier mobileNetworkCode];

		self.ipAddress = [WMUtil getIPAddress];
		self.connectionType = [WMUtil connectionType];
		
		self.when = [WMUtil stringFromDate:[NSDate date]];
        
        self.waitForNextFlush = NO;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
        self.url = [decoder decodeObjectForKey:@"url"];
        self.uniqueIdentifier = [decoder decodeObjectForKey:@"uniqueIdentifier"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.systemName = [decoder decodeObjectForKey:@"systemName"];
        self.systemVersion = [decoder decodeObjectForKey:@"systemVersion"];
        self.model = [decoder decodeObjectForKey:@"model"];
        self.localizedModel = [decoder decodeObjectForKey:@"localizedModel"];
        self.carrierName = [decoder decodeObjectForKey:@"carrierName"];
        self.isoCountryCode = [decoder decodeObjectForKey:@"isoCountryCode"];
        self.mobileCountryCode = [decoder decodeObjectForKey:@"mobileCountryCode"];
        self.mobileNetworkCode = [decoder decodeObjectForKey:@"mobileNetworkCode"];
        self.ipAddress = [decoder decodeObjectForKey:@"ipAddress"];
        self.connectionType = [decoder decodeObjectForKey:@"connectionType"];
        self.when = [decoder decodeObjectForKey:@"when"];
        self.initRequest = [decoder decodeDoubleForKey:@"initRequest"];
        self.didReceiveResponse = [decoder decodeDoubleForKey:@"didReceiveResponse"];
        self.didReceiveFirstData = [decoder decodeDoubleForKey:@"didReceiveFirstData"];
        self.didFinishLoading = [decoder decodeDoubleForKey:@"didFinishLoading"];
        self.bytesReceived = [decoder decodeIntForKey:@"bytesReceived"];
        self.error = [decoder decodeBoolForKey:@"error"];
        self.errorString = [decoder decodeObjectForKey:@"errorString"];
        self.errorCode = [decoder decodeIntForKey:@"errorCode"];
        self.waitForNextFlush = [decoder decodeBoolForKey:@"waitForNextFlush"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.uniqueIdentifier forKey:@"uniqueIdentifier"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.systemName forKey:@"systemName"];
    [encoder encodeObject:self.systemVersion forKey:@"systemVersion"];
    [encoder encodeObject:self.model forKey:@"model"];
    [encoder encodeObject:self.localizedModel forKey:@"localizedModel"];
    [encoder encodeObject:self.carrierName forKey:@"carrierName"];
    [encoder encodeObject:self.isoCountryCode forKey:@"isoCountryCode"];
    [encoder encodeObject:self.mobileCountryCode forKey:@"mobileCountryCode"];
    [encoder encodeObject:self.mobileNetworkCode forKey:@"mobileNetworkCode"];
    [encoder encodeObject:self.ipAddress forKey:@"ipAddress"];
    [encoder encodeObject:self.connectionType forKey:@"connectionType"];
    [encoder encodeObject:self.when forKey:@"when"];
    [encoder encodeDouble:self.initRequest forKey:@"initRequest"];
    [encoder encodeDouble:self.didReceiveResponse forKey:@"didReceiveResponse"];
    [encoder encodeDouble:self.didReceiveFirstData forKey:@"didReceiveFirstData"];
    [encoder encodeDouble:self.didFinishLoading forKey:@"didFinishLoading"];
    [encoder encodeInt:self.bytesReceived forKey:@"bytesReceived"];
    [encoder encodeBool:self.error forKey:@"error"];
    [encoder encodeObject:self.errorString forKey:@"errorString"];
    [encoder encodeInt:self.errorCode forKey:@"errorCode"];
    [encoder encodeBool:self.waitForNextFlush forKey:@"waitForNextFlush"];    
}

- (void)dealloc {
    [url release];
    [uniqueIdentifier release];
    [name release];
    [systemName release];
    [systemVersion release];
    [model release];
    [localizedModel release];
    [carrierName release];
    [isoCountryCode release];
    [mobileCountryCode release];
    [mobileNetworkCode release];
    [ipAddress release];
    [connectionType release];
    [when release];
    [errorString release];
    
    [super dealloc];
}

@end
