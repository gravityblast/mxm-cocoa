#import "MXMRequest.h"


@implementation MXMRequest
@synthesize request;
@synthesize connection;
@synthesize receivedData;
@synthesize delegate;


+(id)requestWithUrl:(NSString*)url {
	MXMRequest *request = [[[MXMRequest alloc] initWithUrl:url] autorelease];
	return request;
}

-(id)initWithUrl:(NSString*)url {
	if (self = [super init]) {
		NSString *cleanUrl = [NSString stringWithFormat:@"%@", url];
		self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:cleanUrl]
										cachePolicy:NSURLRequestUseProtocolCachePolicy
										timeoutInterval:60.0];
		self.receivedData = [NSMutableData data];
	}

	return self;
}

+(id)requestWithAction:(NSString*)action params:(NSDictionary*)params {
	MXMRequest *request = [[[MXMRequest alloc] initWithAction:action params:params] autorelease];
	return request;
}

-(id)initWithAction:(NSString*)action params:(NSDictionary*)params {
	if (self = [super init]) {
		[self initWithUrl:[self urlForAction:action params:params]];
	}

	return self;
}

-(void)start {
	self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
}

-(NSString*)urlForAction:(NSString*)action params:(NSDictionary*)params {
	NSString *url = [NSString stringWithFormat:@"%@/%@?apikey=%@&format=xml", MXM_API_URL, action, MXM_API_KEY];
	for (id key in params) {
		url = [NSString stringWithFormat:@"%@&%@=%@", url, [self urlencode:key], [self urlencode:[params valueForKey:key]]];
	}

	return url;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"RECEIVE RESPONSE");
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"RECEIVE DATA");
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"DID FAIL");
	if (self.delegate && [self.delegate respondsToSelector:@selector(mXmRequestError:)]) {
		[self.delegate mXmRequestError:(NSError *)error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"DID FINISH");
	if (self.delegate && [self.delegate respondsToSelector:@selector(mXmRequestDidFinish:)]) {
		[self.delegate mXmRequestDidFinish:receivedData];
	}
}

-(void)cancel {
	if (connection) {
		[connection cancel];
	}
}

-(NSString *)urlencode:(NSString *)url
{
	NSString *out = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return out;
//    NSArray *escapeChars = [NSArray arrayWithObjects:@"\n", @"\r", @" ", @";" , @"/" , @"?" , @":" ,
//							@"@" , @"&" , @"=" , @"+" ,
//							@"$" , @"," , @"[" , @"]",
//							@"#", @"!", @"'", @"(",
//							@")", @"*", nil];
//
//    NSArray *replaceChars = [NSArray arrayWithObjects:@"%20", @"%20", @"%20", @"%3B" , @"%2F" , @"%3F" ,
//							 @"%3A" , @"%40" , @"%26" ,
//							 @"%3D" , @"%2B" , @"%24" ,
//							 @"%2C" , @"%5B" , @"%5D",
//							 @"%23", @"%21", @"%27",
//							 @"%28", @"%29", @"%2A", nil];
//
//    int len = [escapeChars count];
//
//    NSMutableString *temp = [url mutableCopy];
//
//    int i;
//    for(i = 0; i < len; i++)
//    {
//
//        [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
//							  withString:[replaceChars objectAtIndex:i]
//								 options:NSLiteralSearch
//								   range:NSMakeRange(0, [temp length])];
//    }
//
//    NSString *out = [NSString stringWithString: temp];
//
//    return out;
}

-(void) dealloc {
	[delegate release];
	[receivedData release];
	[request release];
	[connection cancel];
	[connection release];
	[super dealloc];
}

@end
