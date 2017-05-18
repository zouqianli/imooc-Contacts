//
//  EditViewController.m
//  Contacts
//
//  Created by 邹前立 on 2017/5/18.
//  Copyright © 2017年 zouqianli. All rights reserved.
//

#import "EditViewController.h"
#import "Person.h"

@interface EditViewController () {
    
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)saveButtonAction:(UIButton *)sender;
- (IBAction)editButtonAction:(UIBarButtonItem *)sender;
- (IBAction)goBack:(UIBarButtonItem *)sender;


@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取要编辑的数据 填入输入框
    self.name.text = self.person.name;
    self.phoneNumber.text = self.person.phoneNumber;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:self.name];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:self.phoneNumber];
    
}
#pragma mark - 观察输入框变化
- (void) textFieldChange {
    // 编辑
    if (self.name.text.length && self.phoneNumber.text.length) {
        self.saveButton.enabled = YES;
        self.saveButton.hidden = NO;
        self.editButton.title = @"取消";
        
    } else { // 取消（编辑）
        self.saveButton.enabled = NO;
        self.saveButton.hidden = YES;
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 此时输入框已禁用
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self.name becomeFirstResponder]; // 获得键盘焦点
//}
- (IBAction)saveButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(editViewController:didSaveContact:)]) {
        self.person.name = self.name.text;
        self.person.phoneNumber = self.phoneNumber.text;
        // 传递模型数据
        [self.delegate editViewController:self didSaveContact:self.person];
    }
}

- (IBAction)editButtonAction:(UIBarButtonItem *)sender {
    // 1.输入框禁用，根据输入框状态 转换
    // 2.根据sender的title 转换
//    if (self.name.enabled) { // 取消
    if ([sender.title isEqualToString:@"取消"]) {
        self.name.enabled = NO;
        self.phoneNumber.enabled = NO;
        [self.view endEditing:YES];
        self.saveButton.hidden = YES;
        sender.title = @"编辑"; // 点击sender（取消）后变为”编辑“
        // 还原数据
        self.name.text = self.person.name;
        self.phoneNumber.text = self.person.phoneNumber;
    }else { // 编辑
        [self.name becomeFirstResponder]; // 获得键盘焦点
        self.name.enabled = YES;
        self.phoneNumber.enabled = YES;
        [self.view endEditing:NO];
        self.saveButton.hidden = NO;
        sender.title = @"取消"; // 点击sender（编辑）后变为”取消“
    }
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
