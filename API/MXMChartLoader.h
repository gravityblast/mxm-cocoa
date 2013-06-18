#import <Foundation/Foundation.h>
#import "MXMRequest.h"
#import "GDataXMLNode.h"

@protocol MXMChartLoaderProtocol

-(void) mXmChartLoaderDidFinish:(NSArray*)tracks;
-(void) mXmChartLoaderError:(NSError *)error;

@end

@interface MXMChartLoader : NSObject <MXMRequestProtocol> {
	MXMRequest *request;
	id delegate;
}

@property (nonatomic, retain) MXMRequest *request;
@property (nonatomic, retain) id delegate;

+(id)loaderWithCountry:(NSString*)_country;
-(id)initWithCountry:(NSString*)_country;
- (void)start;
-(void)parseXMLDocument:(GDataXMLDocument*)document;
-(void)handleError:(NSError *)error;
-(void) cancel;

@end
