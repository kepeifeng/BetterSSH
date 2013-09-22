//
//  myLabel.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-22.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "myLabel.h"

@implementation myLabel

- (id)init
{
    self = [super init];
    if (self) {
        [self setFont:[NSFont fontWithName:@"BigNoodleTitling" size:18]];

    }
    return self;
}

-(id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];

    return self;

}

-(void)awakeFromNib{
    [self setFont:[NSFont fontWithName:@"BigNoodleTitling" size:18]];
    

}


@end
