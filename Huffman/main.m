//
//  main.m
//  Huffman
//
//  Created by liufeng on 2019/4/16.
//  Copyright © 2019 成都尚医信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuffmanGo.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSString *str = @"abc";
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSString *bitStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
        

        
        HuffmanGo *huffman = [HuffmanGo new];
        [huffman go];
    }
    return 0;
}
