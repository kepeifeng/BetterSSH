//
//  sshConfigPanelController.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-10.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "sshConfigPanelController.h"

@interface sshConfigPanelController ()

@end

@implementation sshConfigPanelController

@synthesize hostName = _hostName;

-(id)initWithConfiguration:(sshConfig *)configuration{

    self = [super init];
    self.configuration = configuration;
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



-(sshConfig *)configuration{

    return [[sshConfig alloc]initWithDetail:@""
                                   hostName:self.hostName.stringValue
                                 portNumber:self.portNumber.integerValue
                             sockPortNumber:self.socksPortNumber.integerValue
                                   userName:self.userName.stringValue
                                   password:self.password.stringValue
                             obfuscationKey:self.obfuscationKey.stringValue];
    
}

-(void)setConfiguration:(sshConfig *)configuration{
    

    [self.hostName setStringValue:configuration.hostName];
    [self.portNumber setStringValue:[NSString stringWithFormat:@"%ld",configuration.portNumber]];
    [self.socksPortNumber setStringValue:[NSString stringWithFormat:@"%ld",configuration.socksPortNumber]];
    [self.userName setStringValue:configuration.userName];
    [self.password setStringValue:configuration.password];
    [self.obfuscationKey setStringValue:configuration.obfuscationKey];
    
    



}

-(void)setIsEditable:(BOOL)isEditable{

    [self.hostName setEditable:isEditable];
    [self.portNumber setEditable:isEditable];
    [self.socksPortNumber setEditable:isEditable];
    [self.userName setEditable:isEditable];
    [self.password setEditable:isEditable];
    [self.obfuscationKey setEditable:isEditable];
//    [self.hostName setEditable:isEditable];
    

}


@end
