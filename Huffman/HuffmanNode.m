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
    }
    return self;
}

- (instancetype)initWith:(int)unicode{
    if (self = [super init]) {
        self.unicode = unicode;
    }
    return self;
}
@end

