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

@interface HuffmanGo ()
///数字转编码
@property (nonatomic,strong) NSDictionary *numToCodeTable;
///编码转数字
@property (nonatomic,strong) NSDictionary *codeToNumTable;

@end

@implementation HuffmanGo
- (instancetype)init{
    if (self=[super init]) {
        NSArray *codes = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                           @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",
                           @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",
                           @"%",@"/"];
        NSMutableDictionary *codeToNumDic = [NSMutableDictionary new];
        for (int i=0; i<codes.count; i++) {
            NSString *code = codes[i];
            [codeToNumDic setValue:[NSString stringWithFormat:@"%d",i] forKey:code];
        }
        self.codeToNumTable = codeToNumDic;
        
        NSMutableDictionary *numToCodeDic = [NSMutableDictionary new];
        for (int i=0; i<codes.count; i++) {
            NSString *code = codes[i];
            [numToCodeDic setValue:code forKey:[NSString stringWithFormat:@"%d",i]];
        }
        self.numToCodeTable = numToCodeDic;
    }
    return self;
}
- (void)go{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"liufeng" ofType:@"txt"];
    path = @"/Users/postop_iosdev/Desktop/Huffman/liufeng.txt";
    NSURL *url = [NSURL URLWithString:path];
    NSString *txt = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSString *sourceString = @"123456789";
    NSString *sourceString = txt;

    //压缩
    NSString *compressedString = [self compressWith:sourceString];
    //解压
    NSLog(@"************************************************");
    NSLog(@"原始字符串:");
    NSLog(@"%@",sourceString);
    NSLog(@"压缩后的字符串:");
    NSLog(@"%@",compressedString);
    float compressionRatio = ((float)compressedString.length)/sourceString.length;
    NSLog(@"压缩率:%f",compressionRatio);
    NSLog(@"************************************************");
    NSString *decodedStr = [self decompressWith:compressedString];
    NSLog(@"解压字符串:");
    NSLog(@"%@",decodedStr);
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
- (void)installHuffmanCodeWith:(NSMutableArray *)arr huffmanTree:(HuffmanNode *)tree huffmanCode:(NSString *)huffmancode{
    if (nil == tree){
        return;
    }
    else if (tree.left_node == nil && tree.right_node == nil) {
        CodingNode *node = [CodingNode new];
        node.ascll_code = tree.ascll_code;
        NSString *_huffmanCode = [NSString stringWithFormat:@"%@%d",huffmancode,tree.bitCode];
        _huffmanCode = [_huffmanCode substringFromIndex:1];
        [node setHuffCode:_huffmanCode];
        [arr addObject:node];
        return;
    }else{
        NSString *currentHuffmancode = [NSString stringWithFormat:@"%@%d",huffmancode,tree.bitCode];
        [self installHuffmanCodeWith:arr huffmanTree:tree.left_node huffmanCode:currentHuffmancode];
        [self installHuffmanCodeWith:arr huffmanTree:tree.right_node huffmanCode:currentHuffmancode];
        return;
    }
}

//构建Huffman树
- (HuffmanNode *)installHuffmanTreeWith:(NSArray<HuffmanNode *> *)huffmanNodes{
    if (huffmanNodes.count == 1 && (huffmanNodes.firstObject.left_node || huffmanNodes.firstObject.right_node)) {
        return huffmanNodes.firstObject;
    }else{
        if (huffmanNodes.count > 1) {
            NSArray *sortedArr = [self sortWith:huffmanNodes];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:sortedArr];
            HuffmanNode *newNode = [HuffmanNode new];
            HuffmanNode *node1 = arr.lastObject;
            HuffmanNode *node2 = arr[arr.count-2];
            node1.bitCode = 0;
            node2.bitCode = 1;
            newNode.bitCode = 1;
            newNode.left_node = node1;
            newNode.right_node = node2;
            newNode.frequency = node1.frequency+node2.frequency;
            [arr removeLastObject];
            [arr removeLastObject];
            [arr addObject:newNode];
            return [self installHuffmanTreeWith:arr];
        }else{
            NSArray *sortedArr = [self sortWith:huffmanNodes];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:sortedArr];
            HuffmanNode *newNode = [HuffmanNode new];
            HuffmanNode *node1 = arr.lastObject;
            node1.bitCode = 0;
            newNode.bitCode = 1;
            newNode.left_node = node1;
            newNode.frequency = node1.frequency;
            [arr removeLastObject];
            [arr addObject:newNode];
            return [self installHuffmanTreeWith:arr];
        }
    }
}

