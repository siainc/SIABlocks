//
//  SIAExpandableObject.m
//  SIATools
//
//  Created by KUROSAKI Ryota on 2013/01/10.
//  Copyright (c) 2013-2014 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "SIAExpandableObject.h"

#import <objc/runtime.h>

@implementation SIAExpandableObject

#pragma mark - create subclass

+ (Class)registerSubclass
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);

    NSString *subclassName = [NSString stringWithFormat:@"%@/%@", NSStringFromClass(self), uuidString];
    Class subclass = objc_allocateClassPair(self, subclassName.UTF8String, 0);
    objc_registerClassPair(subclass);
    return subclass;
}

+ (SIAExpandableObject *)createSubclassInstance
{
    Class subclass = [self registerSubclass];
    id object = [[subclass alloc] init];
    return object;
}

#pragma mark - dispose class

- (void)dealloc
{
    Class class = self.class;
    if (class != [SIAExpandableObject class]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            objc_disposeClassPair(class);
        });
        
        unsigned int count = 0;
        Method *methodList = class_copyMethodList(self.class, &count);
        for (unsigned int i = 0; i < count; i++) {
            Method method = methodList[i];
            IMP imp = method_getImplementation(method);
            imp_removeBlock(imp);
        }
        free(methodList);
    }
}

#pragma mark - add class methods

+ (void)addMethodWithSelector:(SEL)selector types:(const char *)types block:(id)block
{
    IMP oldImp = class_getMethodImplementation(objc_getMetaClass(class_getName(self)), selector);
    if (oldImp != NULL) {
        imp_removeBlock(oldImp);
    }

    IMP imp = imp_implementationWithBlock(block);
    class_addMethod(objc_getMetaClass(class_getName(self)), selector, imp, types);
}

#pragma mark - add instance methods

- (void)addMethodWithSelector:(SEL)selector types:(const char *)types block:(id)block
{
    IMP oldImp = class_getMethodImplementation(self.class, selector);
    if (oldImp != NULL) {
        imp_removeBlock(oldImp);
    }
    
    IMP imp = imp_implementationWithBlock(block);
    class_addMethod(self.class, selector, imp, types);
}

@end
