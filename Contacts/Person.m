//
//  Person.m
//  Contacts
//
//  Created by 邹前立 on 2017/5/18.
//  Copyright © 2017年 zouqianli. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
    }
    return self;
}
+ (BOOL)supportsSecureCoding {
    return YES;
}
@end
