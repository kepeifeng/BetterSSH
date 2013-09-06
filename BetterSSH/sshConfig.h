//
//  sshConfig.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-6.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sshConfig : NSObject

@property (nonatomic) NSString *hostName;
@property (nonatomic) NSNumber *portNumber;
@property (nonatomic) NSNumber *socksPortNumber;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *obfuscationKey;
@property (nonatomic) NSString *presetName;

-(id)initWithDetail:(NSString *)presetName
             hostName:(NSString *) hostName
            portNumber:(NSNumber *)portNumber
            sockPortNumber:(NSNumber *)socksPortNumber
            userName:(NSString *)userName
            password:(NSString *)password
            obfuscationKey:(NSString *)obfuscationKey;



@end
