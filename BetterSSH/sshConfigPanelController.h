//
//  sshConfigPanelController.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-10.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "sshConfig.h"

@interface sshConfigPanelController : NSViewController


-(id)initWithConfiguration:(sshConfig *)configuration;

@property (nonatomic) sshConfig *configuration;


@property (weak) IBOutlet NSTextField *hostName;
@property (weak) IBOutlet NSTextField *portNumber;
@property (weak) IBOutlet NSTextField *socksPortNumber;
@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSSecureTextField *password;
@property (weak) IBOutlet NSTextField *obfuscationKey;
@property (nonatomic) BOOL isEditable;


@end
