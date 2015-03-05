//
//  SIABlockAction.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/03/08.
//  Copyright (c) 2013-2015 SI Agency Inc. All rights reserved.
//

#import "SIABlockAction.h"
#import <objc/runtime.h>

#define SIABlockActionListKey "SIABlockActionListKey"

@implementation SIABlockAction

+ (SIABlockAction *)createSubclassInstanceForSelector:(SEL)selector
{
    SIABlockAction *action = [SIABlockAction createSubclassInstance];
    action.selector = selector;
    return action;
}

- (void)addMethodWithTypes:(const char *)types block:(id)block
{
    [self addMethodWithSelector:self.selector types:types block:block];
}

@end

@implementation NSObject (SIABlockAction)

- (NSMutableArray *)sia_blockActions
{
    NSMutableArray *actions = nil;
    @synchronized(self) {
        actions = objc_getAssociatedObject(self, SIABlockActionListKey);
        if (actions == nil) {
            actions = @[].mutableCopy;
            objc_setAssociatedObject(self, SIABlockActionListKey, actions, OBJC_ASSOCIATION_RETAIN);
        }
    }
    return actions;
}

- (SIABlockAction *)sia_actionForSelector:(SEL)selector types:(const char *)types usingBlock:(id)block
{
    SIABlockAction *action = [SIABlockAction createSubclassInstanceForSelector:selector];
    [action addMethodWithTypes:types block:block];
    [[self sia_blockActions] addObject:action];
    return action;
}

- (void)sia_disposeAction:(SIABlockAction *)action
{
    [[self sia_blockActions] removeObject:action];
}

@end
