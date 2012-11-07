//
//  ViewController.m
//  PropertyTest
//
//  Created by Greg Jaskiewicz on 07/11/2012.
//  Copyright (c) 2012 Greg Jaskiewicz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSUInteger nonatomicUInt;
@property             NSUInteger atomicUInt;

@property (nonatomic) NSUInteger loopCount;
@property (weak, nonatomic) IBOutlet UITextField *iterationsTextField;

@property (weak, nonatomic) IBOutlet UILabel *nonatomicDirectResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonatomicPropertyResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *atomicDirectResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *atomicPropertyResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end


@implementation ViewController

- (IBAction)runTheTest:(id)sender
{
  [self.startButton setEnabled:NO];
  self.loopCount = [self.iterationsTextField.text integerValue];

  [self.iterationsTextField resignFirstResponder];
  
  self.nonatomicDirectResultLabel.text   = @"...";
  self.atomicDirectResultLabel.text      = @"...";
  self.nonatomicPropertyResultLabel.text = @"...";
  self.atomicPropertyResultLabel.text    = @"...";
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    [self runTests];
  });
}

- (void)runTests
{
  // DON'T RUN THIS ON THE MAIN THREAD !
  
  // NONATOMIC
  CFTimeInterval nonatomic_direct_duration = 0.0f;
  {
    NSUInteger x = self.loopCount;
    _nonatomicUInt = 0;
    
    CFTimeInterval startTime = CACurrentMediaTime();
    
    while(x--)
    {
      _nonatomicUInt = _nonatomicUInt + 1;
    }
    
    nonatomic_direct_duration =  CACurrentMediaTime() - startTime;
  }
  
  CFTimeInterval nonatomic_property_duration = 0.0f;
  {
    NSUInteger x = self.loopCount;
    self.nonatomicUInt = 0;
    
    CFTimeInterval startTime = CACurrentMediaTime();
    
    while(x--)
    {
      self.nonatomicUInt = self.nonatomicUInt + 1;
    }
    
    nonatomic_property_duration =  CACurrentMediaTime() - startTime;
  }
  
  // ATOMIC
  
  CFTimeInterval atomic_direct_duration = 0.0f;
  {
    NSUInteger x = self.loopCount;
    _atomicUInt = 0;
    
    CFTimeInterval startTime = CACurrentMediaTime();
    
    while(x--)
    {
      _atomicUInt = _atomicUInt + 1;
    }
    
    atomic_direct_duration =  CACurrentMediaTime() - startTime;
  }
  
  CFTimeInterval atomic_property_duration = 0.0f;
  {
    NSUInteger x = self.loopCount;
    self.atomicUInt = 0;
    
    CFTimeInterval startTime = CACurrentMediaTime();
    
    while(x--)
    {
      self.atomicUInt = self.atomicUInt + 1;
    }
    
    atomic_property_duration =  CACurrentMediaTime() - startTime;
  }
  
  
  dispatch_async(dispatch_get_main_queue(), ^{
    self.nonatomicDirectResultLabel.text  = [NSString stringWithFormat:@"time: %.5f",  nonatomic_direct_duration];
    self.atomicDirectResultLabel.text     = [NSString stringWithFormat:@"time: %.5f",  atomic_direct_duration];
    self.nonatomicPropertyResultLabel.text = [NSString stringWithFormat:@"time: %.5f", nonatomic_property_duration];
    self.atomicPropertyResultLabel.text    = [NSString stringWithFormat:@"time: %.5f", atomic_property_duration];

    [self.startButton setEnabled:YES];

  });
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.iterationsTextField.text = @"10000000";
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



@end

