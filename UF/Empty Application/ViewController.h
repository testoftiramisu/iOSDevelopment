//
//  ViewController.h
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DKAudioPlayer.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) DKAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;

@property BOOL isPaused;
@property BOOL scrubbing;
@property NSTimer *timer;

- (IBAction)playAudioPressed:(id)sender;
- (IBAction)setCurrentTime:(id)sender;
- (IBAction)userIsScrubbing:(id)sender;

@end
