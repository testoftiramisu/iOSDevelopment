//
//  ErrorHandler.m
//  Empty Application
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

+ (void)handleError:(NSError *)error fatal:(BOOL)fatalError
{
    NSString *localizedCancelTitle = NSLocalizedString(@"Dismiss", nil);
    
    if (fatalError) {
        localizedCancelTitle = NSLocalizedString(@"Shut Down", nil);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                    message:[error localizedFailureReason]
                                                   delegate:nil
                                          cancelButtonTitle:localizedCancelTitle
                                          otherButtonTitles:nil];
    [alert show];
    // Log to standart out
    NSLog(@"Unhandled error:\n%@, %@", error, [error userInfo]);
}

@end
