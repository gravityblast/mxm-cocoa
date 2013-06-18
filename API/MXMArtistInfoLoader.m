#import "MXMArtistInfoLoader.h"
#import "MXMArtist.h"

@implementation MXMArtistInfoLoader
@synthesize request;
@synthesize delegate;

+(id)loaderWithArtistId:(NSString*)_artistId {
	return [[[MXMArtistInfoLoader alloc] initWithArtistId:_artistId] autorelease];
}

-(id)initWithArtistId:(NSString*)_artistId {
	if (self = [super init]) {
		self.request = [MXMRequest requestWithAction:@"artist.info.get" params:[NSDictionary dictionaryWithObjectsAndKeys: _artistId, @"artist_id",
																				nil]];
		self.request.delegate = self;
	}

	return self;
}

- (void)start {
	[self.request start];
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

-(void)parseXMLDocument:(GDataXMLDocument *)document {
	[document retain];
	NSError *error = nil;
	NSArray *infoNodes = [document nodesForXPath:@"//info" error:&error];
	MXMArtist *artist = nil;
	if ([infoNodes count] > 0) {
		GDataXMLNode *infoNode = [infoNodes objectAtIndex:0];
		NSArray *artistIdNodes = [infoNode nodesForXPath:@"artist_id/text()" error:&error];
		NSArray *nameNodes = [infoNode nodesForXPath:@"artist_name/text()" error:&error];
		NSArray *pictureSmallUrlNodes = [infoNode nodesForXPath:@"artist_picture_small/text()" error:&error];
		NSArray *biographyNodes = [infoNode nodesForXPath:@"biography/text/text()" error:&error];
		if ([artistIdNodes count] > 0 && [nameNodes count] > 0 && [pictureSmallUrlNodes count] > 0 && [biographyNodes count] > 0) {
			NSString *artistId = [NSString stringWithFormat:@"%@", [[artistIdNodes objectAtIndex:0] stringValue]];
			NSString *name = [NSString stringWithFormat:@"%@", [[nameNodes objectAtIndex:0] stringValue]];
			NSString *pictureSmallUrl = [NSString stringWithFormat:@"%@", [[pictureSmallUrlNodes objectAtIndex:0] stringValue]];
			NSString *biography = [NSString stringWithFormat:@"%@", [[biographyNodes objectAtIndex:0] stringValue]];

			artist = [MXMArtist artistWithArtistId:artistId];
			artist.name = name;
			artist.pictureSmallUrl = pictureSmallUrl;
			artist.biography = biography;
		}
	}

	if (self.delegate && [self.delegate respondsToSelector:@selector(mXmArtistInfoLoaderDidFinish:)]) {
		[self.delegate mXmArtistInfoLoaderDidFinish:artist];
	}
	[artist release];
	[document release];
}

-(void) mXmRequestError:(NSError *)error {
	[self handleError:error];
}

-(void)handleError:(NSError *)error {
	if (self.delegate && [self.delegate respondsToSelector:@selector(mXmArtistInfoLoaderError:)]) {
		[self.delegate mXmArtistInfoLoaderError:error];
	}
}

-(void) cancel {
	if (self.request) {
		[request cancel];
	}
}

-(void) dealloc {
	[self cancel];
	[delegate release];
	[request release];
	[super dealloc];
}

@end
