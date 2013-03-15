//
//  TestViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "IcalTestViewController.h"

#import "IcalCalenderClient.h"

@implementation IcalTestViewController {
	NSArray* _events;
	EKEventStore *eventStore;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	eventStore = nil;
	[self requestAccessToCalendar:^(BOOL granted, NSError *error) {
		if (granted) {
			[self didGetAccessToCalendar];
		} else {
			// no permissions to access calendars
			NSLog(@"Error: %@", error);
		}
	}];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/**
 Request permissions to the calendar
 */
- (void)requestAccessToCalendar:(void (^)(BOOL granted, NSError *error))callback; {
    if (eventStore == nil) {
        eventStore = [[EKEventStore alloc] init];
    }

	// request permissions
	if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
		// iOS 6 and later
		[eventStore requestAccessToEntityType:EKEntityTypeEvent completion:callback];
	} else {
		// iOS 5
		callback(FALSE, NULL);
	}
}

/**
 Permissions to the calendar permitted
 */
- (void)didGetAccessToCalendar {
	IcalCalenderClient* icalCalenderClient = [[IcalCalenderClient alloc] init];

	[icalCalenderClient allWithSuccess:^(AFHTTPRequestOperation* operation, NSArray* events) {

		_events = events;
		[self.tableView reloadData];

	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	
	EKEvent* event = [_events objectAtIndex:indexPath.row];
	cell.textLabel.text = event.title;

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd.MM.yyyy"];
	cell.detailTextLabel.text = [dateFormatter stringFromDate:event.startDate];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
