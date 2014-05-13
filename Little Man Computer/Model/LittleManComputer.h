//
//  LittleManComputer.h
//  Little Man Computer
//
//  Created by Dan Horwood on 12/05/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LittleManComputer : NSObject

@property (readonly) NSArray *memory;
@property (readonly) NSUInteger size;
@property NSUInteger pc;
@property NSUInteger cir;
@property NSInteger acc;
@property (readonly, getter = isRunning) BOOL running;

- (BOOL)setValue:(NSInteger)value atMemoryLocation:(NSUInteger)location;
- (BOOL)setValues:(NSArray *)values startingAtMemoryLocation:(NSUInteger)location;

- (id)initWithData:(NSArray *)values;
- (void)step;
- (void)reset;
- (void)clearMemory;

@end
