//
//  ControlSetUpManager.m
//  LCHTwilioClientDemo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ControlSetUpManager.h"

@interface ControlSetUpManager ()

@property (nonatomic, strong) NSArray *strategyList;
@property (nonatomic, strong) UIControl *control;

@end

@implementation ControlSetUpManager

- (void)control:(UIControl *)control setUpWithStrategy:(ControlSetUpStrategy)strategy{
    
    
}

- (NSArray *)strategyList{
    
    if(_strategyList){
        return _strategyList;
    }
    setUpBlock setUpBlockForLabel = ^(UIControl *control){
        
        UILabel *label = (UILabel *)control;
    };
    return _strategyList;
}

@end
