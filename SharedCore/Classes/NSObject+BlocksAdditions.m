//
//  BlocksAdditions.m
//  PLBlocksPlayground
//
//  Created by Michael Ash on 8/9/09.
//

#import "NSObject+BlocksAdditions.h"

@implementation NSObject (BlocksAdditions)

- (void)my_callBlock
{
    void (^block)(void) = (id)self;
    block();
}
@end

void RunAfterDelay(NSTimeInterval delay, BasicBlock block)
{
    [[[block copy] autorelease] performSelector: @selector(my_callBlock) withObject: nil afterDelay: delay];
}