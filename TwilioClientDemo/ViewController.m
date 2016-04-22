//
//  ViewController.m
//  TwilioClientDemo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ControlSetUpManager.h"
#import <TwilioClient.h>
#import <AFHTTPSessionManager.h>
#import <Masonry.h>

#define WeakSelf(weakSelf) __weak typeof(self) weakSelf = self
#define LogFuncName NSLog(@"%s", __func__)

@interface ViewController ()

// 登录所需控件
@property (nonatomic, strong) UILabel *loginLabel;
@property (nonatomic, strong) UITextView *loginTextView;
@property (nonatomic, strong) UIButton *loginButton;

// 注销所需控件
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *logoutButton;

//拨打，挂断电话所需控件
@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) UITextView *phoneNumTextView;
@property (nonatomic, strong) UIButton *dialButton;
@property (nonatomic, strong) UIButton *hangUpButton;

//美化控件外观
@property (nonatomic, strong) ControlSetUpManager *setUpManager;

//轻拍手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

//button的响应事件
- (void)handleLoginButton:(UIButton *)sender;
- (void)handleLogoutButton:(UIButton *)sender;
- (void)handleDialButton:(UIButton *)sender;
- (void)handleHangUpButton:(UIButton *)sender;

//轻触的响应事件
- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap;

//调整布局
- (void)configMasonry;
@end

static CGFloat const kLabelWidth = 150.f;
static CGFloat const kLabelHeight = 40.f;
static CGFloat const kTextViewWidth = 280.f;
static CGFloat const kTextViewHeight = 40.f;
static CGFloat const kButtonWidth = 80.f;
static CGFloat const kButtonHeight = 40.f;
static CGFloat const kPadding = 20.f;


@implementation ViewController

#pragma mark --viewController的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.loginLabel];
    [self.view addSubview:self.loginTextView];
    [self.view addSubview:self.loginButton];
    self.loginButton.hidden = YES;
    self.loginLabel.hidden = YES;
    self.loginTextView.hidden = YES;
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.logoutButton];
    [self.view addSubview:self.phoneNumLabel];
    [self.view addSubview:self.phoneNumTextView];
    [self.view addSubview:self.dialButton];
    [self.view addSubview:self.hangUpButton];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self configMasonry];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --私有方法

/**
 *  使用Masonry调整约束
 */
- (void)configMasonry {
    
    WeakSelf(weakSelf);
    
    //登录所需控件
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kLabelWidth);
        make.height.mas_equalTo(kLabelHeight);
        make.bottom.mas_equalTo(weakSelf.loginTextView.mas_top).offset(- kPadding);
        make.centerX.mas_equalTo(weakSelf.view);
        
    }];
    
    [self.loginTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextViewWidth);
        make.height.mas_equalTo(kTextViewHeight);
        make.bottom.mas_equalTo(weakSelf.loginButton.mas_top).offset(- kPadding);
        make.centerX.mas_equalTo(weakSelf.view);
        
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY).offset(- kPadding);
    }];
    
    //注销所需控件
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kLabelWidth);
        make.height.mas_equalTo(kLabelHeight);
        make.top.mas_equalTo(weakSelf.view).offset(kPadding);
        make.left.mas_equalTo(weakSelf.view).offset(kPadding);
    }];
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
        make.top.mas_equalTo(weakSelf.view).offset(kPadding);
        make.right.mas_equalTo(weakSelf.view).offset(- kPadding);
    }];
    
    
    //拨号，挂断所需控件
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.width.mas_equalTo(kLabelWidth);
        make.height.mas_equalTo(kLabelHeight);
        make.centerY.mas_equalTo(weakSelf.view).offset(- kPadding * 5);
    }];
    
    [self.phoneNumTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.width.mas_equalTo(kTextViewWidth);
        make.height.mas_equalTo(kTextViewHeight);
        make.top.mas_equalTo(weakSelf.phoneNumLabel.mas_bottom).offset(kPadding);
    }];
    
    [self.dialButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
        make.centerX.mas_equalTo(weakSelf.view).offset(-kButtonWidth * 2 / 3);
        make.top.mas_equalTo(weakSelf.phoneNumTextView.mas_bottom).offset(kPadding);
    }];
    
    [self.hangUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
        make.centerX.mas_equalTo(weakSelf.view).offset(kButtonWidth * 2 / 3);
        make.top.mas_equalTo(weakSelf.phoneNumTextView.mas_bottom).offset(kPadding);
    }];
    
}

#pragma mark --重写父类方法



