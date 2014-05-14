//
//  LittleManComputer.m
//  Little Man Computer
//
//  Created by Dan Horwood on 12/05/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

#import "LittleManComputer.h"


@interface LittleManComputer ()
@property (readwrite) NSMutableArray *mem;
@property (readwrite) BOOL running;
@property BOOL waitingForInput;
@end

#define LMC_MEM_SIZE 100
#define MIN_LMC_VALUE -999
#define MAX_LMC_VALUE 999

typedef NS_ENUM(NSInteger, lmcInstructions) {
    lmcInstructionHlt = 0,
    lmcInstructionAdd = 1,
    lmcInstructionSub = 2,
    lmcInstructionSta = 3,
    lmcInstructionLda = 5,
    lmcInstructionBra = 6,
    lmcInstructionBrz = 7,
    lmcInstructionBrp = 8,
    lmcInstructionIO = 9,
    lmcInstructionInp = 901,
    lmcInstructionOut = 902
};


@implementation LittleManComputer

- (NSUInteger)size
{
    return [self.mem count];
}


+ (NSInteger)intFromObject:(id)obj
{
    return [[self numberFromObject:obj] integerValue];
}


+ (NSNumber *)numberFromObject:(id)obj
{
    if ([[self class] isValidNumberValue:obj])
        return (NSNumber *)obj;
    else
        return @0;
}


+ (BOOL)isValidNumberValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]
        && [(NSNumber *)value integerValue] >= MIN_LMC_VALUE
        && [(NSNumber *)value integerValue] <= MAX_LMC_VALUE) {
        return YES;
    }
    else
        return NO;
}

- (id)initWithData:(NSArray *)values
{
    self = [super init];
    if (self) {
        _mem = [NSMutableArray arrayWithCapacity:LMC_MEM_SIZE];
        for (id val in values) {
            [_mem addObject:[[self class] numberFromObject:val]];
        }
        for (NSUInteger i = [values count]; i < LMC_MEM_SIZE; i++) {
            [_mem addObject:@0];
        }
        _pc = 0;
        _acc = 0;
        _cir = [_mem[0] integerValue];
        _running = YES;
        _waitingForInput = NO;
    }
    return self;
}

- (id)init
{
    return [self initWithData:@[@0]];
}


- (void)updateCIR
{
    self.cir = [self.mem[self.pc] integerValue];
}


- (NSArray *)memory
{
    return [self.mem copy];
}

- (BOOL)setValue:(NSInteger)value atMemoryLocation:(NSUInteger)location
{
    if ([[self class] isValidNumberValue:@(value)]) {
        self.mem[location] = @(value);
        [self updateCIR];
        return YES;
    }
    else
        return NO;
}

- (BOOL)setValues:(NSArray *)values startingAtMemoryLocation:(NSUInteger)location
{
    //Check if length of array plus starting position exceeds our memory size
    if (([values count] + location) >= self.size) {
        return NO;
    }
    //Ensure all values in the array are valid
    for (id val in values) {
        if (![[self class] isValidNumberValue:val]) {
            return NO;
        }
    }
    
    for (NSUInteger i = 0; i < [values count]; i++) {
        self.mem[location + i] = values[i];
    }
    [self updateCIR];
    return YES;
}


- (void)step
{
    lmcInstructions opcode = self.cir / 100;
    NSUInteger args = self.cir % 100;
    switch (opcode) {
        case lmcInstructionAdd:
            [self add:args];
            break;
        case lmcInstructionSub:
            [self subtract:args];
            break;
        case lmcInstructionSta:
            [self store:args];
            break;
        case lmcInstructionLda:
            [self load:args];
            break;
        case lmcInstructionBra:
            [self branchAlways:args];
            break;
        case lmcInstructionBrz:
            [self branchIfZero:args];
            break;
        case lmcInstructionBrp:
            [self branchIfZeroOrPositive:args];
            break;
        case lmcInstructionHlt:
            self.running = NO;
            break;
        case lmcInstructionIO:
            if (self.cir == lmcInstructionInp) {
                [self input];
                break;
            }
            else if (self.cir == lmcInstructionOut) {
                [self output];
                break;
            }
        default:
            NSLog(@"Invalid Opcode");
            self.running = NO;
            break;
    }
    if (self.pc < LMC_MEM_SIZE && self.running) {
        if (!(opcode == lmcInstructionBra || opcode == lmcInstructionBrp || opcode == lmcInstructionBrz)) {
            self.pc++;
        }
        [self updateCIR];
    }
    else
        self.running = NO;
}


- (void)reset
{
    self.pc = 0;
    self.acc = 0;
    [self updateCIR];
    self.running = YES;
}

- (void)clearMemory
{
    for (NSUInteger i = 0; i < self.size; i++) {
        [self.mem replaceObjectAtIndex:i withObject:@0];
    }
}


- (void)add:(NSUInteger)location
{
    self.acc += [self.mem[location] intValue];
    if (self.acc > MAX_LMC_VALUE)
        self.acc = MIN_LMC_VALUE + (self.acc - MAX_LMC_VALUE) - 1;
}

- (void)subtract:(NSUInteger)location
{
    self.acc -= [self.mem[location] intValue];
    if (self.acc < MIN_LMC_VALUE)
        self.acc = MAX_LMC_VALUE + (self.acc + MIN_LMC_VALUE) + 1;
}

- (void)store:(NSUInteger)location
{
    self.mem[location] = @(self.acc);
}

- (void)load:(NSUInteger)location
{
    self.acc = [self.mem[location] intValue];
}

- (void)branchAlways:(NSUInteger)location
{
    self.pc = location;
}

- (void)branchIfZero:(NSUInteger)location
{
    if (self.acc == 0) {
        self.pc = location;
    }
}

- (void)branchIfZeroOrPositive:(NSUInteger)location
{
    if (self.acc >= 0) {
        self.pc = location;
    }
}

- (void)input
{
    if ([self.delegate respondsToSelector:@selector(getInput)]) {
        [self.delegate performSelector:@selector(getInput)];
        self.waitingForInput = YES;
    }
}

- (void)output
{
    if ([self.delegate respondsToSelector:@selector(putOutput:)]) {
        [self.delegate performSelector:@selector(putOutput:) withObject:[NSNumber numberWithInteger:self.acc]];
    }
}

- (void)returnInput:(NSInteger)value
{
    NSNumber *userInputNumber = [NSNumber numberWithInteger:value];
    if ([[self class] isValidNumberValue:userInputNumber]) {
        self.acc = value;
    }
    else {
        self.acc = 0;
    }
    self.waitingForInput = NO;
}

@end
