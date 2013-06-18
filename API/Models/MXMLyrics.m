#import "MXMLyrics.h"


@implementation MXMLyrics
@synthesize body;
@synthesize copyRight;

+(id) lyricsWithBody:(NSString*)_body copyRight:(NSString*)_copyRight {
	return [[MXMLyrics alloc] initWithBody:_body copyRight:_copyRight];
}

-(id) initWithBody:(NSString*)_body copyRight:(NSString*)_copyRight {
	if (self = [super init]) {
		self.body = _body;
		self.copyRight = _copyRight;
	}

	return self;
}

-(void) dealloc {
	[body release];
	[copyRight release];
	[super dealloc];
}

@end
