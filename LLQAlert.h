//
//  LLQAlert.h
//  Created by Loïc abadie on 20/02/12.
//

#import <Foundation/Foundation.h>

/* Throw alerts in queue. Alerts are never over-popped by another alerts. FIFO orders */
// TODO: block support - delegate full implementation - custom alert.

@interface LLQAlert : NSObject

/// Singleton instance
+ (LLQAlert*)sharedLLQAlert;

/// Send a basic alert text. No title, "ok" button default.
- (void)alert:(NSString*)message;

/// Same as alert: but you have a basic delegate callback when alert is dismissed.
- (void)alert:(NSString*)message withDelegate:(id<UIAlertViewDelegate>)delegate;

/// Use your own NSAlert for custom implementation.
- (void)customAlert:(UIAlertView*)alert withDelegate:(id<UIAlertViewDelegate>)delegate;

/// Current displayed alert.
- (UIAlertView*)currentAlert;

@end