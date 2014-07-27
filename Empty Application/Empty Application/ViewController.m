//
//  ViewController.m
//  Empty Application
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.playButton setTitle:@"Listen" forState:UIControlStateNormal];
    
    self.audioPlayer = [[DKAudioPlayer alloc] init];
    self.songsList = [[NSMutableArray alloc] init];
    
    // Table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Array with all mp3 files in Apllication Bundle
    NSArray *pathArray = [[NSBundle mainBundle] pathsForResourcesOfType:@".mp3" inDirectory:@"."];
    
    for (NSString *path in pathArray) {
        NSURL *songURL = [NSURL fileURLWithPath:path];
        [self.songsList addObject: songURL];
    }
    
    [self.tableView reloadData];
    NSURL *song = [self.songsList objectAtIndex:0];
    [self setupAudioPlayer:song];
    
    // Let's add the some Paralax motion effect for a background
    CGFloat leftRightMin = -55.0f;
    CGFloat leftRightMax = 55.0f;
    
    UIInterpolatingMotionEffect *leftRight = [[UIInterpolatingMotionEffect alloc]
                                              initWithKeyPath:@"center.x"
                                              type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    leftRight.minimumRelativeValue = @(leftRightMin);
    leftRight.maximumRelativeValue = @(leftRightMax);
    
    UIMotionEffectGroup *meGroup = [[UIMotionEffectGroup alloc] init];
    meGroup.motionEffects = @[leftRight];
    
    [self.imgBg addMotionEffect:meGroup];
    
}

//init the Player to get file properties to set the time labels
- (void)setupAudioPlayer:(NSURL *)song {
    
    [self.audioPlayer initPlayer:song];
    AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:song];
    [self.audioPlayer.Player replaceCurrentItemWithPlayerItem:currentItem];
    
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    self.timeElapsed.text = @"0:00";
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
    NSString *songTitle = [song lastPathComponent];
    self.songName.text = songTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.songsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MusicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSURL *song = [self.songsList objectAtIndex:indexPath.row];
    NSString *songTitle = [song lastPathComponent];
    cell.textLabel.text = songTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.isPaused = NO;
    NSURL *song = [self.songsList objectAtIndex:indexPath.row];
    [self setupAudioPlayer:song];
    [self playAudio];
    
}

- (void) playAudio
{
    [self.timer invalidate];
    
    if (!self.isPaused) {
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        [self.audioPlayer playAudio];
        self.isPaused = YES;
    } else {
        // [self.playButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.playButton setTitle:@"Listen" forState:UIControlStateNormal];
        [self.audioPlayer pauseAudio];
        self.isPaused = NO;
    }

}

- (IBAction)playAudioPressed:(id)playButton {
    [self playAudio];
    }

- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.001
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    [self.audioPlayer setCurrentAudioTime:self.currentTimeSlider.value];
    self.scrubbing = FALSE;
}

- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}

- (IBAction)fakeNonFatalError:(id)sender {
}

- (IBAction)fakeFatalError:(id)sender {
}

- (void)updateTime:(NSTimer *)timer {
    if (!self.scrubbing) {
        self.currentTimeSlider.value = [self.audioPlayer getCurrentAudioTime];
    }
    
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]]];
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end