//
//  HuffmanNode.h
//  Huffman
//
//  Created by liufeng on 2019/4/16.
//  Copyright © 2019 成都尚医信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuffmanNode : NSObject
///左孩子
@property (nonatomic,strong) HuffmanNode *left_node;
///右孩子
@property (nonatomic,strong) HuffmanNode *right_node;

@property (nonatomic,assign) int bitCode;

///ascll码
@property (nonatomic,assign) int ascll_code;

///频率
@property (nonatomic,assign) float frequency;

- (instancetype)initWith:(int)ascll_code;
@end

NS_ASSUME_NONNULL_END
