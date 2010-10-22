//
//  BlocksAdditions.m
//  PLBlocksPlayground
//
//  Created by Michael Ash on 8/9/09.
//

typedef void (^BasicBlock)(void);

void RunAfterDelay(NSTimeInterval delay, BasicBlock block);