//
//  HuffmanNode.m
//  Huffman
//
//  Created by liufeng on 2019/4/16.
//  Copyright © 2019 成都尚医信息技术有限公司. All rights reserved.
//

#import "HuffmanNode.h"

@implementation HuffmanNode
- (instancetype)init{
    if (self = [super init]) {
        self.ascll_code = 10000;
    }
    return self;
}

- (instancetype)initWith:(int)ascll_code{
    if (self = [super init]) {
        self.ascll_code = ascll_code;
    }
    return self;
}
@end

