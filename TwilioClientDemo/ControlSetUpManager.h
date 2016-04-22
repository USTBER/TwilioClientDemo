//
//  ControlSetUpManager.h
//  LCHTwilioClientDemo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ControlSetUpStrategyLabel,
    ControlSetUpStrategyTextView,
    ControlSetUpStrategyButton,
} ControlSetUpStrategy;

typedef void(^setUpBlock)(UIControl *control);

@interface ControlSetUpManager : NSObject

- (void)control:(UIControl *)control setUpWithStrategy:(ControlSetUpStrategy)strategy;

@end
