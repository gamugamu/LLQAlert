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
- (void)popQueue;
- (void)addDataInQueue:(id)data withDelegate:(id<UIAlertViewDelegate>)delegate;
@end

@implementation LLQAlert
@synthesize queue			= _queue,
			delegateQueue	= _delegateQueue;

- (void)addAlertMessageFromQueue:(NSString*)message{
	[self addAlertMessageFromQueue: message withDelegate: nil];
}

- (void)addAlertMessageFromQueue:(NSString*)message withDelegate:(id<UIAlertViewDelegate>)delegate{
	[self addDataInQueue: message withDelegate: delegate];
	[self popQueue];
}

- (void)addAlertFromQueue:(UIAlertView*)alert withDelegate:(id<UIAlertViewDelegate>)delegate{
	[self addDataInQueue: alert withDelegate: delegate];
	[self popQueue];
}

#pragma mark - getter setter

- (UIAlertView*)currentAlert{
	return [_queue lastObject];
}

#pragma mark - UIAlertDelegate

// note, only simple callBack done

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

- (void)addDataInQueue:(id)data withDelegate:(id<UIAlertViewDelegate>)delegate{
	[_queue			addObject: data];
	[_delegateQueue addObject: delegate? delegate : (id)[NSNull null]];
}

- (void)popQueue{
	if(!_isDisplaying && [_queue count]){
		id unqueued = [_queue objectAtIndex: 0];
		UIAlertView* alert;
		
		if([unqueued isKindOfClass: [NSString class]]){
			alert	= [[[UIAlertView alloc] initWithTitle:nil message: [_queue objectAtIndex: 0] delegate: self cancelButtonTitle: @"ok" otherButtonTitles: nil] autorelease];
		}
		else {
			alert				= unqueued;
			alert.delegate		= self;
		}
		
		[alert show];
		_isDisplaying = YES;
	}
}

@end