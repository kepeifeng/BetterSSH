//
//  sshConfig.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-6.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum connectionStatusTypes{
    
    DISCONNECT,
    CONNECTING,
    CONNECTED
}connectionStatus;


@interface sshConfig : NSObject

@property (nonatomic) NSString *hostName;
@property (nonatomic) NSUInteger portNumber;
@property (nonatomic) NSUInteger socksPortNumber;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *obfuscationKey;
@property (nonatomic) NSString *presetName;

-(id)initWithDetail:(NSString *)presetName
             hostName:(NSString *) hostName
            portNumber:(NSUInteger )portNumber
            sockPortNumber:(NSUInteger )socksPortNumber
            userName:(NSString *)userName
            password:(NSString *)password
            obfuscationKey:(NSString *)obfuscationKey;

-(NSDictionary *)getDictionary;
+(sshConfig *)getSshConfigFromDictionary:(NSDictionary *)dictionary;
+(NSDictionary *)getDictionaryFromSshConfig:(sshConfig *)config;



@end
