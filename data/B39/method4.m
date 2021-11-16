#import "ObjcLib.h"
@implementation ObjcLib
-(NSArray*)method4:(NSArray*)array{
    NSMutableArray *arrayOut = [[NSMutableArray alloc] init];
    for (int i=0; i<array.count; i++){        
        NSNumber* num = array[i];
        NSInteger value = num.integerValue;
        value *= 10;
        [arrayOut addObject:[NSNumber numberWithInteger:value]];
    }
    return arrayOut;
}
@end