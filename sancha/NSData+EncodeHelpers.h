//
//  NSData+EncodeHelpers.h
//  sancha
//
//  Created by Keisuke_Tatsumi on 2016/02/19.
//  Copyright © 2016年 Keisuke Tatsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (EncodeHelpers)

- (NSString *) UTF8String;
- (NSData *) dataByHealingUTF8Stream;

@end
