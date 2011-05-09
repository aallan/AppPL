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

#import "WMPerfLib.h"

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

- (NSString *)description {
	
	return [NSString stringWithFormat:
	 @"\n"
	 @"url = %@\n"
	 @"uniqueIdentifier = %@\n"
	 @"name = %@\n"
	 @"systemName = %@\n"
	 @"systemVersion = %@\n" 
	 @"model = %@\n"
	 @"localizedModel = %@\n"
	 @"carrierName = %@\n"
	 @"isoCountryCode = %@\n"
	 @"mobileCountryCode = %@\n"
	 @"mobileNetworkCode = %@\n"
	 @"ipAddress = %@\n"
	 @"connectionType = %@\n"		
	 @"initRequest = %f\n"
	 @"didReceiveResponse = %f\n"
	 @"didReceiveFirstData = %f\n"
	 @"didFinishLoading = %f\n"
	 @"bytesReceived = %d\n"
	 @"error = %d\n"
	 @"errorString = %@\n"
	 @"errorCode = %d\n",
	 self.url,
	 self.uniqueIdentifier,
	 self.name,
	 self.systemName,
	 self.systemVersion,
	 self.model,
	 self.localizedModel,
	 self.carrierName,
	 self.isoCountryCode,
	 self.mobileCountryCode,
	 self.mobileNetworkCode,
	 self.ipAddress,
	 self.connectionType,
	 self.initRequest,
	 self.didReceiveResponse,
	 self.didReceiveFirstData,
	 self.didFinishLoading,
	 self.bytesReceived,
	 self.error,
	 self.errorString,
	 self.errorCode];
	
}

- (void)dealloc {
    [super dealloc];
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

	[errorString release];
}

@end
