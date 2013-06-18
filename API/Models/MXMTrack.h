#import <Foundation/Foundation.h>
#import "MXMRequest.h"


@protocol MXMTrackAlbumCoverArtProtocol

-(void)albumCoverArtDidLoad:(NSData*)data;
-(void)albumCoverArtLoaderError;

@end


@interface MXMTrack : NSObject <MXMRequestProtocol> {
	NSString *trackId;
	NSString *lyricsId;
	NSString *trackName;
	NSString *artistId;
	NSString *albumCoverArt;
	NSString *artistName;
	NSData *albumCoverArtData;
	MXMRequest *albumCoverArtRequest;
	BOOL loadingAlbumCoverArt;
	BOOL albumCoverArtLoaded;
	id delegate;
}

@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, copy) NSString *lyricsId;
@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSString *artistId;
@property (nonatomic, copy) NSString *albumCoverArt;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, retain) NSData *albumCoverArtData;
@property (nonatomic, retain) MXMRequest *albumCoverArtRequest;
@property (nonatomic, retain) id delegate;

+(id) trackWithTrackId:(NSString*)_trackId lyricsId:(NSString*)_lyricsId trackName:(NSString*)_trackName artistId:(NSString*)_artistId
		 albumCoverArt:(NSString*)_albumCoverArt artistName:(NSString*)_artistName;

-(id) initWithTrackId:(NSString*)_trackId lyricsId:(NSString*)_lyricsId trackName:(NSString*)_trackName artistId:(NSString*)_artistId
		 albumCoverArt:(NSString*)_albumCoverArt artistName:(NSString*)_artistName;

-(void) loadAlbumCoverArt;
-(void) cancelAlbumCoverArtLoader;

@end