- (NSArray<HuffmanNode *> *)installASCLLNodesWith:(NSString *)str{
    NSMutableArray *huffmanNodes = [NSMutableArray new];
    int character_num = (int)str.length;
    for (int i=0; i<256; i++) {
        HuffmanNode *node = [[HuffmanNode alloc] initWith:i];
        int num = 0;
        for (int j=0; j<str.length; j++) {
            int asciiCode = [str characterAtIndex:j];
            if (node.ascll_code == asciiCode) {
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
- (NSString *)compressWith:(NSString *)str{
    NSString *sourceString = str;
    
    //1.求频率
    NSMutableArray *huffmanNodes = [NSMutableArray arrayWithArray:[self installASCLLNodesWith:sourceString]];
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
            NSString *string =[NSString stringWithFormat:@"%c",huffmanNode.ascll_code];
            NSLog(@"字符：%@--频率：%.3f",string,huffmanNode.frequency);
        }
    }
    NSLog(@"<---------------------------------------------------->");
    //2.构建Huffman树
    HuffmanNode *huffmanTree = [self installHuffmanTreeWith:huffmanNodes];
    int height = [self treeHeightWith:huffmanTree];
    NSLog(@"树的深度为：%d",height);
    //3.组建编码
    NSMutableArray *huffmanCodes = [NSMutableArray new];
    [self installHuffmanCodeWith:huffmanCodes huffmanTree:huffmanTree huffmanCode:@""];
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
        NSString *string =[NSString stringWithFormat:@"%c",node.ascll_code];
        NSString *code = [NSString stringWithFormat:@"%@",node.huffmanCode];
        [codeDic setValue:code forKey:string];
        NSLog(@"字符：%@--编码：%@",string,node.huffmanCode);
    }
    [codeDic setValue:@"0" forKey:@"dicZeroNum"];
    [codeDic setValue:@"0" forKey:@"codeZeroNum"];
    
    NSString *codeDicBitString = [self convertDictionaryToBitString:codeDic];
    int dicZeroNum = 6-codeDicBitString.length%(int)6;
    [codeDic setValue:[NSString stringWithFormat:@"%d",dicZeroNum] forKey:@"dicZeroNum"];
    NSString *dicZeroStr = @"";
    for (int i=0; i<dicZeroNum; i++) {
        dicZeroStr = [dicZeroStr stringByAppendingString:@"0"];
    }
    
    //5.构建编码串
    NSString *codeString = @"";
    for (int i=0; i<sourceString.length; i++) {
        NSString *c = [NSString stringWithFormat:@"%c",[sourceString characterAtIndex:i]];
        NSString *code = [codeDic valueForKey:c];
        codeString = [codeString stringByAppendingString:code];
    }
    int zeroNum = 6-codeString.length%(int)6;
    [codeDic setValue:[NSString stringWithFormat:@"%d",zeroNum] forKey:@"codeZeroNum"];
    
    NSString *zeroStr = @"";
    for (int i=0; i<zeroNum; i++) {
        zeroStr = [zeroStr stringByAppendingString:@"0"];
    }
    codeString = [codeString stringByAppendingString:zeroStr];
    codeDicBitString = [self convertDictionaryToBitString:codeDic];
    codeDicBitString = [codeDicBitString stringByAppendingString:dicZeroStr];
    
    codeString = [codeDicBitString stringByAppendingString:codeString];
    
    //二进制转为ascll
    NSString *ascllString = [self transcodeBitStringToASCLLString:codeString];
    //压缩率低于0.99返回
    float compressRatio = (float)ascllString.length/str.length;
    if (compressRatio > 0.96) {
        return ascllString;
    }
    return [self compressWith:ascllString];
}
//解压缩
- (NSString *)decompressWith:(NSString *)str{
    NSString *bitString = [self transcodeASCLLStringToBitString:str];
    NSString *decodedString = [self decodeWith:bitString];
    if (nil == decodedString) {
        return str;
    }
    return [self decompressWith:decodedString];
}

//将二进制字符串转为ascll字符串(6位一个字符)
- (NSString *)transcodeBitStringToASCLLString:(NSString *)bitString{
    int i = (int)bitString.length/(int)6;
    //看是否有余数
    int j = (int)bitString.length%(int)6;
    if (j != 0) {
        NSLog(@"二进制字符串不合法");
        return nil;
    }
    NSString *str = @"";
    for (int m=0; m<i; m++) {
        NSString *sixBitString = [bitString substringWithRange:NSMakeRange(m*6, 6)];
        NSString *key = [NSString stringWithFormat:@"%d",[self covertBitStringToNum:sixBitString]];
        NSString *ascllCode = self.numToCodeTable[key];
        str = [str stringByAppendingString:ascllCode];
    }
    return str;
}

//将ascll字符（一个字符6位）串转为二进制字符串
- (NSString *)transcodeASCLLStringToBitString:(NSString *)ascllString{
    NSString *str = @"";
    for (int i=0; i<ascllString.length; i++) {
        NSString *ascllCode = [NSString stringWithFormat:@"%c",[ascllString characterAtIndex:i]];
        NSString *numStr = self.codeToNumTable[ascllCode];
        NSString *sixBitString = [self covertNumTo6BitString:[numStr intValue]];
        str = [str stringByAppendingString:sixBitString];
    }
    return str;
}

- (NSString *)decodeWith:(NSString *)codeStr{
    //这里的codeStr还是01字符串
    //1.根据{}找出字典
    int leftBraceCount = 0;
    int rightBraceCount = 0;
    int dicIndex = 0;
    for (int i=0; i<codeStr.length/(int)8; i++) {
        NSString *byteString = [codeStr substringWithRange:NSMakeRange(i*8, 8)];
        int ascll = [self covertBitStringToNum:byteString];
        NSString *c = [NSString stringWithFormat:@"%c",ascll];
        if ([c isEqualToString:@"{"]) {
            leftBraceCount = leftBraceCount + 1;
        }
        if ([c isEqualToString:@"}"]) {
            rightBraceCount = rightBraceCount + 1;
        }
        if (leftBraceCount == rightBraceCount) {
            dicIndex = i+1;
            break;
        }
    }
    NSString *dicBitString = [codeStr substringToIndex:dicIndex*8];
    NSDictionary *dic = [self convertBitStringToDictionary:dicBitString];
    if (!dic || dicIndex == 0) {
        return nil;
    }

    NSString *dicZeroCount = dic[@"dicZeroNum"];
    NSString *codeZeroNum = dic[@"codeZeroNum"];
    
    //2.提取编码串
    NSString *bitCodeString = [codeStr substringFromIndex:dicIndex*8];
    bitCodeString = [bitCodeString substringFromIndex:[dicZeroCount intValue]];
    bitCodeString = [bitCodeString substringToIndex:bitCodeString.length-[codeZeroNum intValue]];
    //3.根据字典解码
    return [self decodeWith:bitCodeString codeDic:dic decodeStr:@""];
}

- (NSString *)decodeWith:(NSString *)codeStr  codeDic:(NSDictionary *)codeDic decodeStr:(NSString *)decodeStr{
    NSArray *keys = [codeDic allKeys];
    NSString *str;
    for (NSString *key in keys) {
        if ([key isEqualToString:@"codeZeroNum"]||[key isEqualToString:@"dicZeroNum"]) {
            continue;
        }
        NSString *code = [codeDic valueForKey:key];
        NSString *_codeStr = [codeStr copy];
        if (_codeStr.length > code.length && [[_codeStr substringToIndex:code.length] isEqualToString:code]) {
            decodeStr = [decodeStr stringByAppendingString:key];
            _codeStr = [_codeStr substringFromIndex:code.length];
            str = [self decodeWith:_codeStr codeDic:codeDic decodeStr:decodeStr];
        }else if (_codeStr.length == code.length && [[_codeStr substringToIndex:code.length] isEqualToString:code]) {
            str = [decodeStr stringByAppendingString:key];
        }
    }
    return str;
}

//将二进制字符串转为字典
-(NSDictionary *)convertBitStringToDictionary:(NSString *)bitString{
    NSString *jsonString = @"";
    NSInteger cNum = bitString.length/(int)8;
    for (int i=0; i<cNum; i++) {
        NSString *byteString = [bitString substringWithRange:NSMakeRange(i*8, 8)];
        int ascll = [self covertBitStringToNum:byteString];
        NSString *c = [NSString stringWithFormat:@"%c",ascll];
        jsonString = [jsonString stringByAppendingString:c];
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;
}

//将字典转为二进制字符串
- (NSString *)convertDictionaryToBitString:(NSDictionary *)dic{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *bitString = @"";
    for (int i=0; i<jsonString.length; i++) {
        int ascll = [jsonString characterAtIndex:i];
        bitString = [bitString stringByAppendingString:[self covertNumTo8BitString:ascll]];
    }
    return bitString;
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

//十进制数字转6位二进制字符串
- (NSString *)covertNumTo6BitString:(int)num{
    NSString *bitString  = [self covertNumToBitString:num];
    int zeroCount = 6- (int)bitString.length;
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
