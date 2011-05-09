//
//  WMWebView.m
//  App Performance Library
//
//  Created by Alasdair Allan on 05/11/2010.
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


@implementation WMWebView

#pragma mark Accessor Wrappers

- (void)setDelegate:(id <WMWebViewDelegate>)delegate {
	[super setDelegate: self];
	[delegate retain];
	[_myDelegate release];
	_myDelegate = delegate;
}

#pragma mark -
#pragma mark Delegate Wrappers

- (BOOL)webView:(WMWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	BOOL returned = YES;
	
	analytics = [[WMResponse alloc] init];
	analytics.initRequest = CFAbsoluteTimeGetCurrent(); 
	analytics.url = request.URL;
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMWebView: webView:shouldStartLoadWithRequest: URL = %@", request.URL);
		NSLog(@"WMWebView: webView:shouldStartLoadWithRequest: initRequest at %f", analytics.initRequest);
	}
	
	if ( [_myDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
		returned = [_myDelegate webView:wv shouldStartLoadWithRequest:request navigationType:navigationType];
	}
	return returned;
	
}

- (void)webViewDidStartLoad:(WMWebView *)wv {
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMWebView: webViewDidStartLoad:");
	}
	
	analytics.didReceiveResponse = CFAbsoluteTimeGetCurrent(); 
	
	if( [_myDelegate respondsToSelector:@selector(webViewDidStartLoad:)] ) {
		[_myDelegate webViewDidStartLoad:wv];
	} 
}


- (void)webView:(WMWebView *)webView didFailLoadWithError:(NSError *)error {
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {		
		NSDictionary *userInfo = error.userInfo;
		NSArray *keys = userInfo.allKeys;
		NSArray *values = userInfo.allValues;		
		for( int i = 0; i < keys.count; i++ ) {
			NSLog( @"WMWebView: webView:didFailLoadWithError: %@: %@",
				  (NSString *) [keys objectAtIndex:i], (NSString *) [values objectAtIndex:i] );
		} 		
	}
	
	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	analytics.error = YES;
	analytics.errorCode = error.code;
	analytics.errorString = error.localizedDescription;
	
	if( [_myDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)] ) {
		[_myDelegate webView:webView didFailLoadWithError:error];
	}
	
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	if ( !singleton.libraryOff ) {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: webView:didFailLoadWithError: Adding response to queue" );
		}
		[singleton.queue addResponse:analytics];
	} else {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: webView:didFailLoadWithError: LIBRARY OFF - NO DISPATCH" );
		}
	}
	
}


- (void)webViewDidFinishLoad:(WMWebView *)wv {
    if (wv.loading)
		return;
	
	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	analytics.bytesReceived = [[wv stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"] length];
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMWebView: webViewDiDFinishLoad: didFinishLoading at %f", analytics.didFinishLoading);
		NSLog(@"WMWebView: webViewDiDFinishLoad: document.body.outerHTML length = %d", analytics.bytesReceived);
	}	
	if( [_myDelegate respondsToSelector:@selector(webViewDidStartLoad:)] ) {
		[_myDelegate webViewDidFinishLoad:wv];
	} 
	
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	if ( !singleton.libraryOff ) {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: webViewDiDFinishLoad: Adding response to queue" );
		}
		[singleton.queue addResponse:analytics];
	} else {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: webViewDiDFinishLoad: LIBRARY OFF - NO DISPATCH" );
		}
	}
}

@end
