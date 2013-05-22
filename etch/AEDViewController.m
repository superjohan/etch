//
//  AEDViewController.m
//  etch
//
//  Created by Johan Halin on 22.5.2013.
//  Copyright (c) 2013 Aero Deko. All rights reserved.
//

#import "AEDViewController.h"
#import "AEDEtchShapeView.h"

@interface AEDViewController ()
@property (nonatomic) AEDEtchShapeView *shapeView;
@end

@implementation AEDViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
	
	self.shapeView = [[AEDEtchShapeView alloc] initWithFrame:self.view.bounds];
	[self.shapeView setup];
	[self.view addSubview:self.shapeView];
	
	[self.shapeView startAnimation];
}

@end
