# Grid Reference
Three Garmin Connect IQ apps that show the GB Ordnance Survey Grid Reference of the current GPS position.

The three variants are a Simple Data Field, a Data Field and a Widget.
They are all based on the same calculation code which is a cut-down version of the JavaScript written by Chris Veness, available at https://www.movable-type.co.uk/scripts/latlong-os-gridref.html and https://github.com/chrisveness/geodesy. It's well worth looking at his pages to get a fuller understanding of what's going on!

I have put the calculation class in a separate source file that's shared between the 3 apps. It could be used to make a monkey barrel but I found that tricky for debugging and testing, so I just use the source directly. The monkey.jungle files specify where it's found.

The apps are available from the Garmin Connect IQ Store.
Widget: https://apps.garmin.com/en-US/apps/10473162-3729-40e9-9a72-b7c16528c758
Simple Data Field: https://apps.garmin.com/en-US/apps/d56ff2c7-98d6-4390-8e99-4c844f1f32d1
Data Field: https://apps.garmin.com/en-US/apps/3b19825b-2021-44e2-81f7-62c87877a456

The icon was made by Pixel Buddha from flaticon (https://www.flaticon.com/authors/pixel-buddha) licensed by CC BY 3.0 (https://creativecommons.org/licenses/by/3.0).

