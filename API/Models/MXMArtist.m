#import "MXMArtist.h"


@implementation MXMArtist
@synthesize artistId;
@synthesize name;
@synthesize pictureSmallUrl;
@synthesize biography;
@synthesize pictureSmallData;
@synthesize pictureSmallRequest;
@synthesize delegate;

+(id) artistWithArtistId:(NSString*)_artistId {
	return [[MXMArtist alloc] initWithArtistId:_artistId];
}

-(id) initWithArtistId:(NSString*)_artistId {
	if (self = [super init]) {
		self.artistId = _artistId;
		self.name = @"";
		self.pictureSmallUrl = @"";
		self.biography = @"";
	}

	return self;
}

-(void) loadPictureSmall {
	if (loadingPictureSmall) return;

	if (pictureSmallLoaded) {
		NSLog(@"COVER ALREADY LOADED: %@", self.pictureSmallUrl);
		return;
	}

	NSLog(@"LOADING COVER: %@", self.pictureSmallUrl);
	loadingPictureSmall = YES;
	self.pictureSmallRequest = [MXMRequest requestWithUrl:self.pictureSmallUrl];
	self.pictureSmallRequest.delegate = self;
	[self.pictureSmallRequest start];
}

- (void)dealloc {
	[pictureSmallData release];
	[pictureSmallRequest release];
	[delegate release];
	[artistId release];
	[name release];
	[pictureSmallUrl release];
	[biography release];
	[super dealloc];
}

-(void) mXmRequestDidFinish:(NSData*)data {
	if (delegate && [delegate respondsToSelector:@selector(artistPictureSmallDidLoad:)]) {
		self.pictureSmallData = data;
		[delegate artistPictureSmallDidLoad:data];
	}
}

-(void) mXmRequestError:(NSError *)error {
	pictureSmallLoaded = YES;
	if (delegate && [delegate respondsToSelector:@selector(artistPictureSmallLoaderError)]) {
		[delegate artistPictureSmallLoaderError];
	}
}

-(void) cancelPictureSmallLoader {
	if (self.pictureSmallRequest) {
		[self.pictureSmallRequest cancel];
	}
}

@end
