//
//  TuiDebug.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/18/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#ifndef TuiObjCApi_TuiDebug_h
#define TuiObjCApi_TuiDebug_h

    #ifdef __OBJC__

        #ifdef DEBUG
            #define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
            #define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
            #else
            #define DLog(...) do { } while (0)
            #ifndef NS_BLOCK_ASSERTIONS
            #define NS_BLOCK_ASSERTIONS
            #endif
            #define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
        #endif

        #define TuiAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while(0)
        #define TUI_DEBUG 1

    #endif


#endif
