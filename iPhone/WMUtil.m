//
//  WMUtil.m
//  App Performance Library
//
//  Created by Alasdair Allan on 06/12/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "WMPerfLib.h"


@implementation WMUtil

// From: http://www.cocoadev.com/index.pl?BaseSixtyFour
+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

+(NSString *)getIPAddress {
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				
				if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
					NSLog(@"WMUtil: getIPAddress: ifa_name = %@", [NSString stringWithUTF8String:temp_addr->ifa_name] );
				}
				
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] ||
				   [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"] )
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
						NSLog(@"WMUtil: getIPAddress: IP (via WiFi) = %@", address );
					}	
					break;
				} else if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
						NSLog(@"WMUtil: getIPAddress: IP (via WWAN) = %@", address );
					}
					break;
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}


+(NSString *)connectionType {
	NSString *type = @"error";
	
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
		
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddress);
	SCNetworkReachabilityFlags flags;
		
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
		
	if (!didRetrieveFlags) {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMUtil: connectionType: Could not recover network reachability flags");
		}
		return type;
	}
	
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMUtil: connectionType: %c%c %c%c%c%c%c%c%c\n",
		  (flags & kSCNetworkReachabilityFlagsIsWWAN)				? 'W' : '-',
		  (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
		  (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
		  (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
		  (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
		  (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
		  (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
		  (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
		  (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'
		  );
	}
	
	BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
	BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
	BOOL isWWAN = (( flags & kSCNetworkReachabilityFlagsIsWWAN ) != 0);
	
	if( isReachable && isWWAN && !needsConnection ) {
		type = @"wwan";
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog( @"WMUtil: connectionType: Reachable via WWAN" );
		}
	} else if ( isReachable && !needsConnection ) {
		type = @"wifi";
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog( @"WMUtil: connectionType: Reachable via WiFi" );
		}
	} else if ( needsConnection ) {
		type = @"other";
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog( @"WMUtil: connectionType: Needs connection" );
		}
	}
	
	return type;
}

+(NSString *)stringFromDate:(NSDate *)theDate {
    
	// Returns ISO8601 formatted string for a passed NSDate
	static NSDateFormatter* formatter = nil;
	
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
		
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        int offset = [timeZone secondsFromGMT];
		
        NSMutableString *strFormat = [NSMutableString stringWithString:@"yyyy-MM-dd'T'HH:mm:ss"];
        offset /= 60; //bring down to minutes
        if (offset == 0)
            [strFormat appendString:ISO_TIMEZONE_UTC_FORMAT];
        else
            [strFormat appendFormat:ISO_TIMEZONE_OFFSET_FORMAT, offset / 60, offset % 60];
		
        [formatter setTimeStyle:NSDateFormatterFullStyle];
        [formatter setDateFormat:strFormat];
    }
    return[formatter stringFromDate:theDate];
}

+(NSDate *)dateFromString:(NSString *)theString {
    static NSDateFormatter* sISO8601 = nil;

	// Turn ISO8601 formatted string into an NSDate
	
    if (!sISO8601) {
        sISO8601 = [[NSDateFormatter alloc] init];
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    if ([theString hasSuffix:@"Z"]) {
        theString = [theString substringToIndex:(theString.length-1)];
    }
	
    NSDate *d = [sISO8601 dateFromString:theString];
    return d;
	
}


@end
