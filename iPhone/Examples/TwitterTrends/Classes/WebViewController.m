//
//  WebViewController.m
//  BrowserExample
//
//  Created by Alasdair Allan on 27/08/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

#pragma mark init Methods


-(id)initWithURL:(NSURL *)url {
	return [self initWithURL:url andTitle:nil]; 
	
}

- (id)initWithURL:(NSURL *)url andTitle:(NSString *)string {
	if( self = [super init] ) {
		theURL = url;
		theTitle = string;
	}
	return self;
	
}

#pragma mark UIViewController Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidLoad {
	[super viewDidLoad];
	webTitle.title = theTitle;
	
	NSURLRequest *requestObject = [NSURLRequest requestWithURL:theURL];
	[webView loadRequest:requestObject];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	webView.delegate = nil;
	[webView stopLoading];
}

- (void)viewDidUnload {

}


- (void)dealloc {
	[webView release];
	[webTitle release];
    [super dealloc];

}

#pragma mark Instance Methods

- (IBAction) done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark WMWebViewDelegate Methods

- (void)webViewDidStartLoad:(WMWebView *)wv {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

- (void)webViewDidFinishLoad:(WMWebView *)wv {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

- (void)webView:(WMWebView *)wv didFailLoadWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSString *errorString = [error localizedDescription];
	NSString *errorTitle = [NSString stringWithFormat:@"Error (%d)", error.code];
	
	UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:errorTitle message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[errorView show];
	[errorView autorelease];
}

#pragma mark UIAlertViewDelegate Methods

- (void)didPresentAlertView:(UIAlertView *)alertView {
	[self dismissModalViewControllerAnimated:YES];	
	
}



@end
