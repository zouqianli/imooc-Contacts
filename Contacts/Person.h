//
//  Person.h
//  Contacts
//
//  Created by 邹前立 on 2017/5/18.
//  Copyright © 2017年 zouqianli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSSecureCoding>
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phoneNumber;
@end