#pragma mark --响应事件

- (void)handleLoginButton:(UIButton *)sender {
    
}

- (void)handleLogoutButton:(UIButton *)sender {
    
}

- (void)handleDialButton:(UIButton *)sender {
    
}

- (void)handleHangUpButton:(UIButton *)sender {
    
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap{
    
    [self.view endEditing:YES];

}


#pragma mark --lazyLoading

//登录所需控件
- (UILabel *)loginLabel {
    
    if (_loginLabel) {
        
        return _loginLabel;
    }
    _loginLabel = [[UILabel alloc] init];
    [self.setUpManager control:_loginLabel setUpWithStrategy:ControlSetUpStrategyLabel];
    _loginLabel.text = @"请输入用户名:";
    _loginButton.hidden = YES;
    
    return _loginLabel;
}

- (UITextView *)loginTextView {
    
    if (_loginTextView) {
        
        return _loginTextView;
    }
    _loginTextView = [[UITextView alloc] init];
    [self.setUpManager control:_loginTextView setUpWithStrategy:ControlSetUpStrategyTextView];
    _loginTextView.hidden = YES;
    
    return _loginTextView;
}


- (UIButton *)loginButton {
    
    if (_loginButton) {
        
        return _loginButton;
    }
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginButton.backgroundColor = [UIColor redColor];
    [self.setUpManager control:_loginButton setUpWithStrategy:ControlSetUpStrategyButton];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(handleLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    _logoutButton.hidden = YES;
    
    return _loginButton;
}


//注销所需控件
- (UILabel *)userNameLabel {
    
    if (_userNameLabel) {
        
        return _userNameLabel;
    }
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.text = @"我的名字";
    [self.setUpManager control:_userNameLabel setUpWithStrategy:ControlSetUpStrategyLabel];
    
    return _userNameLabel;
}

- (UIButton *)logoutButton {
    
    if (_logoutButton) {
        
        return _logoutButton;
    }
    _logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _logoutButton.backgroundColor = [UIColor redColor];
    [self.setUpManager control:_logoutButton setUpWithStrategy:ControlSetUpStrategyButton];
    [_logoutButton setTitle:@"注销" forState:UIControlStateNormal];
    [_logoutButton addTarget:self action:@selector(handleLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _logoutButton;
}

//外拨，挂断所需控件
- (UILabel *)phoneNumLabel {
    
    if (_phoneNumLabel) {
        
        return _phoneNumLabel;
    }
    _phoneNumLabel = [[UILabel alloc] init];
    [self.setUpManager control:_phoneNumLabel setUpWithStrategy:ControlSetUpStrategyLabel];
    _phoneNumLabel.text = @"请输入手机号";
    
    return _phoneNumLabel;
}

- (UITextView *)phoneNumTextView {
    
    if (_phoneNumTextView) {
        
        return _phoneNumTextView;
    }
    _phoneNumTextView = [[UITextView alloc] init];
    [self.setUpManager control:_phoneNumTextView setUpWithStrategy:ControlSetUpStrategyTextView];
    return _phoneNumTextView;
}

- (UIButton *)dialButton {
    
    if (_dialButton) {
        
        return _dialButton;
    }
    _dialButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _dialButton.backgroundColor = [UIColor redColor];
    [self.setUpManager control:_dialButton setUpWithStrategy:ControlSetUpStrategyButton];
    [_dialButton setTitle:@"呼叫" forState:UIControlStateNormal];
    [_dialButton addTarget:self action:@selector(handleDialButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _dialButton;
}

- (UIButton *)hangUpButton {
    
    if (_hangUpButton) {
        
        return _hangUpButton;
    }
    _hangUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.setUpManager control:_hangUpButton setUpWithStrategy:ControlSetUpStrategyButton];
    _hangUpButton.backgroundColor = [UIColor greenColor];
    [_hangUpButton setTitle:@"挂断" forState:UIControlStateNormal];
    [_hangUpButton addTarget:self action:@selector(handleDialButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _hangUpButton;
}

//美化控件外观
- (ControlSetUpManager *)setUpManager {
    
    if (_setUpManager) {
        
        return _setUpManager;
    }
    _setUpManager = [[ControlSetUpManager alloc] init];
    
    return _setUpManager;
}

//轻拍手势
- (UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (_tapGestureRecognizer) {
        
        return _tapGestureRecognizer;
    }
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [_tapGestureRecognizer addTarget:self action:@selector(handleTapGestureRecognizer:)];
    return _tapGestureRecognizer;
}



@end
