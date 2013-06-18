#import "MXMTrack.h"


@implementation MXMTrack

@synthesize trackId;
@synthesize lyricsId;
@synthesize trackName;
@synthesize artistId;
@synthesize albumCoverArt;
@synthesize artistName;
@synthesize albumCoverArtData;
@synthesize albumCoverArtRequest;
@synthesize delegate;

+(id) trackWithTrackId:(NSString*)_trackId lyricsId:(NSString*)_lyricsId trackName:(NSString*)_trackName artistId:(NSString*)_artistId
		 albumCoverArt:(NSString*)_albumCoverArt artistName:(NSString*)_artistName {

	return [[[MXMTrack alloc] initWithTrackId:_trackId lyricsId:_lyricsId trackName:_trackName artistId:_artistId albumCoverArt:_albumCoverArt artistName:_artistName] autorelease];

}

-(id) initWithTrackId:(NSString*)_trackId lyricsId:(NSString*)_lyricsId trackName:(NSString*)_trackName artistId:(NSString*)_artistId
		albumCoverArt:(NSString*)_albumCoverArt artistName:(NSString*)_artistName {
	if (self = [super init]) {
		loadingAlbumCoverArt = NO;
		albumCoverArtLoaded = NO;
		self.trackId = _trackId;
		self.lyricsId = _lyricsId;
		self.trackName = _trackName;
		self.artistId = _artistId;
		self.albumCoverArt = _albumCoverArt;
		self.artistName = _artistName;
	}

	return self;
}

-(void) loadAlbumCoverArt {
	if (loadingAlbumCoverArt) return;

	if (albumCoverArtLoaded) {
		NSLog(@"COVER ALREADY LOADED: %@", self.albumCoverArt);
		return;
	}

	loadingAlbumCoverArt = YES;
	self.albumCoverArtRequest = [MXMRequest requestWithUrl:[NSString stringWithFormat:@"%@?fallback=artist", self.albumCoverArt]];
	self.albumCoverArtRequest.delegate = self;
	[self.albumCoverArtRequest start];
}

-(void) mXmRequestDidFinish:(NSData*)data {
	if (delegate && [delegate respondsToSelector:@selector(albumCoverArtDidLoad:)]) {
		self.albumCoverArtData = data;
		[delegate albumCoverArtDidLoad:data];
	}
}

-(void) mXmRequestError:(NSError *)error {
	albumCoverArtLoaded = YES;
	if (delegate && [delegate respondsToSelector:@selector(albumCoverArtLoaderError)]) {
		[delegate albumCoverArtLoaderError];
	}
}

-(void) cancelAlbumCoverArtLoader {
	if (self.albumCoverArtRequest) {
		[self.albumCoverArtRequest cancel];
	}
}

-(void) dealloc {
	[self cancelAlbumCoverArtLoader];
	[albumCoverArtData release];
	[delegate release];
	[trackId release];
	[lyricsId release];
	[trackName release];
	[artistId release];
	[albumCoverArt release];
	[artistName release];

	[super dealloc];
}

@end
