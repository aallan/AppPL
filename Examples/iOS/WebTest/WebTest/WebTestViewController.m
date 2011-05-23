//
//  WebTestViewController.m
//  WebTest
//
//  Created by Alasdair Allan on 23/05/2011.
//  Copyright 2011 University of Exeter. All rights reserved.
//

#import "WebTestViewController.h"
#import "WebViewController.h"

@implementation WebTestViewController

@synthesize logWindow;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)awakeFromNib
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *log = [[paths objectAtIndex:0] stringByAppendingPathComponent: @"ns.log"];	
	NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:log];
    
	//Read the existing logs, I opted not to do this.
	//[logWindowTextField readRTFDFromFile:logPath];
	
	//Seek to end of file so that logs from previous application launch are not visible
	[fh seekToEndOfFile];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getData:)
                                                 name:@"NSFileHandleReadCompletionNotification"
                                               object:fh];
	[fh readInBackgroundAndNotify];
}
- (void) getData: (NSNotification *)aNotification
{
    NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    // If the length of the data is zero, then the task is basically over - there is nothing
    // more to get from the handle so we may as well shut down.
    if ([data length])
    {
        // Send the data on to the controller; we can't just use +stringWithUTF8String: here
        // because -[data bytes] is not necessarily a properly terminated string.
        // -initWithData:encoding: on the other hand checks -[data length]
        NSString *aString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		
		logWindow.editable = TRUE;
		logWindow.text = [logWindow.text stringByAppendingString: aString];
		logWindow.editable = FALSE;
        
		//Scroll to the last line
		[self setScrollToVisible];
        
		// we need to schedule the file handle go read more data in the background again.
		[[aNotification object] readInBackgroundAndNotify];
    }
	else
	{
		//I use a delay to minimize CPU usage when the file has not changed.
		[self performSelector:@selector(refreshLog:) withObject:aNotification afterDelay:1.0];
	}
}
- (void) refreshLog: (NSNotification *)aNotification
{
	[[aNotification object] readInBackgroundAndNotify];
}
-(void)setScrollToVisible;
{
	NSRange txtOutputRange;
	txtOutputRange.location = [[logWindow text] length];
	txtOutputRange.length = 0;
    logWindow.editable = TRUE;
	[logWindow scrollRangeToVisible:txtOutputRange];
	[logWindow setSelectedRange:txtOutputRange];
    logWindow.editable = FALSE;
}

- (IBAction)pushedButton:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
    WebViewController *webViewController = [[WebViewController alloc] initWithURL:url andTitle:@"Google"];
    [self presentModalViewController:webViewController animated:YES];
    [webViewController release];
}


@end
