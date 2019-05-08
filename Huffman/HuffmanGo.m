//
//  HuffmanGo.m
//  Huffman
//
//  Created by liufeng on 2019/4/16.
//  Copyright © 2019 成都尚医信息技术有限公司. All rights reserved.
//

#import "HuffmanGo.h"
#import "HuffmanNode.h"
#import "CodingNode.h"
#import "Result.h"

@interface HuffmanGo ()

@end

@implementation HuffmanGo
- (instancetype)init{
    if (self=[super init]) {
//        NSArray *codes = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
//                           @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",
//                           @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",
//                           @"%",@"/"];
    }
    return self;
}
- (void)go{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"liufeng" ofType:@"txt"];
//    path = @"/Users/postop_iosdev/Desktop/Huffman/liufeng.txt";
//    NSURL *url = [NSURL URLWithString:path];
//    NSString *txt = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *sourceString = @"1我";
//    NSString *sourceString = txt;

    //压缩
    Result *result = [self compressWith:sourceString];
    NSLog(@"************************************************");
    NSLog(@"原始字符串:");
    NSLog(@"%@",sourceString);
    NSUInteger originByteNum = [sourceString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger compressedByteNum = [result.data length];
    float compressRatio = (float)compressedByteNum/originByteNum;
    NSLog(@"原始字符串所占字节数：%lu---压缩后所占字节数：%lu---压缩率：%.3f",originByteNum,compressedByteNum,compressRatio);
}

//求树的高度
- (int)treeHeightWith:(HuffmanNode *)root{
    if (!root) {
        return 0;
    }
    int leftHeigt = [self treeHeightWith:root.left_node];
    int rightHeight = [self treeHeightWith:root.right_node];
    return leftHeigt > rightHeight ? leftHeigt+1 : rightHeight+1;
}

//组建编码
- (void)createHuffmanCodeWith:(NSMutableArray *)arr huffmanTree:(HuffmanNode *)tree huffmanCode:(NSString *)huffmancode{
    if (nil != tree){
        if (tree.left_node == nil && tree.right_node == nil) {
            CodingNode *node = [CodingNode new];
            node.unicode = tree.unicode;
            NSString *_huffmanCode = [NSString stringWithFormat:@"%@%d",huffmancode,tree.bitCode];
            _huffmanCode = [_huffmanCode substringFromIndex:1];
            [node setHuffCode:_huffmanCode];
            [arr addObject:node];
        }else{
            NSString *currentHuffmancode = [NSString stringWithFormat:@"%@%d",huffmancode,tree.bitCode];
            [self createHuffmanCodeWith:arr huffmanTree:tree.left_node huffmanCode:currentHuffmancode];
            [self createHuffmanCodeWith:arr huffmanTree:tree.right_node huffmanCode:currentHuffmancode];
        }
    }
}

//构建Huffman树
- (HuffmanNode *)createHuffmanTreeWith:(NSArray<HuffmanNode *> *)huffmanNodes{
    if (huffmanNodes.count == 1 && (huffmanNodes.firstObject.left_node || huffmanNodes.firstObject.right_node)) {
        //返回根节点
        return huffmanNodes.firstObject;
    }else{
        //排序
        NSArray *sortedArr = [self sortWith:huffmanNodes];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:sortedArr];
        if (huffmanNodes.count > 1) {
            //左右子树
            HuffmanNode *newNode = [HuffmanNode new];
            HuffmanNode *nodeLeft = arr.lastObject;
            HuffmanNode *nodeRight = arr[arr.count-2];
            nodeLeft.bitCode = 0;
            nodeRight.bitCode = 1;
            newNode.bitCode = 1;
            newNode.left_node = nodeLeft;
            newNode.right_node = nodeRight;
            newNode.frequency = nodeLeft.frequency+nodeRight.frequency;
            [arr removeLastObject];
            [arr removeLastObject];
            [arr addObject:newNode];
            return [self createHuffmanTreeWith:arr];
        }else{
            //根节点
            HuffmanNode *rootNode = [HuffmanNode new];
            HuffmanNode *nodeLeft = arr.lastObject;
            nodeLeft.bitCode = 0;
            rootNode.bitCode = 1;
            rootNode.left_node = nodeLeft;
            rootNode.frequency = nodeLeft.frequency;
            [arr removeLastObject];
            [arr addObject:rootNode];
            return [self createHuffmanTreeWith:arr];
        }
    }
}

- (NSArray<HuffmanNode *> *)installHuffmanNodesWith:(NSString *)str{
    NSMutableArray *huffmanNodes = [NSMutableArray new];
    int character_num = (int)str.length;
    for (int i=0; i<65535; i++) {
        HuffmanNode *node = [[HuffmanNode alloc] initWith:i];
        int num = 0;
        for (int j=0; j<str.length; j++) {
            int unicode = [str characterAtIndex:j];
            if (node.unicode == unicode) {
                num++;
            }
        }
        node.frequency = (float)num/(float)character_num;
        if (node.frequency) {
            [huffmanNodes addObject:node];
        }
    }
    return huffmanNodes;
}

