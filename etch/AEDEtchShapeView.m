//
//  AEDEtchShapeView.m
//  etch
//
//  Created by Johan Halin on 22.5.2013.
//  Copyright (c) 2013 Aero Deko. All rights reserved.
//

#import "AEDEtchShapeView.h"

@interface AEDEtchShapeView ()
@property (nonatomic) NSArray *etchShapes;
@property (nonatomic, assign) BOOL animating;
@end

enum
{
	kEtchShapeWide = 0,
	kEtchShapeNarrow,
	kEtchShapeMax,
};

const NSInteger kEtchShapeMaxSize = 4;
const NSInteger kEtchShapeAmount = 4;
const NSTimeInterval kAnimationUpdateInterval = 0.4;

@implementation AEDEtchShapeView

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.backgroundColor = [UIColor clearColor];
	}

	return self;
}

#pragma mark - Private

- (void)_updateFrameForView:(UIView *)view
{
	CGFloat widthSize = CGRectGetWidth(self.bounds) * (1.0 / (CGFloat)kEtchShapeMaxSize);
	CGFloat heightSize = CGRectGetHeight(self.bounds) * (1.0 / (CGFloat)kEtchShapeMaxSize);

	NSInteger startXOffset = 0;
	NSInteger startYOffset = 0;
	CGFloat x = 0;
	CGFloat y = 0;
	CGFloat width = 0;
	CGFloat height = 0;
	
	NSInteger type = arc4random() % kEtchShapeMax;
	if (type == kEtchShapeWide)
	{
		startXOffset = arc4random() % kEtchShapeMaxSize;
		startYOffset = arc4random() % kEtchShapeMaxSize;
		NSInteger blockWidth = 1 + (arc4random() % (kEtchShapeMaxSize - startXOffset));
		width = (CGFloat)blockWidth * widthSize;
		height = heightSize;
	}
	else if (type == kEtchShapeNarrow)
	{
		startXOffset = arc4random() % kEtchShapeMaxSize;
		startYOffset = arc4random() % kEtchShapeMaxSize;
		NSInteger blockHeight = 1 + (arc4random() % (kEtchShapeMaxSize - startYOffset));
		width = widthSize;
		height = (CGFloat)blockHeight * heightSize;
	}
	
	x = ((CGFloat)startXOffset / (CGFloat)kEtchShapeMaxSize) * CGRectGetWidth(self.bounds);
	y = ((CGFloat)startYOffset / (CGFloat)kEtchShapeMaxSize) * CGRectGetHeight(self.bounds);
	
	CGRect rect = CGRectMake(x, y, width, height);
	
	view.frame = rect;
}

- (void)_updateFramesAnimated:(BOOL)animated
{	
	void (^updateFramesBlock)(void) = ^
	{
		for (UIView *view in self.etchShapes)
		{
			[self _updateFrameForView:view];
		}
	};
	
	if (animated)
	{
		[UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:updateFramesBlock];
	}
	else
	{
		updateFramesBlock();
	}
}

- (void)_updateFramesWithAnimation
{
	[self _updateFramesAnimated:YES];
	
	if (self.animating)
	{
		[self performSelector:@selector(_updateFramesWithAnimation) withObject:nil afterDelay:kAnimationUpdateInterval];
	}
}

#pragma mark - Public

- (void)setup
{
	self.animating = NO;
	
	NSMutableArray *shapes = [[NSMutableArray alloc] init];
	for (NSInteger i = 0; i < kEtchShapeAmount; i++)
	{
		UIView *rect = [[UIView alloc] initWithFrame:CGRectZero];
		rect.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
		[self addSubview:rect];
		[shapes addObject:rect];
	}
	
	self.etchShapes = shapes;
	
	[self _updateFramesAnimated:NO];
}

- (void)startAnimation
{
	self.animating = YES;
	
	[self performSelector:@selector(_updateFramesWithAnimation) withObject:nil afterDelay:kAnimationUpdateInterval];
}

- (void)stopAnimation
{
	self.animating = NO;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_updateFramesWithAnimation) object:nil];
}

@end
