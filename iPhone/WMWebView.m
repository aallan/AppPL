//
//  WMWebView.m
//  App Performance Library
//
//  Created by Alasdair Allan on 05/11/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

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

- (void)webViewDidStartLoad:(WMWebView *)wv {
	NSLog(@"Black magic starts");
	
	if( [_myDelegate respondsToSelector:@selector(webViewDidStartLoad:)] ) {
		[_myDelegate webViewDidStartLoad:wv];
	} 
}


- (void)webViewDidFinishLoad:(WMWebView *)wv {
    if (wv.loading)
		return;

	NSLog(@"Black magic ends");
	if( [_myDelegate respondsToSelector:@selector(webViewDidStartLoad:)] ) {
		[_myDelegate webViewDidFinishLoad:wv];
	} 
}


- (BOOL)webView:(WMWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	NSLog(@"Black magic happening");
	BOOL returned = YES;
	if ( [_myDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
		returned = [_myDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
	}
	return returned;

}

- (void)webView:(WMWebView *)webView didFailLoadWithError:(NSError *)error {
	
	NSLog(@"Black magic happened by an error occured");
	if( [_myDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)] ) {
		[_myDelegate webView:webView didFailLoadWithError:error];
	}
}

@end
