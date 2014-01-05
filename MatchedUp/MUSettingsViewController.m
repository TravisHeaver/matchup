//
//  MUSettingsViewController.m
//  MatchedUp
//
//  Created by Travis Heaver on 12/24/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import "MUSettingsViewController.h"

@interface MUSettingsViewController ()
@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singlesSwitch;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *editbutton;
@property (strong, nonatomic) IBOutlet UILabel *ageLabe;

@end

@implementation MUSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.ageSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kMUAgeMaxEnabledKey];
    self.menSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUMenEnabledKey];
    self.womenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUWomenEnabledKey];
    self.singlesSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUSingleEnabledKey];
    
    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singlesSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.ageLabe.text = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -IBActions
- (IBAction)logoutButtonPressed:(UIButton *)sender {
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)settingsButtonPressed:(id)sender {
}

#pragma mark -helper
-(void)valueChanged:(id)sender
{
    if (sender == self.ageSlider) {
        [[NSUserDefaults standardUserDefaults] setInteger:(int)self.ageSlider.value forKey:kMUAgeMaxEnabledKey];
        self.ageLabe.text = [NSString stringWithFormat:@"%i",(int)self.ageSlider.value];
    }
    else if (sender == self.menSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.menSwitch.isOn forKey:kMUMenEnabledKey];
    }
    else if (sender == self.womenSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.womenSwitch.isOn forKey:kMUWomenEnabledKey];
    }
    else if (sender == self.singlesSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.singlesSwitch.isOn forKey:kMUSingleEnabledKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
