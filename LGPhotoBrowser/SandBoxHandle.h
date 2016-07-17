//
//  SandBoxHandle.h
//  LGPhotoBrowser
//
//  Created by hanwenjing on 2016/7/17.
//  Copyright © 2016年 L&G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SandBoxHandle : NSObject

+(BOOL) FileIsExists:(NSString*) checkFile;
+(int) CopyFileToDocument:(NSString*)FileName;
+(NSArray *)loadArrayListProduct   : (NSString*) FileUrl ;
+(NSArray *)loadArrayList   : (NSString*) FileUrl ;
+(NSDictionary *)loadNSDictionaryForProduct   : (NSString*) FileUrl ;
+(NSDictionary *)loadNSDictionaryForDocument  : (NSString*) FileUrl ;
+(void)saveOrderArrayList:(NSMutableArray *)list  FileUrl :(NSString*) FileUrl ;
+(void)saveOrderArrayListProduct:(NSMutableArray *)list  FileUrl :(NSString*) FileUrl ;
+(void)saveNSDictionaryForProduct:(NSDictionary *)list  FileUrl:(NSString*) FileUrl  ;
+(void)saveNSDictionaryForDocument:(NSDictionary *)list  FileUrl:(NSString*) FileUrl  ;
+(NSString *)fullpathOfFilename:(NSString *)filename ;
+(NSString *) DocumentPath:(NSString *)filename ;
+(NSString *) ProductPath:(NSString*)filename;
+(NSString *)documentsPath ;

+(BOOL)savedData:(NSData *)list  FileUrl :(NSString*) FileUrl ;


@end
