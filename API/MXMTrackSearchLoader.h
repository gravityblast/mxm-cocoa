#import <Foundation/Foundation.h>
#import "MXMRequest.h"
#import "GDataXMLNode.h"

@protocol MXMTrackSearchLoaderProtocol

-(void) mXmTrackSearchLoaderDidFinish:(NSArray*)tracks;
-(void) mXmTrackSearchLoaderError:(NSError *)error;

@end

@interface MXMTrackSearchLoader : NSObject <MXMRequestProtocol> {
	MXMRequest *request;
	id delegate;
}

@property (nonatomic, retain) MXMRequest *request;
@property (nonatomic, retain) id delegate;

+(id)loaderWithOptions:(NSDictionary*)options;
-(id)initWithOptions:(NSDictionary*)options;
- (void)start;
-(void)parseXMLDocument:(GDataXMLDocument*)document;
-(void)handleError:(NSError *)error;
-(void) cancel;

@end
