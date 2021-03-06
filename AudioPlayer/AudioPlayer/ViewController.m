//
//  ViewController.m
//  Empty Application
//
//  Created by Denys Khlivnyy on 7/21/14.
//  Copyright (c) 2014 Denys Khlivnyy. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

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
    
#ifdef __i386__
    NSLog(@"Running in the simulator");
    [self setupPlayerWithAudioFile];
    
#else
    NSLog(@"Running on a device");
    [self setupPlayerWithMediaLibrary];
#endif
    
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

- (void)setupPlayerWithMediaLibrary
{
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSArray *itemsFromGenericQuery = [everything items];
    self.songsList = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
    
    // Table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
    MPMediaItem *song = [self.songsList objectAtIndex:0];
    [self setupMediaAudioPlayer:song];
}

- (void)setupPlayerWithAudioFile
{
    NSString *filename = @"Alpha";
    NSString *fileExtension = @"mp3";
    
    [self.audioPlayer initPlayer:filename fileExtension:fileExtension];
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    
    self.timeElapsed.text = @"0:00";
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
}

// init the Player to get file properties to set the time labels
- (void)setupMediaAudioPlayer:(MPMediaItem *)song {
    [self.audioPlayer initMediaPlayer];
    
    AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:[song valueForProperty:MPMediaItemPropertyAssetURL]];
    [self.audioPlayer.Player replaceCurrentItemWithPlayerItem:currentItem];
    
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    self.timeElapsed.text = @"0:00";
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    NSString *artist = [song valueForProperty:MPMediaItemPropertyArtist];
    NSString *text = [NSString stringWithFormat:@"%@ - %@", artist, songTitle];
    self.songName.text = text;
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
    
    MPMediaItem *song = [self.songsList objectAtIndex:indexPath.row];
    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    NSString *artist = [song valueForProperty:MPMediaItemPropertyArtist];
    NSString *text = [NSString stringWithFormat:@"%@ - %@", artist, songTitle];
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.isPaused = NO;
    
    MPMediaItem *currentSong = [self.songsList objectAtIndex:indexPath.row];
    [self setupMediaAudioPlayer:currentSong];
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
    NSString *description = @"Connection error";
    NSString *failureReason = @"Can't seem to get a connection";
    NSArray *recoveryOption =@[@"Retry"];
    NSString *recoverySuggestion = @"Check your wi-fi settings and retry.";
    
    NSDictionary *userInfo =
    [NSDictionary dictionaryWithObjects:@[description,
                                          failureReason,
                                          recoveryOption,
                                          recoverySuggestion,
                                          self]
                                forKeys:@[NSLocalizedDescriptionKey,
                                          NSLocalizedFailureReasonErrorKey,
                                          NSLocalizedRecoveryOptionsErrorKey,
                                          NSLocalizedRecoverySuggestionErrorKey,
                                          NSRecoveryAttempterErrorKey]];
    
    NSError *error = [[NSError alloc] initWithDomain:@"NSCookbook.iOS7recipes"
                                                code:42
                                            userInfo:userInfo];
    
    [ErrorHandler handleError:error fatal:NO];
    
}

- (IBAction)fakeFatalError:(id)sender {
    NSString *description = @"Data error";
    NSString *failureReason = @"Data is corrupt. The app must shut down.";
    NSString *recoverySuggestion = @"Contact support!.";
    
    NSDictionary *userInfo =
    [NSDictionary dictionaryWithObjects:@[description,
                                          failureReason,
                                          recoverySuggestion]
                                forKeys:@[NSLocalizedDescriptionKey,
                                          NSLocalizedFailureReasonErrorKey,
                                          NSLocalizedRecoverySuggestionErrorKey]];
    
    NSError *error = [[NSError alloc] initWithDomain:@"NSCookbook.iOS7recipes"
                                                code:42
                                            userInfo:userInfo];
    
    [ErrorHandler handleError:error fatal:YES];

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

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
