//
//  CodingNode.h
//  Huffman
//
//  Created by liufeng on 2019/4/16.
//  Copyright © 2019 成都尚医信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CodingNode : NSObject
///ascll码
@property (nonatomic,assign) int unicode;

///huffman编码
@property (nonatomic,readonly) NSString * huffmanCode;

- (void)setHuffCode:(NSString *)huffCode;
@end

NS_ASSUME_NONNULL_END
