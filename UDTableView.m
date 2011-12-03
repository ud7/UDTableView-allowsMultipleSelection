//
//  UDTableView.m
//  tets
//
//  Created by Rolandas Razma on 12/3/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "UDTableView.h"


@interface UDTableView (UDPrivate)

- (void)ud_setAllowsMultipleSelectionDuringEditing:(BOOL)allowsMultipleSelectionDuringEditing;

@end


@implementation UDTableView {
    BOOL _allowsMultipleSelectionDuringEditing;
    BOOL _needsMultipleSelectionBackport;
    NSMutableSet *_indexPathsForSelectedRows;
    NSObject <UITableViewDataSource>*_realDataSource;
    NSObject <UITableViewDelegate>*_realDelegate;
}


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
    [_indexPathsForSelectedRows release];
    [super dealloc];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ){
        [self setAllowsMultipleSelectionDuringEditing: [aDecoder decodeBoolForKey:@"UIAllowsMultipleSelectionDuringEditing"]];
    }
    return self;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = nil;

    if( [NSStringFromSelector(aSelector) isEqualToString:@"setAllowsMultipleSelectionDuringEditing:"] ){
        methodSignature = [[self class] instanceMethodSignatureForSelector:@selector(ud_setAllowsMultipleSelectionDuringEditing:)];   
    }else if( [NSStringFromSelector(aSelector) isEqualToString:@"allowsMultipleSelectionDuringEditing"] ){
        methodSignature = [[self class] instanceMethodSignatureForSelector:@selector(ud_allowsMultipleSelectionDuringEditing)];   
    }else if ( [_realDataSource respondsToSelector:aSelector] ){
        methodSignature = [_realDataSource methodSignatureForSelector:aSelector];
    }else if ( [_realDelegate respondsToSelector:aSelector] ){
        methodSignature = [_realDelegate methodSignatureForSelector:aSelector];
    }

    return methodSignature;
}


- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL aSelector = [invocation selector];
    
    if( [NSStringFromSelector(aSelector) isEqualToString:@"setAllowsMultipleSelectionDuringEditing:"] ){
        [invocation setSelector:@selector(ud_setAllowsMultipleSelectionDuringEditing:)];
        [invocation invokeWithTarget:self];
    }else if( [NSStringFromSelector(aSelector) isEqualToString:@"allowsMultipleSelectionDuringEditing"] ){
        [invocation setSelector:@selector(ud_allowsMultipleSelectionDuringEditing)];
        [invocation invokeWithTarget:self];
    }else if ( [_realDataSource respondsToSelector:aSelector] ){
        [invocation invokeWithTarget:_realDataSource];
    }else if ( [_realDelegate respondsToSelector:aSelector] ){
        [invocation invokeWithTarget:_realDelegate];
    }else{
        [self doesNotRecognizeSelector:aSelector];
    }
}


- (BOOL)respondsToSelector:(SEL)aSelector {
    if ( [_realDataSource respondsToSelector:aSelector] ){
        return YES;
    }else if ( [_realDelegate respondsToSelector:aSelector] ){
        return YES;
    }
    return [super respondsToSelector:aSelector];
}


- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    if ( [_realDataSource conformsToProtocol:aProtocol] ){
        return YES;
    }else if ( [_realDelegate conformsToProtocol:aProtocol] ){
        return YES;
    }
    return [super conformsToProtocol:aProtocol];
}


#pragma mark -
#pragma mark UITableView


- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    _realDataSource = dataSource;
    if( !_needsMultipleSelectionBackport ){
        [super setDataSource:dataSource];
    }
}


- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    _realDelegate = delegate;
    if( !_needsMultipleSelectionBackport ){
        [super setDelegate:delegate];
    }
}


- (void)reloadData {
    for( NSIndexPath *indexPath in [_indexPathsForSelectedRows allObjects] ){
        [self deselectRowAtIndexPath:indexPath animated:NO];
    }
    [_indexPathsForSelectedRows removeAllObjects];
    
    [super reloadData];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    for( NSIndexPath *indexPath in [_indexPathsForSelectedRows allObjects] ){
        [self deselectRowAtIndexPath:indexPath animated:NO];
    }
    [_indexPathsForSelectedRows removeAllObjects];
    
    [super setEditing:editing animated:animated];
}


- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    
    if( _needsMultipleSelectionBackport && _allowsMultipleSelectionDuringEditing && self.isEditing && indexPath ){
        NSAssert(( &UIApplicationLaunchOptionsNewsstandDownloadsKey == NULL ), @"tselectRowAtIndexPath:animated:scrollPosition: shouldn't be called because iOS5+ natively supports multiselect");
        
        [_indexPathsForSelectedRows addObject:indexPath];
        [[self cellForRowAtIndexPath:indexPath] setSelected:YES animated:animated];
    }else{
        [super selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    }
    
}


- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
 
    if( !_needsMultipleSelectionBackport || !_allowsMultipleSelectionDuringEditing ){
        [super deselectRowAtIndexPath:indexPath animated:animated];
    }else if( _allowsMultipleSelectionDuringEditing && indexPath ){
        NSAssert(( &UIApplicationLaunchOptionsNewsstandDownloadsKey == NULL ), @"deselectRowAtIndexPath:animated: shouldn't be called because iOS5+ natively supports multiselect");
        
        [_indexPathsForSelectedRows removeObject:indexPath];
        [[self cellForRowAtIndexPath:indexPath] setSelected:NO animated:animated];
    }
    
}


#pragma mark -
#pragma mark UITableViewDataSource

// Anyone knows why i can't forward it with forwardInvocation?
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(( &UIApplicationLaunchOptionsNewsstandDownloadsKey == NULL ), @"tableView:cellForRowAtIndexPath: shouldn't be called because iOS5+ natively supports multiselect");
    return [_realDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark UIScrollViewDelegate


// Anyone knows why i can't forward it with forwardInvocation?
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSAssert(( &UIApplicationLaunchOptionsNewsstandDownloadsKey == NULL ), @"scrollViewDidScroll: shouldn't be called because iOS5+ natively supports multiselect");
    if( [_realDelegate respondsToSelector:@selector(scrollViewDidScroll:)] ){
        [_realDelegate scrollViewDidScroll:scrollView];
    }
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(( &UIApplicationLaunchOptionsNewsstandDownloadsKey == NULL ), @"tableView:cellForRowAtIndexPath: shouldn't be called because iOS5+ natively supports multiselect");
    
    if( [_indexPathsForSelectedRows containsObject:indexPath] ){
        [cell setSelected:YES];
    }
    if ( [_realDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)] ){
        [_realDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(( &UIApplicationLaunchOptionsNewsstandDownloadsKey == NULL ), @"tableView:willSelectRowAtIndexPath: shouldn't be called because iOS5+ natively supports multiselect");
    
    if( [_indexPathsForSelectedRows containsObject:indexPath] ){
        [self deselectRowAtIndexPath:indexPath animated:NO];
    }else{
        [self selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        if( [_realDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)] ){
            [_realDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    return nil;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(( &UIApplicationLaunchOptionsNewsstandDownloadsKey == NULL ), @"tableView:willDeselectRowAtIndexPath: shouldn't be called because iOS5+ natively supports multiselect");
    
    return nil;
}


#pragma mark -
#pragma mark UDTableView


- (void)ud_setAllowsMultipleSelectionDuringEditing:(BOOL)allowsMultipleSelectionDuringEditing {
    if( _allowsMultipleSelectionDuringEditing == allowsMultipleSelectionDuringEditing ) return;
    
    NSAssert(( &UIApplicationLaunchOptionsNewsstandDownloadsKey == NULL ), @"ud_setAllowsMultipleSelectionDuringEditing: shouldn't be called because iOS5+ natively supports multiselect");
    
    _allowsMultipleSelectionDuringEditing = _needsMultipleSelectionBackport = allowsMultipleSelectionDuringEditing;
    if( _allowsMultipleSelectionDuringEditing ){
        [_indexPathsForSelectedRows release];
        _indexPathsForSelectedRows = [[NSMutableSet alloc] init];
        
        [super setDataSource:(id<UITableViewDataSource>)self];
        [super setDelegate:(id<UITableViewDelegate>)self];
    }else{
        [_indexPathsForSelectedRows release], _indexPathsForSelectedRows = nil;
        
        [self setDelegate:_realDelegate];
        [self setDataSource:_realDataSource];
    }
}


- (BOOL)ud_allowsMultipleSelectionDuringEditing {
    return _allowsMultipleSelectionDuringEditing;
}


- (NSArray *)indexPathsForSelectedRows {
    if( _needsMultipleSelectionBackport ){
        return [_indexPathsForSelectedRows allObjects];
    }else{
        return [super indexPathsForSelectedRows];
    }
}


@dynamic allowsMultipleSelectionDuringEditing;
@end
