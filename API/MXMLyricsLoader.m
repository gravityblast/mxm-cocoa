#import "MXMLyricsLoader.h"

@implementation MXMLyricsLoader
@synthesize request;
@synthesize delegate;

+(id)loaderWithTrackId:(NSString*)_trackId {
	return [[[MXMLyricsLoader alloc] initWithTrackId:_trackId] autorelease];
}

-(id)initWithTrackId:(NSString*)_trackId {
	if (self = [super init]) {
		self.request = [MXMRequest requestWithAction:@"track.lyrics.get" params:[NSDictionary dictionaryWithObjectsAndKeys: _trackId, @"track_id", nil]];
		self.request.delegate = self;
	}

	return self;
}

-(void) mXmRequestDidFinish:(NSData*)data {
	NSError *error = nil;
	GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
	if (document == nil || error) {
		[self handleError:error];
		return;
	}
	[self parseXMLDocument:document];
	[document release];
}

-(void)parseXMLDocument:(GDataXMLDocument*)document {
	[document retain];
	NSError *error = nil;
	NSArray *lyricsNodes = [document nodesForXPath:@"//lyrics" error:&error];
	MXMLyrics *lyrics = nil;
	if ([lyricsNodes count] > 0) {
		GDataXMLNode *lyricsNode = [lyricsNodes objectAtIndex:0];
		NSArray *lyricsBodyNodes = [lyricsNode nodesForXPath:@"lyrics_body/text()" error:&error];
		NSArray *lyricsCopyRightNodes = [lyricsNode nodesForXPath:@"lyrics_copyright/text()" error:&error];
		if ([lyricsBodyNodes count] > 0 && [lyricsCopyRightNodes count] > 0) {
			NSString *body = [NSString stringWithFormat:@"%@", [[lyricsBodyNodes objectAtIndex:0] stringValue]];
			NSString *copyRight = [NSString stringWithFormat:@"%@", [[lyricsCopyRightNodes objectAtIndex:0] stringValue]];

			lyrics = [MXMLyrics lyricsWithBody:body copyRight:copyRight];
		}
	}

	if (self.delegate && [self.delegate respondsToSelector:@selector(mXmLyricsLoaderDidFinish:)]) {
		[self.delegate mXmLyricsLoaderDidFinish:lyrics];
	}
	[lyrics release];
	[document release];
}

- (void)start {
	[self.request start];
}

-(void) mXmRequestError:(NSError *)error {
	[self handleError:error];
}

-(void)handleError:(NSError *)error {
	if (self.delegate && [self.delegate respondsToSelector:@selector(mXmLyricsLoaderError:)]) {
		[self.delegate mXmLyricsLoaderError:error];
	}
}

-(void) cancel {
	if (self.request) {
		[request cancel];
	}
}

-(void) dealloc {
	[delegate release];
	[self cancel];
	[request release];
	[super dealloc];
}

@end
