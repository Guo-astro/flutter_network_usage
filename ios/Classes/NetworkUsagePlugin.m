//
//  NetworkUsagePlugin.m
//  network_usage
//
//  Created by 郭岩松 on 2023/06/01.
//

#import "NetworkUsagePlugin.h"
#if __has_include(<network_usage/network_usage-Swift.h>)
#import <network_usage/network_usage-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "network_usage-Swift.h"
#endif

@implementation NetworkUsagePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNetworkUsagePlugin registerWithRegistrar:registrar];
}
@end
