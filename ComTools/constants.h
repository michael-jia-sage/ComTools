//
//  constants.h
//  ComTools
//
//  Created by Zonggao Jia on 2015-11-01.
//  Copyright © 2015 Zonggao Jia. All rights reserved.
//

#ifndef constants_h
#define constants_h

#define themeColor @"#16c9d8"
#define bgColor @"#efeff4"
#define grayColor @"#d1d1d0"
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define temperature_format @"\u00B0F = \u00B0C X 1.8 + 32 \r\u00B0C = (\u00B0F - 32) X 5/9"
#define gas_price_format @"1 gal = 3.78541 litre \r1 us$ = %0.2f ca$"

#define aboutMessage @"<html><body style=\"margin:2 auto;text-left;background-color: transparent; color:white\"><p>CTooies has grouped a number of daily using referencing tools, such as unit converter, tip calculator, currency converter, etc. CTooies features great usability, fast responding and friendly interaction. CTooies is targeted to be a frequently used app in daily lifes.</p><p><strong>CTooies</strong> has same pronunciation as French word 'citrouille' ('pumpkin') -- learned from my daughter. This app is dedicated to my dear wife and lovely daughter. They are contributing as consultants, designers, testers, and 100% supporters.</p><p>Web -- www.groupmaster.biz</p><p>Email -- info@groupmaster.biz</p></body></html>"

#endif /* constants_h */
