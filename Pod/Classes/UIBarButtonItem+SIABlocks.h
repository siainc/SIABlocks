//
//  UIBarButtonItem+SIABlocks.h
//  SIATools
//
//  Created by KUROSAKI Ryota on 2015/02/17.
//  Copyright (c) 2015 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIBarButtonItem (SIABlocks)

- (void)sia_addActionUsingBlock:(void(^) (UIBarButtonItem *item))block;
- (void)sia_removeAction;

@end
