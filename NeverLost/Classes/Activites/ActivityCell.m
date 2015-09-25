//
//  ActivityCell.m
//  NeverLost
//
//  Created by Alex Marchis on 02/09/15.
//  Copyright (c) 2015 NeverLost. All rights reserved.
//

#import "ActivityCell.h"
#import "MyActivity.h"
#import "utils.h"


static CGFloat kMargin     = 5.0f;
static CGFloat kDistance   = 10.0f; 
static CGFloat kCircleSize = 42.5f;

@interface ActivityCell ()

@property (nonatomic, strong) UIView      *whiteView;
@property (nonatomic, strong) UIView      *circleView;
@property (nonatomic, strong) UILabel     *circleLabel;
@property (nonatomic, strong) UILabel     *providerNameLabel;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *descriptionLabel;

@property (nonatomic, strong) UIButton    *readMoreBtn;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImageView *activityImageView;

@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *finishDateLabel;

@property (nonatomic, strong) UIButton *meetingBtn;
@property (nonatomic, strong) UILabel *meetingLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UIButton *nrOfCommentsBtn;
@property (nonatomic, strong) UIButton *addCommentBtn;
@property (nonatomic, strong) UIButton *firstCommentBtn;

@property (nonatomic, strong) UIView *separationView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation ActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.whiteView = [UIView newAutoLayoutView];
        [self.contentView addSubview:self.whiteView];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView.layer.cornerRadius = 5.0f;
        
        self.circleView = [UIView newAutoLayoutView];
        [self.whiteView addSubview:self.circleView];
        self.circleView.backgroundColor = [UIColor appGreen];
        self.circleView.layer.cornerRadius = kCircleSize/2;
        
        self.circleLabel = [UILabel newAutoLayoutView];
        [self.circleView addSubview:self.circleLabel];
        self.circleLabel.font = [UIFont fontBebasRegularWithSize:28.0];
        self.circleLabel.textColor = [UIColor whiteColor];
        self.circleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.providerNameLabel = [UILabel newAutoLayoutView];
        [self.whiteView addSubview:self.providerNameLabel];
        self.providerNameLabel.font = [UIFont fontBebasRegularWithSize:20];
        self.providerNameLabel.text = @"OLD JAFFA HOSTEL";
        
        self.titleLabel = [UILabel newAutoLayoutView];
        [self.whiteView addSubview:self.titleLabel];
        self.titleLabel.font = [UIFont fontOpenSansRegularWithSize:15];
        self.titleLabel.text = @"A tour in the old city of Jaffa";
        
        self.readMoreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.readMoreBtn];
        NSMutableAttributedString *readString = [[NSMutableAttributedString alloc] initWithString:@"read more"];
        [readString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [readString length])];
        [readString addAttribute:NSForegroundColorAttributeName value:[UIColor appLightBlue] range:NSMakeRange(0, [readString length])];
        [readString addAttribute:NSFontAttributeName value:[UIFont fontOpenSansRegularWithSize:13] range:NSMakeRange(0, [readString length])];
        [self.readMoreBtn setAttributedTitle:readString forState:UIControlStateNormal];
        
        [self bringSubviewToFront:self.readMoreBtn];
        
        self.descriptionLabel = [UILabel newAutoLayoutView];
        [self.whiteView addSubview:self.descriptionLabel];
        self.descriptionLabel.font = [UIFont fontOpenSansRegularWithSize:13];
        self.descriptionLabel.text = @"Join us on Beachfront Hotel rooftop for drinks and a friendly chat in any language you want!";
        
        self.activityImageView = [UIImageView newAutoLayoutView];
        [self.whiteView addSubview:self.activityImageView];
        
        self.activityIndicator = [UIActivityIndicatorView newAutoLayoutView];
        [self.activityImageView addSubview:self.activityIndicator];
        [self.activityIndicator startAnimating];
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.activityIndicator hidesWhenStopped];
        
        self.startDateLabel = [UILabel newAutoLayoutView];
        [self.whiteView addSubview:self.startDateLabel];
        self.startDateLabel.font = [UIFont fontOpenSansRegularWithSize:13];
        self.startDateLabel.text = @"Today: 12/11 09:00 AM";
        self.startDateLabel.textColor = [UIColor appGray];
        
        self.finishDateLabel = [UILabel newAutoLayoutView];
        [self.whiteView addSubview:self.finishDateLabel];
        self.finishDateLabel.font = [UIFont fontOpenSansRegularWithSize:13];
        self.finishDateLabel.text = @"Until: 12/11 09:00 AM";
        self.finishDateLabel.textColor = [UIColor appGray];
        
        self.meetingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.whiteView addSubview:self.meetingBtn];
        [self.meetingBtn setImage:[UIImage imageNamed:@"meetingBtn"] forState:UIControlStateNormal];
        
        self.meetingLabel = [UILabel newAutoLayoutView];
        [self.whiteView addSubview:self.meetingLabel];
        self.meetingLabel.font = [UIFont fontOpenSansRegularWithSize:13];
        self.meetingLabel.text = @"Meeting Place";
        self.meetingLabel.textColor = [UIColor appGray];
        
        self.distanceLabel = [UILabel newAutoLayoutView];
        [self.whiteView addSubview:self.distanceLabel];
        self.distanceLabel.font = [UIFont fontOpenSansRegularWithSize:13];
        self.distanceLabel.text = @"12 km away ";
        self.distanceLabel.textColor = [UIColor appRed];
        
        self.nrOfCommentsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.nrOfCommentsBtn];
        self.nrOfCommentsBtn.tintColor = [UIColor blackColor];
        
        self.addCommentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.addCommentBtn];
        self.addCommentBtn.tintColor = [UIColor blackColor];
        [self.addCommentBtn setImage:[UIImage imageNamed:@"commentsIcon"] forState:UIControlStateNormal];

        self.separationView = [UIView newAutoLayoutView];
        [self addSubview:self.separationView];
        self.separationView.backgroundColor = [UIColor appGray];
        
        self.firstCommentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.firstCommentBtn];
        self.firstCommentBtn.tintColor = [UIColor blackColor];
        [self.firstCommentBtn setImage:[UIImage imageNamed:@"firstCommentBtn"] forState:UIControlStateNormal];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"dd/MM HH:mm "];
        
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self updateConstraintsIfNeeded];
    }
    
    return self;
}

