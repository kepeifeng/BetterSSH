//
//  sshController.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-6.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sshConfig.h"

@interface sshController : NSObject

@property sshConfig *config;

@property NSArray *presets;

@property bool autoConnect;

@property bool autoStartAtLogin;

@end
