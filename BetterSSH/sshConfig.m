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
           portNumber:(NSUInteger)portNumber
       sockPortNumber:(NSUInteger)socksPortNumber
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

-(NSDictionary *)getDictionary{

    return [sshConfig getDictionaryFromSshConfig:self];

}

+(sshConfig *)getSshConfigFromDictionary:(NSDictionary *)dictionary{
    
    sshConfig *config = [[sshConfig alloc]init];
    
    config.presetName = [dictionary objectForKey:@"presetName"];
    config.hostName= [dictionary objectForKey:@"hostName"];
    
//    config.portNumber = [(NSNumber *)[dictionary objectForKey:@"portNumber"] unsignedIntegerValue];
//    config.socksPortNumber = [(NSNumber *)[dictionary objectForKey:@"presetName"] unsignedIntegerValue];
    config.portNumber =[(NSNumber *)[dictionary objectForKey:@"portNumber"] unsignedIntegerValue];
    config.socksPortNumber = [(NSNumber *)[dictionary objectForKey:@"socksPortNumber"] unsignedIntegerValue];    
    
    
    config.userName = [dictionary objectForKey:@"userName"];
    config.password = [dictionary objectForKey:@"password"];
    config.obfuscationKey = [dictionary objectForKey:@"obfuscationKey"];
    
    return config;
    
    
    


}

+(NSDictionary *)getDictionaryFromSshConfig:(sshConfig *)config{
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:config.presetName,config.hostName,[NSNumber numberWithUnsignedInteger:config.portNumber],[NSNumber numberWithUnsignedInteger:config.socksPortNumber],config.userName,config.password,config.obfuscationKey, nil]
                                       forKeys:[NSArray arrayWithObjects:@"presetName",@"hostName",@"portNumber",@"socksPortNumber",@"userName",@"password",@"obfuscationKey", nil]];

}
@end
