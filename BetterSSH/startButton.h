//
//  startButton.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-5.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum connectionStatusTypes{

    DISCONNECT,
    CONNECTTING,
    CONNECTTED
}connectionStatus;


@interface startButton : NSButton
@property (nonatomic) connectionStatus status;


@end
