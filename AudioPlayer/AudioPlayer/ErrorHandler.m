//
//  ErrorHandler.m
//  Empty Application
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

static NSMutableArray *retainedDelegates;

- (id)initWithError:(NSError *)error fatal:(BOOL)fatalError
{
    self = [super init];
    if (self) {
        self.error = error;
        self.fatalError = fatalError;
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.fatalError) {
        // In case of fatal error abort execution
        abort();
    }
    // Job is finished
    [retainedDelegates removeObject:self];
}

+ (void)handleError:(NSError *)error fatal:(BOOL)fatalError
{
    NSString *localizedCancelTitle = NSLocalizedString(@"Dismiss", nil);
    
    if (fatalError) {
        localizedCancelTitle = NSLocalizedString(@"Shut Down", nil);
    }
    
    // Notify the user
    ErrorHandler *delegate = [[ErrorHandler alloc] initWithError:error fatal:fatalError];
    if (!retainedDelegates) {
        retainedDelegates = [[NSMutableArray alloc] init];
    }
    
    [retainedDelegates addObject:delegate];

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                    message:[error localizedFailureReason]
                                                   delegate:delegate
                                          cancelButtonTitle:localizedCancelTitle
                                          otherButtonTitles:nil];
    [alert show];
    // Log to standart out
    NSLog(@"Unhandled error:\n%@, %@", error, [error userInfo]);
}

@end
