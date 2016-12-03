//
//  TSLifeSuggestion.h
//  天时
//
//  Created by  Jierism on 16/9/22.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <Mantle/Mantle.h>



@interface TSLifeSuggestion : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *suggestionTxt;
@property (nonatomic,copy) NSString *sutitle;
@end
