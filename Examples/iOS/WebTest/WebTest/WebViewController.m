//
//  WebViewController.m
//  BrowserExample
//
//  Created by Alasdair Allan on 27/08/2009.
//  Copyright (c) 2009, Babilim Light Industries. All rights reserved.
//  This code is released under the Modified BSD license.
//  
//  Redistribution and use in source and binary forms, with or without 
//  modification,  are permitted provided that the following conditions are met:
//  
//  Redistributions of source code must retain the above copyright notice, this 
//  list  of conditions and the following disclaimer. Redistributions in binary 
//  form must reproduce the above copyright notice, this list of conditions and 
//  the following disclaimer in the documentation and/or other materials provided
//  with the distribution.
//  
//  Neither the name of the Babilim Light Industries nor the names of its
//  contributors may be used to endorse or promote products derived from this
//  software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "WebViewController.h"


@implementation WebViewController

#pragma mark init Methods


-(id)initWithURL:(NSURL *)url {
	return [self initWithURL:url andTitle:nil]; 
	
}

- (id)initWithURL:(NSURL *)url andTitle:(NSString *)string {
	if( (self = [super init]) ) {
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
