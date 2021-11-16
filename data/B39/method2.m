#import "ObjcLib.h"
@implementation ObjcLib
-(NSInteger)method2:(NSInteger)value{
    value += value;
    return value;
}
@end