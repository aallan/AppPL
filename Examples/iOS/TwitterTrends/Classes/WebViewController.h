//
//  WebViewController.h
//  BrowserExample
//
//  Created by Alasdair Allan on 27/08/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <WMWebViewDelegate, UIAlertViewDelegate> {
	NSURL *theURL;
	NSString *theTitle;
	IBOutlet WMWebView *webView;
	IBOutlet UINavigationItem *webTitle;
		
}

- (id)initWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url andTitle:(NSString *)string;
- (IBAction) done:(id)sender;

@end
