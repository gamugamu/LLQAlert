//
//  MSSimpleAlert.m
//  PTMobileStart
//
//  Created by kiabimobile on 20/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLQAlert.h"
#import "SynthesizeSingleton.h"

@interface LLQAlert()<UIAlertViewDelegate>{
	BOOL _isDisplaying;
}
@property(nonatomic, retain)NSMutableArray* queue;			// FIFO
@property(nonatomic, retain)NSMutableArray* delegateQueue;	// FIFO
@end

@implementation LLQAlert
@synthesize queue			= _queue,
			delegateQueue	= _delegateQueue;

#pragma mark ----------------------------------------------- public --------------------------------------------------------
#pragma mark ---------------------------------------------------------------------------------------------------------------

- (void)alert:(NSString*)message{
	[self alert: message withDelegate: nil];
}

- (void)alert:(NSString*)message withDelegate:(id<UIAlertViewDelegate>)delegate{
	[self qeue: message withDelegate: delegate];
	[self popQueue];
}

- (void)customAlert:(UIAlertView*)alert withDelegate:(id<UIAlertViewDelegate>)delegate{
	[self qeue: alert withDelegate: delegate];
	[self popQueue];
}

#pragma mark - Getter / Setter

- (UIAlertView*)currentAlert{
	return [_queue lastObject];
}

#pragma mark - syngleton Method

SYNTHESIZE_SINGLETON_FOR_CLASS(LLQAlert)

#pragma mark - alloc / dealloc

- (id)init{
	if(self = [super init]){
		self.queue		= [NSMutableArray arrayWithCapacity: 2];
		_delegateQueue	= [_queue mutableCopy];
	}
	return self;
}

#pragma mark ----------------------------------------------- private -------------------------------------------------------
#pragma mark ---------------------------------------------------------------------------------------------------------------

#pragma mark - UIAlertDelegate

// Note: only simple delegate callBack done. Will add them later
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	id<UIAlertViewDelegate> delegate = [_delegateQueue objectAtIndex: 0];
	
	if([delegate respondsToSelector: @selector(alertView:clickedButtonAtIndex:)])
		[delegate alertView: alertView clickedButtonAtIndex: buttonIndex];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	[_queue				removeObjectAtIndex: 0];
	[_delegateQueue		removeObjectAtIndex: 0];
	_isDisplaying = NO;
	[self popQueue];
}

#pragma mark - logic

- (void)qeue:(id)data withDelegate:(id<UIAlertViewDelegate>)delegate{
	[_queue			addObject: data];
	[_delegateQueue addObject: delegate? delegate : (id)[NSNull null]];
}

- (void)popQueue{
	if(!_isDisplaying && [_queue count]){
		id unqueued = [_queue objectAtIndex: 0];
		UIAlertView* alert;
		
		if([unqueued isKindOfClass: [NSString class]])
			alert	= [[[UIAlertView alloc] initWithTitle: nil
												message: [_queue objectAtIndex: 0]
											   delegate: self
									  cancelButtonTitle: @"ok" // need customisation
									  otherButtonTitles: nil] autorelease];
		
		else {
			alert				= unqueued;
			alert.delegate		= self;
		}
		
		[alert show];
		_isDisplaying = YES;
	}
}

@end