//
//  DKAudioPlayer.m
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import "DKAudioPlayer.h"

@implementation DKAudioPlayer

// Init Player with Filename
- (void)initPlayer:(NSString *)audioFile fileExtension:(NSString *)fileEctension
{
    NSURL *audioFileLocation = [[NSBundle mainBundle] URLForResource:audioFile
                                                       withExtension:fileEctension];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocation
                                                              error:&error];
}

- (void)playAudio
{
    [self.audioPlayer play];
}

- (void)pauseAudio
{
    [self.audioPlayer pause];
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
    [self.audioPlayer setCurrentTime:value];
}

- (NSTimeInterval)getCurrentAudioTime
{
    return [self.audioPlayer currentTime];
}

- (float)getAudioDuration
{
    return [self.audioPlayer duration];
}

@end
