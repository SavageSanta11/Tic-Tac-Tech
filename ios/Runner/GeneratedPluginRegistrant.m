//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<audio_recorder/AudioRecorderPlugin.h>)
#import <audio_recorder/AudioRecorderPlugin.h>
#else
@import audio_recorder;
#endif

#if __has_include(<hexcolor/HexcolorPlugin.h>)
#import <hexcolor/HexcolorPlugin.h>
#else
@import hexcolor;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AudioRecorderPlugin registerWithRegistrar:[registry registrarForPlugin:@"AudioRecorderPlugin"]];
  [HexcolorPlugin registerWithRegistrar:[registry registrarForPlugin:@"HexcolorPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
}

@end
