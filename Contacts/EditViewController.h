//
//  EditViewController.h
//  Contacts
//
//  Created by 邹前立 on 2017/5/18.
//  Copyright © 2017年 zouqianli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Person,EditViewController;
@protocol EditViewControllerDelegate <NSObject>

@optional
- (void) editViewController:(EditViewController*)editViewController didSaveContact:(Person *) contact;

@end

@interface EditViewController : UIViewController

@property (nonatomic,strong) Person *person; // 编辑模型
@property (nonatomic,assign) id<EditViewControllerDelegate> delegate; // 代理
@end
