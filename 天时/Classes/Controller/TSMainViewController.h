//
//  TSMainViewController.h
//  天时
//
//  Created by  Jierism on 16/9/26.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSMainViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@end
