//
//  YXGameCompleteModel.h
//  zhangshang265G
//
//  Created by 265g on 16/8/29.
//  Copyright © 2016年 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXGameCompleteModel : NSObject
/***   游戏名   */
@property (nonatomic,copy) NSString *gamename;
/***   游戏图标   */
@property (nonatomic,copy) NSString *smallpic;
/***   游戏描述   */
@property (nonatomic,copy) NSString *content;
/***   游戏评分   */
@property (nonatomic,copy) NSString *score;
/***   游戏状态   */
@property (nonatomic,copy) NSString *status;
/***   游戏类型   */
@property (nonatomic,copy) NSString *type;
/***   搜藏参数   */
@property (nonatomic,copy) NSString *collect;

@end
