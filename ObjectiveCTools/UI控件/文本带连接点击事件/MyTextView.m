//
//  MyTextView.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2020/6/5.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView

/// 重写手势响应的方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (@available(iOS 11.0, *)) {
        
        //我们把需要的手势启用
        //其实我们只需要这个单选
        if ([gestureRecognizer.name isEqualToString:@"UITextInteractionNameSingleTap"]) {
            return YES;
        }
        //我们也需要这个链接点选
        if ([gestureRecognizer.name isEqualToString:@"UITextInteractionNameLinkTap"]) {
            return YES; //如果这里写成 NO, 那么在点击 TextView 上面自定义链接的时候, 就会失效
        }
        
        
        //我们把不需要的手势都禁用掉
        //禁用双击
        if ([gestureRecognizer.name isEqualToString:@"UITextInteractionNameDoubleTap"]) {
            return NO;
        }
        //禁用先点按之后长按
        if ([gestureRecognizer.name isEqualToString:@"UITextInteractionNameTapAndAHalf"]) {
            return NO;
        }
        //禁用长按 1
        if ([gestureRecognizer.name isEqualToString:@"_UIKeyboardTextSelectionGestureForcePress"]) {
            return NO;
        }
        //禁用长按 2
        if ([gestureRecognizer.name isEqualToString:@"UITextInteractionNameInteractiveLoupe"]) {
            return NO;
        }
        
    } else {
        // Fallback on earlier versions
    }
    return YES;
}


/// 注: 在 我重写了 gestureRecognizerShouldBegin: 方法后, 下面这个方法也可以不写, 因为手势被先禁用掉了, 所以响应事件就不会触发
/// 禁用掉 选择 多选 复制 剪切 粘贴 等各种东西
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 返回NO为禁用，YES为开启
    // 粘贴
    if (action == @selector(paste:)) {
        return NO;
    }
    // 剪切
    if (action == @selector(cut:)) {
        return NO;
    }
    // 复制
    if (action == @selector(copy:)) {
        return NO;
    }
    // 选择
    if (action == @selector(select:)) {
        return NO;
    }
    // 选中全部
    if (action == @selector(selectAll:)) {
        return NO;
    }
    // 删除
    if (action == @selector(delete:)) {
        return NO;
    }
    // 分享
    if (action == @selector(share)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}


@end

