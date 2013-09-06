//
//  sshConfig.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-6.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "sshConfig.h"

@implementation sshConfig


-(id)initWithDetail:(NSString *)presetName
             hostName:(NSString *) hostName
           portNumber:(NSNumber *)portNumber
       sockPortNumber:(NSNumber *)socksPortNumber
             userName:(NSString *)userName
             password:(NSString *)password
       obfuscationKey:(NSString *)obfuscationKey{


    self = [super init];
    
    if(self){
        self.presetName = presetName;
        self.hostName = hostName;
        self.portNumber = portNumber;
        self.socksPortNumber = socksPortNumber;
        self.userName = userName;
        self.password = password;
        self.obfuscationKey = obfuscationKey;
    }
    
    return self;
    
    
    
}



@end
