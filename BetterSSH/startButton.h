//
//  startButton.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-5.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "sshConfig.h"



@interface startButton : NSButton{

    IBOutlet NSImage *button;
}
@property (nonatomic) connectionStatus status;



@end
