//
//  DKAudioPlayer.h
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface DKAudioPlayer : UIViewController

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

- (void)initPlayer:(NSString *)audioFile fileExtension:(NSString *)fileEctension;
- (void)playAudio;
- (void)pauseAudio;
- (void)setCurrentAudioTime:(float)value;
- (float)getAudioDuration;
- (NSString *)timeFormat:(float)value;
- (NSTimeInterval)getCurrentAudioTime;

@end