- (void)updateConstraints {
    
    [super updateConstraints];
    
    [self.whiteView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:kMargin];
    [self.whiteView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:kMargin];
    [self.whiteView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-kMargin];
    [self.whiteView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-kMargin];
    
    [self.circleView autoSetDimensionsToSize:CGSizeMake(kCircleSize, kCircleSize)];
    [self.circleView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.whiteView withOffset:2*kMargin];
    [self.circleView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.whiteView withOffset:2*kDistance];
    
    [self.circleLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.circleView];
    [self.circleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.circleView withOffset:2.0];
    
    [self.providerNameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.circleView withOffset:kDistance];
    [self.providerNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.whiteView withOffset:2*kDistance];
    
    [self.titleLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.providerNameLabel];
    [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.providerNameLabel];
    
    [self.readMoreBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.circleView withOffset:3*kMargin];
    [self.readMoreBtn autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.whiteView withOffset:-kDistance];
    [self.readMoreBtn autoSetDimension:ALDimensionWidth toSize:70];
    [self.readMoreBtn autoSetDimension:ALDimensionHeight toSize:20];
    
    [self.descriptionLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.readMoreBtn];
    [self.descriptionLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.whiteView withOffset:kDistance];
    [self.descriptionLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.readMoreBtn];
    
    [self.activityImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.descriptionLabel withOffset:3*kMargin];
    [self.activityImageView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.whiteView withOffset:kDistance];
    
    [self.activityIndicator autoCenterInSuperview];
    
    [self.activityImageView autoSetDimension:ALDimensionWidth toSize:screenWidth() - 2*kMargin - 2*kDistance];
    [self.activityImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.activityImageView withMultiplier:0.75];
    
    [self.startDateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.activityImageView withOffset:3*kMargin];
    [self.startDateLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.activityImageView];
    
    [self.finishDateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.startDateLabel];
    [self.finishDateLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.activityImageView];
    
    [self.meetingBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.activityImageView withOffset:4*kMargin];
    [self.meetingBtn autoAlignAxis:ALAxisVertical toSameAxisOfView:self.whiteView withOffset:3*kMargin];
    
    [self.meetingLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.meetingBtn withOffset:kMargin];
    [self.meetingLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.meetingBtn withOffset:-kMargin];
    
    [self.distanceLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.meetingBtn withOffset:kMargin];
    [self.distanceLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.meetingBtn withOffset:kMargin];
    
    [self.separationView autoSetDimensionsToSize:CGSizeMake(1, 32)];
    [self.separationView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.finishDateLabel withOffset:2*kDistance];
    [self.separationView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.whiteView];
    [self.separationView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.whiteView];
    
    [self.nrOfCommentsBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.whiteView];
    [self.nrOfCommentsBtn autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.separationView];
    [self.nrOfCommentsBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.separationView];
    
    [self.addCommentBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nrOfCommentsBtn];
    [self.addCommentBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.nrOfCommentsBtn];
    [self.addCommentBtn autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.whiteView];
    [self.addCommentBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.separationView];
    
    [self.firstCommentBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.whiteView];
    [self.firstCommentBtn autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.whiteView];
    [self.firstCommentBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.separationView];
    
    [self.nrOfCommentsBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.whiteView withOffset:-2*kMargin];
}

