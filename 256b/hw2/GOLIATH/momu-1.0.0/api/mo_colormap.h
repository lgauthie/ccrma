/*----------------------------------------------------------------------------
  MoMu: A Mobile Music Toolkit
  Copyright (c) 2010 Nicholas J. Bryan, Jorge Herrera, Jieun Oh, and Ge Wang
  All rights reserved.
    http://momu.stanford.edu/toolkit/
 
  Mobile Music Research @ CCRMA
  Music, Computing, Design Group
  Stanford University
    http://momu.stanford.edu/
    http://ccrma.stanford.edu/groups/mcd/
 
 MoMu is distributed under the following BSD style open source license:
 
 Permission is hereby granted, free of charge, to any person obtaining a 
 copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The authors encourage users of MoMu to include this copyright notice,
 and to let us know that you are using MoMu. Any person wishing to 
 distribute modifications to the Software is encouraged to send the 
 modifications to the original authors so that they can be incorporated 
 into the canonical version.
 
 The Software is provided "as is", WITHOUT ANY WARRANTY, express or implied,
 including but not limited to the warranties of MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE and NONINFRINGEMENT.  In no event shall the authors
 or copyright holders by liable for any claim, damages, or other liability,
 whether in an actino of a contract, tort or otherwise, arising from, out of
 or in connection with the Software or the use or other dealings in the 
 software.
 -----------------------------------------------------------------------------*/
//-----------------------------------------------------------------------------
// name: mo_colormap.h
// desc: MoPhO API for color map/graphics routines
//
// authors: Nick Bryan (njb@ccrma.stanford.edu)
//          Ge Wang
//
//    date: Fall 2009
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#ifndef __MO_COLORMAP_H__
#define __MO_COLORMAP_H__

#import <string>
#import <map>

using namespace std;

// see http://cloford.com/resources/colours/500col.htm for the colors
// only indianred changed to indianred0 because there were two indianred

