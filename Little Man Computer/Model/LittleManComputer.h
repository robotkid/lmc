//
//  LittleManComputer.h
//  Little Man Computer
//
//  Created by Dan Horwood on 12/05/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LittleManComputerDelegate)
- (void)getInput;
- (void)putOutput:(NSNumber *)value;
- (void)panic:(NSString *)reason;
@end


@interface LittleManComputer : NSObject

@property (readonly) NSArray *memory;
@property (readonly) NSUInteger size;
@property NSUInteger pc;
@property NSUInteger cir;
@property NSInteger acc;
@property (readonly, getter = isRunning) BOOL running;
@property (weak) id delegate;


- (BOOL)setValue:(NSInteger)value atMemoryLocation:(NSUInteger)location;
- (BOOL)setValues:(NSArray *)values startingAtMemoryLocation:(NSUInteger)location;

- (id)initWithData:(NSArray *)values;
- (void)step;
- (void)reset;
- (void)clearMemory;
- (void)returnInput:(NSInteger)value;

@end
