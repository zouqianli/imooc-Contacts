//
//  LoginViewController.m
//  Contacts
//
//  Created by 邹前立 on 2017/5/18.
//  Copyright © 2017年 zouqianli. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"

#define KeyLoginName    @"loginName"
#define KeyLoginPassword    @"loginPassword"
#define KeyLoginRemenberPassword    @"loginRemenberPassword"
#define KeyLoginAutoLogin   @"loginAutoLogin"

@interface LoginViewController () {
    
}
@property (weak, nonatomic) IBOutlet UITextField *loginName;

@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet UISwitch *rememberPassword;
@property (weak, nonatomic) IBOutlet UISwitch *autoLogin;
- (IBAction)loginAction;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)remenberPasswordAction:(UISwitch *)sender;
- (IBAction)autoLoginAction:(UISwitch *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:_loginName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:_loginPassword];
    // 读取偏好设置
    [self readUserDefaults];
    
    // 自动登录
    if (self.autoLogin.isOn) {
        // 在注销时启用loginButton
        self.loginButton.enabled = YES;
#pragma mark - 执行segue
        // 控制器跳转 数据传递
        [self performSegueWithIdentifier:@"login2Contacts" sender:nil];
    }
}
#pragma mark - 观察输入框变化
- (void) textFieldChange {
    if (self.loginName.text.length && self.loginPassword.text.length) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
//    self.loginButton.enabled = self.loginName.text.length && self.loginPassword.text.length;
}
#pragma mark - 偏好设置
#pragma mark -- 读取数据
- (void) readUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.loginName.text = [userDefaults valueForKey:KeyLoginName];
    self.loginPassword.text = [userDefaults valueForKey:KeyLoginPassword];
    self.rememberPassword.on = [userDefaults boolForKey:KeyLoginRemenberPassword];
    self.autoLogin.on = [userDefaults boolForKey:KeyLoginAutoLogin];

    // 记住密码 读取密码
    if (self.rememberPassword.isOn) {
        self.loginPassword.text = [userDefaults valueForKey:KeyLoginPassword];
    }
    // 自动登录
    if (self.autoLogin.isOn) {
        // 读取记住密码
        self.rememberPassword.on = YES;
        // 可以读取密码 若不读取，可以重新输入（强制重新输入）
//        self.loginPassword.text = [userDefaults valueForKey:KeyLoginPassword];
    }
    NSLog(@"readLoginData:--------%@,%@,%d,%d",self.loginName.text,self.loginPassword.text,self.rememberPassword.isOn,self.autoLogin.isOn);
}
#pragma mark -- 写入数据 同步
- (void) writeUserDefaults {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:self.loginName.text forKey:KeyLoginName];
    [userdefaults setObject:self.loginPassword.text forKey:KeyLoginPassword];
    [userdefaults setBool:self.rememberPassword.isOn forKey:KeyLoginRemenberPassword];
    [userdefaults setBool:self.autoLogin.isOn forKey:KeyLoginAutoLogin];
    // 同步
    [userdefaults synchronize];
    NSLog(@"saveLoginData:--------%@,%@,%d,%d",self.loginName.text,self.loginPassword.text,self.rememberPassword.isOn,self.autoLogin.isOn);
}
#pragma mark - Navigation 导航控制器页面跳转 数据传递

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *contactsVC = [segue destinationViewController];
    contactsVC.title = [NSString stringWithFormat:@"%@联系人列表",self.loginName.text];
}
#pragma mark - 获得键盘焦点
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.loginName becomeFirstResponder]; // 获得键盘焦点
}
#pragma mark - button Action
#pragma mark -- 登录
- (IBAction)loginAction {
    if (![self.loginName.text isEqualToString:@"imooc"]) {
        [MBProgressHUD showError:@"用户名或密码错误"];
        return;
    }
    if (![self.loginPassword.text isEqualToString:@"123"]) {
        [MBProgressHUD showError:@"用户名或密码错误"];
        return;
    }
    // 保存登录信息
    [self writeUserDefaults];
    
    [MBProgressHUD showMessage:@"正在登录..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
#pragma mark - 执行segue
    // 控制器跳转 数据传递
    [self performSegueWithIdentifier:@"login2Contacts" sender:nil];
}
#pragma mark -- 没有记住密码 取消自动登录
- (IBAction)remenberPasswordAction:(UISwitch *)sender {
    if (!self.rememberPassword.isOn) {
        self.autoLogin.on = NO;
        // 清除密码输入框
        self.loginPassword.text = @"";
    }
    [self writeUserDefaults];
}
#pragma mark -- 自动登录 记住密码
- (IBAction)autoLoginAction:(UISwitch *)sender {
    if (self.autoLogin.isOn) {
        self.rememberPassword.on = YES;
    }
    [self writeUserDefaults];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
