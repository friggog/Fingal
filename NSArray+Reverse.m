#import "NSArray+Reverse.h"

@implementation NSArray (Reverse)
- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}
@end
