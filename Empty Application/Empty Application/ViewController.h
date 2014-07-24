//
//  ViewController.h
//  Empty Application
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DKAudioPlayer.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DKAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSMutableArray *songsList;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property BOOL isPaused;
@property BOOL scrubbing;
@property NSTimer *timer;

- (IBAction)playAudioPressed:(id)sender;
- (IBAction)setCurrentTime:(id)sender;
- (IBAction)userIsScrubbing:(id)sender;

@end
