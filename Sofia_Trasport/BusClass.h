//
//  BusClass.h
//  Sofia Transport
//
//  Created by Atanas Atanasov on 2/19/14.
//  Copyright (c) 2014 Atanas Atanasov. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface BusClass : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;

@end
