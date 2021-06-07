//
//  NSObject+Swizzling.h
//  iSport
//
//  Created by aidong on 2020/5/13.
//  Copyright © 2020 me.aidong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;
  
@end
