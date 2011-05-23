//
//  WebTestViewController.h
//  WebTest
//
//  Created by Alasdair Allan on 23/05/2011.
//  Copyright 2011 University of Exeter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebTestViewController : UIViewController {
    
    UITextView *logWindow;
    
    UIButton *pushedButton;
}

@property (retain, nonatomic) IBOutlet UITextView *logWindow;

-(void)setScrollToVisible;
- (IBAction)pushedButton:(id)sender;

@end