//数组降序排序
- (NSArray<HuffmanNode *> *)sortWith:(NSArray *)arr{
    NSMutableArray *_arr = [NSMutableArray arrayWithArray:arr];
    for (int i=0; i<_arr.count; i++) {
        for (int j=0; j<(_arr.count-i-1); j++) {
            HuffmanNode *node1 = _arr[j];
            HuffmanNode *node2 = _arr[j+1];
            if (node1.frequency<node2.frequency) {
                HuffmanNode *node = node1;
                _arr[j] = node2;
                _arr[j+1] = node;
            }
        }
    }
    return _arr;
}

//压缩
- (Result *)compressWith:(NSString *)str{
    NSString *sourceString = str;
    
    //1.求频率
    NSMutableArray *huffmanNodes = [NSMutableArray arrayWithArray:[self installHuffmanNodesWith:sourceString]];
    for (int i=0; i<huffmanNodes.count; i++) {
        for (int j=0; j<huffmanNodes.count-i-1; j++) {
            HuffmanNode *node1 = huffmanNodes[j];
            HuffmanNode *node2 = huffmanNodes[j+1];
            if (node1.frequency<node2.frequency) {
                HuffmanNode *node = node1;
                huffmanNodes[j] = node2;
                huffmanNodes[j+1] = node;
            }
        }
    }
    for (HuffmanNode *huffmanNode in huffmanNodes) {
        if (huffmanNode.frequency) {
            NSLog(@"Unicode：%d--频率：%.3f",huffmanNode.unicode,huffmanNode.frequency);
        }
    }
    NSLog(@"<---------------------------------------------------->");
    //2.构建Huffman树
    HuffmanNode *huffmanTree = [self createHuffmanTreeWith:huffmanNodes];
    int height = [self treeHeightWith:huffmanTree];
    NSLog(@"树的深度为：%d",height);
    //3.组建编码
    NSMutableArray *huffmanCodes = [NSMutableArray new];
    [self createHuffmanCodeWith:huffmanCodes huffmanTree:huffmanTree huffmanCode:@""];
    for (int i=0; i<huffmanCodes.count; i++) {
        for (int j=0; j<huffmanCodes.count-i-1; j++) {
            CodingNode *node1 = huffmanCodes[j];
            CodingNode *node2 = huffmanCodes[j+1];
            if (node1.huffmanCode.length>node2.huffmanCode.length) {
                CodingNode *node = node1;
                huffmanCodes[j] = node2;
                huffmanCodes[j+1] = node;
            }
        }
    }
    //4.构建编码字典
    NSMutableDictionary *codeDic = [NSMutableDictionary dictionary];
    for (CodingNode *node in huffmanCodes) {
        NSString *string =[NSString stringWithFormat:@"%d",node.unicode];
        NSString *code = [NSString stringWithFormat:@"%@",node.huffmanCode];
        [codeDic setValue:code forKey:string];
        NSLog(@"字符：%@--编码：%@",string,node.huffmanCode);
    }
    
    
    NSString *bitString = @"";
    for (int i=0; i<sourceString.length; i++) {
        int unicode = [sourceString characterAtIndex:i];
        bitString = [bitString stringByAppendingString:[codeDic valueForKey:[NSString stringWithFormat:@"%d",unicode]]];
    }
    int zeroCount = 8-bitString.length%8;
    for (int i=0; i<zeroCount; i++) {
        bitString = [bitString stringByAppendingString:@"0"];
    }
    Result *result = [Result new];
    result.originString = sourceString;
    result.bitString = bitString;
    result.data = [self bitStringToData:bitString];
    result.zeroCount = zeroCount;
    return result;
}


//二进制字符串转Data
- (NSData *)bitStringToData:(NSString *)bitString{
    NSUInteger length = bitString.length/8;
    Byte bytes[length];
    for (int i=0; i<length; i++) {
        NSString *byteString = [bitString substringWithRange:NSMakeRange(i, 8)];
        int value = [self covertBitStringToNum:byteString];
        bytes[i] = value;
    }
    NSData *data = [NSData dataWithBytes:bytes length:length];
    return data;
}

//十进制数字转8位二进制字符串
- (NSString *)covertNumTo8BitString:(int)num{
    NSString *bitString  = [self covertNumToBitString:num];
    int zeroCount = 8- (int)bitString.length;
    NSString *zeroStr = @"";
    for (int i=0; i<zeroCount; i++) {
        zeroStr = [zeroStr stringByAppendingString:@"0"];
    }
    return [zeroStr stringByAppendingString:bitString];
}

//十进制数字转为二进制字符串
- (NSString *)covertNumToBitString:(int)num{
    NSString *bitString  = @"";
    while (num != 0) {
        NSString *bit = [NSString stringWithFormat:@"%d",num%2];
        bitString = [bit stringByAppendingString:bitString];
        num = num/(int)2;
    }
    return bitString;
}

//二进制字符串转10进制数字
- (int)covertBitStringToNum:(NSString *)bitString{
    int num = 0;
    for (int i=0; i<bitString.length; i++) {
        NSString *bit = [NSString stringWithFormat:@"%c",[bitString characterAtIndex:bitString.length-i-1]];
        num += [bit intValue]*[self computX:2 power:i];
    }
    return num;
}

//求x的y次方
- (int)computX:(int)x power:(int)y{
    if (x==0) {
        return 0;
    }
    if (x!=0 && y==0) {
        return 1;
    }
    int m = x;
    for (int i=0; i<y-1; i++) {
        m = m*x;
    }
    return m;
}
@end