enum colorName 
{ 
    indianred0,
    crimson,
    lightpink,
    lightpink1,
    lightpink2,
    lightpink3,
    lightpink4,
    pink,
    pink1,
    pink2,
    pink3,
    pink4,
    palevioletred,
    palevioletred1,
    palevioletred2,
    palevioletred3,
    palevioletred4,
    lavenderblush1,
    lavenderblush2,
    lavenderblush3,
    lavenderblush4,
    violetred1,
    violetred2,
    violetred3,
    violetred4,
    hotpink,
    hotpink1,
    hotpink2,
    hotpink3,
    hotpink4,
    raspberry,
    deeppink1,
    deeppink2,
    deeppink3,
    deeppink4,
    maroon1,
    maroon2,
    maroon3,
    maroon4,
    mediumvioletred,
    violetred,
    orchid,
    orchid1,
    orchid2,
    orchid3,
    orchid4,
    thistle,
    thistle1,
    thistle2,
    thistle3,
    thistle4,
    plum1,
    plum2,
    plum3,
    plum4,
    plum,
    violet,
    magenta,
    magenta2,
    magenta3,
    magenta4,
    purple,
    mediumorchid,
    mediumorchid1,
    mediumorchid2,
    mediumorchid3,
    mediumorchid4,
    darkviolet,
    darkorchid,
    darkorchid1,
    darkorchid2,
    darkorchid3,
    darkorchid4,
    indigo,
    blueviolet,
    purple1,
    purple2,
    purple3,
    purple4,
    mediumpurple,
    mediumpurple1,
    mediumpurple2,
    mediumpurple3,
    mediumpurple4,
    darkslateblue,
    lightslateblue,
    mediumslateblue,
    slateblue,
    slateblue1,
    slateblue2,
    slateblue3,
    slateblue4,
    ghostwhite,
    lavender,
    blue,
    blue2,
    blue3,
    blue4,
    navy,
    midnightblue,
    cobalt,
    royalblue,
    royalblue1,
    royalblue2,
    royalblue3,
    royalblue4,
    cornflowerblue,
    lightsteelblue,
    lightsteelblue1,
    lightsteelblue2,
    lightsteelblue3,
    lightsteelblue4,
    lightslategray,
    slategray,
    slategray1,
    slategray2,
    slategray3,
    slategray4,
    dodgerblue1,
    dodgerblue2,
    dodgerblue3,
    dodgerblue4,
    aliceblue,
    steelblue,
    steelblue1,
    steelblue2,
    steelblue3,
    steelblue4,
    lightskyblue,
    lightskyblue1,
    lightskyblue2,
    lightskyblue3,
    lightskyblue4,
    skyblue1,
    skyblue2,
    skyblue3,
    skyblue4,
    skyblue,
    deepskyblue1,
    deepskyblue2,
    deepskyblue3,
    deepskyblue4,
    peacock,
    lightblue,
    lightblue1,
    lightblue2,
    lightblue3,
    lightblue4,
    powderblue,
    cadetblue1,
    cadetblue2,
    cadetblue3,
    cadetblue4,
    turquoise1,
    turquoise2,
    turquoise3,
    turquoise4,
    cadetblue,
    darkturquoise,
    azure1,
    azure2,
    azure3,
    azure4,
    lightcyan1,
    lightcyan2,
    lightcyan3,
    lightcyan4,
    paleturquoise1,
    paleturquoise2,
    paleturquoise3,
    paleturquoise4,
    darkslategray,
    darkslategray1,
    darkslategray2,
    darkslategray3,
    darkslategray4,
    cyan,
    cyan2,
    cyan3,
    cyan4,
    teal,
    mediumturquoise,
    lightseagreen,
    manganeseblue,
    turquoise,
    coldgrey,
    turquoiseblue,
    aquamarine1,
    aquamarine2,
    aquamarine3,
    aquamarine4,
    mediumspringgreen,
    mintcream,
    springgreen,
    springgreen1,
    springgreen2,
    springgreen3,
    mediumseagreen,
    seagreen1,
    seagreen2,
    seagreen3,
    seagreen4,
    emeraldgreen,
    mint,
    cobaltgreen,
    honeydew1,
    honeydew2,
    honeydew3,
    honeydew4,
    darkseagreen,
    darkseagreen1,
    darkseagreen2,
    darkseagreen3,
    darkseagreen4,
    palegreen,
    palegreen1,
    palegreen2,
    palegreen3,
    palegreen4,
    limegreen,
    forestgreen,
    green1,
    green2,
    green3,
    green4,
    green,
    darkgreen,
    sapgreen,
    lawngreen,
    chartreuse1,
    chartreuse2,
    chartreuse3,
    chartreuse4,
    greenyellow,
    darkolivegreen1,
    darkolivegreen2,
    darkolivegreen3,
    darkolivegreen4,
    darkolivegreen,
    olivedrab,
    olivedrab1,
    olivedrab2,
    olivedrab3,
    olivedrab4,
    ivory1,
    ivory2,
    ivory3,
    ivory4,
    beige,
    lightyellow1,
    lightyellow2,
    lightyellow3,
    lightyellow4,
    lightgoldenrodyellow,
    yellow1,
    yellow2,
    yellow3,
    yellow4,
    warmgrey,
    olive,
    darkkhaki,
    khaki1,
    khaki2,
    khaki3,
    khaki4,
    khaki,
    palegoldenrod,
    lemonchiffon1,
    lemonchiffon2,
    lemonchiffon3,
    lemonchiffon4,
    lightgoldenrod1,
    lightgoldenrod2,
    lightgoldenrod3,
    lightgoldenrod4,
    banana,
    gold1,
    gold2,
    gold3,
    gold4,
    cornsilk1,
    cornsilk2,
    cornsilk3,
    cornsilk4,
    goldenrod,
    goldenrod1,
    goldenrod2,
    goldenrod3,
    goldenrod4,
    darkgoldenrod,
    darkgoldenrod1,
    darkgoldenrod2,
    darkgoldenrod3,
    darkgoldenrod4,
    orange1,
    orange2,
    orange3,
    orange4,
    floralwhite,
    oldlace,
    wheat,
    wheat1,
    wheat2,
    wheat3,
    wheat4,
    moccasin,
    papayawhip,
    blanchedalmond,
    navajowhite1,
    navajowhite2,
    navajowhite3,
    navajowhite4,
    eggshell,
    tanN,
    brick,
    cadmiumyellow,
    antiquewhite,
    antiquewhite1,
    antiquewhite2,
    antiquewhite3,
    antiquewhite4,
    burlywood,
    burlywood1,
    burlywood2,
    burlywood3,
    burlywood4,
    bisque1,
    bisque2,
    bisque3,
    bisque4,
    melon,
    carrot,
    darkorange,
    darkorange1,
    darkorange2,
    darkorange3,
    darkorange4,
    orange,
    tan1,
    tan2,
    tan3,
    tan4,
    linen,
    peachpuff1,
    peachpuff2,
    peachpuff3,
    peachpuff4,
    seashell1,
    seashell2,
    seashell3,
    seashell4,
    sandybrown,
    rawsienna,
    chocolate,
    chocolate1,
    chocolate2,
    chocolate3,
    chocolate4,
    ivoryblack,
    flesh,
    cadmiumorange,
    burntsienna,
    sienna,
    sienna1,
    sienna2,
    sienna3,
    sienna4,
    lightsalmon1,
    lightsalmon2,
    lightsalmon3,
    lightsalmon4,
    coral,
    orangered1,
    orangered2,
    orangered3,
    orangered4,
    sepia,
    darksalmon,
    salmon1,
    salmon2,
    salmon3,
    salmon4,
    coral1,
    coral2,
    coral3,
    coral4,
    burntumber,
    tomato1,
    tomato2,
    tomato3,
    tomato4,
    salmon,
    mistyrose1,
    mistyrose2,
    mistyrose3,
    mistyrose4,
    snow1,
    snow2,
    snow3,
    snow4,
    rosybrown,
    rosybrown1,
    rosybrown2,
    rosybrown3,
    rosybrown4,
    lightcoral,
    indianred,
    indianred1,
    indianred2,
    indianred4,
    indianred3,
    brown,
    brown1,
    brown2,
    brown3,
    brown4,
    firebrick,
    firebrick1,
    firebrick2,
    firebrick3,
    firebrick4,
    red1,
    red2,
    red3,
    red4,
    maroon,
    sgibeet,
    sgislateblue,
    sgilightblue,
    sgiteal,
    sgichartreuse,
    sgiolivedrab,
    sgibrightgray,
    sgisalmon,
    sgidarkgray,
    sgigray12,
    sgigray16,
    sgigray32,
    sgigray36,
    sgigray52,
    sgigray56,
    sgilightgray,
    sgigray72,
    sgigray76,
    sgigray92,
    sgigray96,
    white,
    whitesmoke,
    gainsboro,
    lightgrey,
    silver,
    darkgray,
    gray,
    dimgray,
    black,
    gray99,
    gray98,
    gray97,
    gray95,
    gray94,
    gray93,
    gray92,
    gray91,
    gray90,
    gray89,
    gray88,
    gray87,
    gray86,
    gray85,
    gray84,
    gray83,
    gray82,
    gray81,
    gray80,
    gray79,
    gray78,
    gray77,
    gray76,
    gray75,
    gray74,
    gray73,
    gray72,
    gray71,
    gray70,
    gray69,
    gray68,
    gray67,
    gray66,
    gray65,
    gray64,
    gray63,
    gray62,
    gray61,
    gray60,
    gray59,
    gray58,
    gray57,
    gray56,
    gray55,
    gray54,
    gray53,
    gray52,
    gray51,
    gray50,
    gray49,
    gray48,
    gray47,
    gray46,
    gray45,
    gray44,
    gray43,
    gray42,
    dimgay,
    gray40,
    gray39,
    gray38,
    gray37,
    gray36,
    gray35,
    gray34,
    gray33,
    gray32,
    gray31,
    gray30,
    gray29,
    gray28,
    gray27,
    gray26,
    gray25,
    gray24,
    gray23,
    gray22,
    gray21,
    gray20,
    gray19,
    gray18,
    gray17,
    gray16,
    gray15,
    gray14,
    gray13,
    gray12,
    gray11,
    gray10,
    gray9,
    gray8,
    gray7,
    gray6,
    gray5,
    gray4,
    gray3,
    gray2,
    gray1
};


// hold the color values together
class Color
{
public:
    // constructors
    Color();
    Color( double red, double green, double blue );
    Color( double red, double green, double blue, double alpha );
    
    // setters
    void setRGBA( double red, double green, double blue, double alpha );
    void setRGB( double red, double green, double blue );

public:
    double r, g, b, a;
};


class ColorMap
{
public:
    // get the color as an object
    static Color getColor(string input);

    // get the color by reference for each color field
    static void  getColor(string input, float & red, float & green, float & blue );
    
private:
    // map to associate the strings with the enum values
    static map <string, colorName> m_colorMap;
    
    // holder for the initialization
    static int isInit;
    
    // intialization
    static int init();        
};



#endif
