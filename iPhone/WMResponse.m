//
//  WMResponse.m
//  App Performance Library
//
//  Created by Alasdair Allan on 06/12/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

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

@synthesize initRequest;
@synthesize didReceiveResponse;
@synthesize didReceiveFirstData;
@synthesize didFinishLoading;

@synthesize bytesReceived;

@synthesize error;
@synthesize errorString;
@synthesize errorCode;

- (id)init {

	if( self = [super init] ) {

		self.uniqueIdentifier = [UIDevice currentDevice].uniqueIdentifier;
		self.name = [UIDevice currentDevice].name;
		self.systemName  = [UIDevice currentDevice].systemName;
		self.systemVersion = [UIDevice currentDevice].systemVersion; 
		self.model = [UIDevice currentDevice].model;
		self.localizedModel = [UIDevice currentDevice].localizedModel;

		CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
		CTCarrier *carrier = [netInfo subscriberCellularProvider];

		self.carrierName = [carrier carrierName];
		self.isoCountryCode = [carrier isoCountryCode];
		self.mobileCountryCode = [carrier mobileCountryCode];
		self.mobileNetworkCode = [carrier mobileNetworkCode];

		self.ipAddress = [WMUtil getIPAddress];
	}
	return self;
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
