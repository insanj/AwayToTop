#import "substrate.h"

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface _UIScrollsToTopInitiatorView : UIView
-(id)hitTest:(CGPoint)arg1 withEvent:(id)arg2;
@end

%hook _UIScrollsToTopInitiatorView
-(id)hitTest:(CGPoint)arg1 withEvent:(id)arg2{
	if(arg1.y <= 25.f)
		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"ATScrollToTop" object:nil];
	return %orig;
}
%end

@interface SBLockScreenNotificationTableView : UITableView
@end

@interface SBLockScreenNotificationListView <UITableViewDataSource, UITableViewDelegate>{
	SBLockScreenNotificationTableView *_tableView;
}

-(id)initWithFrame:(CGRect)frame;
-(void)scrollToTopOfListAnimated:(BOOL)listAnimated;
@end

%hook SBLockScreenNotificationListView
-(id)initWithFrame:(CGRect)frame{
	SBLockScreenNotificationListView *original = %orig;
	[[NSDistributedNotificationCenter defaultCenter] addObserver:original selector:@selector(animateTopScroll) name:@"ATScrollToTop" object:nil];
	return original;
}

%new -(void)animateTopScroll{
	[self scrollToTopOfListAnimated:YES];
}

-(void)dealloc{
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
	%orig;
}
%end