- (void)setCellForActivity:(MyActivity *)activity {
    
    self.titleLabel.text        = activity.title;
    self.providerNameLabel.text = activity.providerName;
    self.descriptionLabel.text  = activity.activityDescription;
    self.circleLabel.text       = activity.providerInitials;
    
    [self.activityIndicator startAnimating];
    @weakify(self)
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:activity.photoFileUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.activityIndicator stopAnimating];
    }];
    
    if (activity.commentsCount) {
        self.nrOfCommentsBtn.hidden = NO;
        self.addCommentBtn.hidden   = NO;
        self.separationView.hidden  = NO;
        self.firstCommentBtn.hidden = YES;
        [self setNrOfComments:activity.commentsCount];
    }
    else {
        self.nrOfCommentsBtn.hidden = YES;
        self.addCommentBtn.hidden   = YES;
        self.separationView.hidden  = YES;
        self.firstCommentBtn.hidden = NO;
    }
    
    NSString *startDateString = [NSString stringWithFormat:@"%@ %@",[self dayCalculationForDate:activity.startTime], [self.dateFormatter stringFromDate:activity.startTime]];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:startDateString];
    NSRange range = [startDateString rangeOfString:@" "];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor appRed] range:NSMakeRange(0, range.location)];
    
    self.startDateLabel.attributedText = attrString;
    
    if ( ! [activity.finishTime isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
        self.finishDateLabel.hidden = NO;
        
        NSString *finishDateString = [NSString stringWithFormat:@"Until : %@ %@",[self dayCalculationForDate:activity.finishTime], [self.dateFormatter stringFromDate:activity.finishTime]];
        
        self.finishDateLabel.text = finishDateString;
    }
    else {
        self.finishDateLabel.hidden = YES;
    }
    
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.0f km away", activity.distance]];
    
    //NSLog(@"Distanta e %f", activity.distance);
}

- (void)setNrOfComments:(NSInteger)nrOfComments {
    
    NSString *commString;
    
    commString = nrOfComments == 1 ? @"Comment" : @"Comments";
    
    NSString *workingString = [NSString stringWithFormat:@"%ld %@", (long)nrOfComments, commString];
    
    NSMutableAttributedString *nrOfCommentsString = [[NSMutableAttributedString alloc] initWithString:workingString];
    [nrOfCommentsString addAttribute:NSFontAttributeName value:[UIFont fontOpenSansBoldWithSize:14] range:NSMakeRange(0, [nrOfCommentsString length])];
    NSRange commentsRange = [workingString rangeOfString:commString];
    
    [nrOfCommentsString addAttribute:NSFontAttributeName value:[UIFont fontOpenSansRegularWithSize:14] range:commentsRange];
    [self.nrOfCommentsBtn setAttributedTitle:nrOfCommentsString forState:UIControlStateNormal];
}

- (NSString *)dayCalculationForDate:(NSDate *)date {
    
    NSDateComponents *components = [self.calendar components:NSCalendarUnitDay
                                                    fromDate:date
                                                      toDate:[NSDate date]
                                                     options:NSCalendarWrapComponents];
    
    NSInteger nrOfDays = [components day];
    
    if (nrOfDays == 1) {
        return @"Yesterday";
    }
    else if (nrOfDays == 0) {
        return @"Today";
    }
    else if (nrOfDays == -1) {
        return @"Tomorrow";
    }
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE"];
        return [dateFormatter stringFromDate:date];
    }
}

@end
