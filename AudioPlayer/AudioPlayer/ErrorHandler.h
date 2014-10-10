//
//  ErrorHandler.h
//  Default Error Handling
//  Empty Application
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorHandler : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic)NSError *error;
@property (nonatomic)BOOL fatalError;

- (id)initWithError:(NSError *)error fatal:(BOOL)fatalError;
+ (void)handleError:(NSError *) error fatal:(BOOL)fatalError;

@end
