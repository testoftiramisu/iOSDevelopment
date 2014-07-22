//
//  ErrorHandler.h
//  Default Error Handling
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorHandler : NSObject

+ (void)handleError:(NSError *) error fatal:(BOOL)fatalError;

@end
