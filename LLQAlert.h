//
//  MSSimpleAlert.h
//  PTMobileStart
//
//  Created by kiabimobile on 20/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Cette classe permet de lancer une alerte tout simple, sans callBack. Utiliser MSSimpleAlert pour lancer rapidement des alertes.
// MSSimpleAlert se charge aussi de ne lancer les alertes qu'en pile. Une alerte à la fois.
@interface LLQAlert : NSObject
+ (LLQAlert*)sharedLLQAlert;
- (void)addAlertMessageFromQueue:(NSString*)message;
- (void)addAlertMessageFromQueue:(NSString*)message withDelegate:(id<UIAlertViewDelegate>)delegate;
- (void)addAlertFromQueue:(UIAlertView*)alert withDelegate:(id<UIAlertViewDelegate>)delegate;
- (UIAlertView*)currentAlert;
@end
