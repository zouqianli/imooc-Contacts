//
//  AddViewController.h
//  Contacts
//
//  Created by 邹前立 on 2017/5/18.
//  Copyright © 2017年 zouqianli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddViewController,Person;
@protocol AddViewControllerDelegate <NSObject>

@optional
// 代理方法
- (void) addContact:(AddViewController *)addViewController didAddContact:(Person *)contact;

@end

@interface AddViewController : UIViewController


@property (nonatomic,assign) id<AddViewControllerDelegate> delegate; // 代理

@end
