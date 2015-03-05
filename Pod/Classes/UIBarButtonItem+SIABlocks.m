//
//  UIBarButtonItem+SIABlocks.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2015/02/17.
//  Copyright (c) 2015 SI Agency Inc. All rights reserved.
//

#import "UIBarButtonItem+SIABlocks.h"
#import "SIABlockAction.h"

@implementation UIBarButtonItem (SIABlocks)

- (void)sia_addActionUsingBlock:(void(^) (UIBarButtonItem *item))block
{
    [self sia_removeAction];
    SIABlockAction *action = [self sia_actionForSelector:@selector(action:) types:"v0@0" usingBlock:block];
    self.target = action;
    self.action = action.selector;
    
}

- (void)sia_removeAction
{
    SIABlockAction *oldAction = self.target;
    if (oldAction) {
        self.target = nil;
        self.action = NULL;
        [self sia_disposeAction:oldAction];
    }
}

@end
