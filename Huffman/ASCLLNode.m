//
//  ASCLLNode.m
//  Huffman
//
//  Created by liufeng on 2019/4/16.
//  Copyright © 2019 成都尚医信息技术有限公司. All rights reserved.
//

#import "ASCLLNode.h"

@implementation ASCLLNode
- (instancetype)initWith:(int)ascll_code{
    if (self = [super init]) {
        self.ascll_code = ascll_code;
    }
    return self;
}
@end
