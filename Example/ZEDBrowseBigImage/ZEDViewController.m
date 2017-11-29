//
//  ZEDViewController.m
//  ZEDBrowseBigImage
//
//  Created by 李超 on 11/29/2017.
//  Copyright (c) 2017 李超. All rights reserved.
//

#import "ZEDViewController.h"
#import <ZEDBrowseBigImage/ZEDBrowseBigImage.h>

@interface ZEDViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZEDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)tapAction:(id)sender {
    [[ZEDBrowseBigImage shareBrowseImageHelper] browseImageWithImageView:self.imageView portrait:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
