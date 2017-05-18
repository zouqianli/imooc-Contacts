//
//  AddViewController.m
//  Contacts
//
//  Created by 邹前立 on 2017/5/18.
//  Copyright © 2017年 zouqianli. All rights reserved.
//

#import "AddViewController.h"
#import "Person.h"

@interface AddViewController () {
    
}
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *addName;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *addPhoneNumber;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)addAction;
- (IBAction)goBack:(UIBarButtonItem *)sender;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:_addName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:self.addPhoneNumber];
    
    
}
- (void) textFieldChange {
//    if (self.addName.text.length && self.addPhoneNumber.text.length) {
//        self.addButton.enabled = YES;
//    } else {
//        self.addButton.enabled = NO;
//    }
      self.addButton.enabled = self.addName.text.length && self.addPhoneNumber.text.length;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.addName becomeFirstResponder]; // 获得键盘焦点
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addAction {
    if ([self.delegate respondsToSelector:@selector(addContact:didAddContact:)]) {
        Person *person = [[Person alloc] init];
        person.name = self.addName.text;
        person.phoneNumber = self.addPhoneNumber.text;
        [self.delegate addContact:self didAddContact:person];// 代理传值
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
