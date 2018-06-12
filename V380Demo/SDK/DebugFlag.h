//
//  DebugFlag.h
//  iCamSee
//
//  Created by macrovideo on 15/7/7.
//  Copyright (c) 2015年 macrovideo. All rights reserved.
//

#ifndef DebugFlag_h
#define DebugFlag_h

#define APP_DEBUG //app debug中

//#define TDEBUG

#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#endif

#ifdef TDEBUG
#define TLog(...) NSLog(__VA_ARGS__)
#else
#define TLog(...)
#endif

#endif
