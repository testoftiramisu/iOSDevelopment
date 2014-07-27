//
//  DKAudioPlayer.m
//  Empty Application
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import "DKAudioPlayer.h"

@implementation DKAudioPlayer

- (void) initPlayer
{
    self.Player = [[AVPlayer alloc] init];
}

- (void)playAudio
{
    NSLog(@"Playback started");
    [self.Player play];
}

- (void)pauseAudio
{
    NSLog(@"Playback paused");
    [self.Player pause];
}

// Format the float time values like duration to format with minutes and seconds
-(NSString *)timeFormat:(float)value
{
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc] initWithFormat:@"%d:%02d", roundedMinutes, roundedSeconds];
    return time;
}

- (void)setCurrentAudioTime:(float)value
{
    CMTime time = CMTimeMake(value, 1);
    [self.Player seekToTime:time];
}

- (float)getCurrentAudioTime
{
    float currentTime = self.Player.currentTime.value / self.Player.currentTime.timescale;
    return currentTime;
    
}

- (float)getAudioDuration
{
    float duration = self.Player.currentItem.asset.duration.value / self.Player.currentItem.asset.duration.timescale;
    return duration;
}

@end
