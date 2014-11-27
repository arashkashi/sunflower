//
//  TKDHighlightingTextStorage.m
//  TextKitDemo
//
//  Created by Max Seelemann on 29.09.13.
//  Copyright (c) 2013 Max Seelemann. All rights reserved.
//

#import "TKDHighlightingTextStorage.h"


@implementation TKDHighlightingTextStorage
{
	NSMutableAttributedString *_imp;

}

- (id)init
{
	self = [super init];
	
	if (self) {
		_imp = [NSMutableAttributedString new];
	}
	
	return self;
}


#pragma mark - Reading Text

- (NSString *)string
{
	return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
	return [_imp attributesAtIndex:location effectiveRange:range];
}


#pragma mark - Text Editing

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
	[_imp replaceCharactersInRange:range withString:str];
	[self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
	[_imp setAttributes:attrs range:range];
	[self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}


#pragma mark - Syntax highlighting

- (void)processEditing
{
	// Regular expression matching all iWords -- first character i, followed by an uppercase alphabetic character, followed by at least one other character. Matches words like iPod, iPhone, etc.
    self.regularExpression = (self.regularExpression != nil)? self.regularExpression : [NSRegularExpression regularExpressionWithPattern:@"a" options:0 error:NULL];
    
    if (self.fontSize == 0) { self.fontSize = 16; }
	
	
	// Clear text color of edited range
	NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
//	[self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    [self addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:paragaphRange];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:self.fontSize];
    [self addAttribute:NSFontAttributeName value:font range:paragaphRange];
	
	// Find all iWords in range
	[self.regularExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		// Add red highlight color
		[self addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
	}];
  
  // Call super *after* changing the attrbutes, as it finalizes the attributes and calls the delegate methods.
  [super processEditing];
}

@end
