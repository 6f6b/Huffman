//
//  Result.h
//  Huffman
//
//  Created by 刘丰 on 2019/5/8.
//  Copyright © 2019 成都尚医信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Result : NSObject
@property (nonatomic,copy) NSString *bitString;
@property (nonatomic,copy) NSData *data;
@property (nonatomic,assign) int zeroCount;
@property (nonatomic,copy) NSString *originString;
@end

NS_ASSUME_NONNULL_END
