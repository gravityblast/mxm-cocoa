#import <Foundation/Foundation.h>
#import "MXMRequest.h"
#import "MXMArtist.h"
#import "GDataXMLNode.h"

@protocol MXMArtistInfoLoaderProtocol

-(void) mXmArtistInfoLoaderDidFinish:(MXMArtist*)artist;
-(void) mXmArtistInfoLoaderError:(NSError *)error;

@end

@interface MXMArtistInfoLoader : NSObject {
	MXMRequest *request;
	id delegate;
}

@property (nonatomic, retain) MXMRequest *request;
@property (nonatomic, retain) id delegate;

+(id)loaderWithArtistId:(NSString*)_artistId;
-(id)initWithArtistId:(NSString*)_artistId;
- (void)start;
-(void)parseXMLDocument:(GDataXMLDocument*)document;
-(void)handleError:(NSError *)error;
-(void) cancel;

@end
