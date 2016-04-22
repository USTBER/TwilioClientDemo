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

- (void)control:(UIView *)control setUpWithStrategy:(ControlSetUpStrategy)strategy{
    
    SetUpBlock block = self.strategyList[strategy];
    block(control);
}

- (NSArray *)strategyList{
    
    if(_strategyList){
        
        return _strategyList;
    }
    SetUpBlock setUpBlockForLabel = ^(UIView *control){
        UILabel *label = (UILabel *)control;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor yellowColor];
        label.layer.borderWidth = 2.f;
        label.layer.cornerRadius = 8.f;
        label.layer.masksToBounds = YES;

        label.font = [UIFont systemFontOfSize:20];
    };
    
    SetUpBlock setUpBlockForTextView = ^(UIView *control){
        UITextView *textView = (UITextView *)control;
        textView.textAlignment = NSTextAlignmentCenter;
        textView.font = [UIFont systemFontOfSize:20];
        textView.layer.borderWidth = 2.f;
        textView.layer.cornerRadius = 8.f;
        textView.layer.masksToBounds = YES;
    };
    
    SetUpBlock setUpBlockForButton = ^(UIView *control){
        UIButton *button = (UIButton *)control;
        button.layer.cornerRadius = 5.f;
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        button.layer.masksToBounds = YES;
    };
    _strategyList = @[setUpBlockForLabel, setUpBlockForTextView, setUpBlockForButton];
    
    return _strategyList;
}

@end
