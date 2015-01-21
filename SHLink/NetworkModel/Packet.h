//
//  Packet.h
//  SHLink
//
//  Created by 钱凯 on 15/1/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#ifndef SHLink_Packet_h
#define SHLink_Packet_h

#import <Foundation/Foundation.h>

#define _UINT8          unsigned char

#define VERSION_LEN     4
#define TYPE_LEN        4
#define MAC_LEN         8
#define IP_LEN          4
#define MASK_LEN        4
#define DESC_LEN        32
#define RESE_LEN        4
#define USER_ID_LEN     16
#define CHALLENGE_LEN   16
#define LEN_LEN         4
#define STATS_LEN       4

#define SHPacketType_Detect         0x00000100
#define SHPacketType_DetectReply    0x00000101
#define SHPacketType_Challenge      0x00000200
#define SHPacketType_ChallengeReply 0x00000201
#define SHPacketType_Control        0x00000300
#define SHPacketType_ControlReply   0x00000301


typedef NS_ENUM(NSUInteger, SHRequestType) {
    SHRequestType_getClientList = 1,
    SHRequestType_setSsid = 2,
    SHRequestType_setWan = 3,
    SHRequestType_setLan = 4,
    SHRequestType_getNetworkInfo = 5,
    SHRequestType_setAccount = 6,
    SHRequestType_checkFirmwareUpdate = 7,
    SHRequestType_updateFirmware = 8,
    SHRequestType_getFirmwareLog = 9,
    SHRequestType_getWlanSchedule = 10,
    SHRequestType_powerOff = 12,
};


#pragma pack(1)

/**
 *  Common header
 */
typedef struct SHHeader {
    _UINT8 version[VERSION_LEN];
    _UINT8 type[TYPE_LEN];
} _SHHeader;

/**
 *  UDP detect packet on port 10245
 */
typedef struct SHDetect {
    _SHHeader header;
} _SHDetect;

/**
 *  UDP detect reply packet
 */
typedef struct SHDetectReply {
    _SHHeader header;
    _UINT8 mac[MAC_LEN];
    _UINT8 ip[IP_LEN];
    _UINT8 mask[MASK_LEN];
    _UINT8 description[DESC_LEN];
} _SHDetectReply;

/**
 *  TCP challenge packet on port 10246
 */
typedef struct SHChallenge {
    _SHHeader header;
    _UINT8 reserve[RESE_LEN];
    _UINT8 userId[USER_ID_LEN];
    _UINT8 challenge[CHALLENGE_LEN];
    _UINT8 length[LEN_LEN];
    _UINT8 content[0];
} _SHChallenge;

/**
 *  TCP challenge reply packet
 */
typedef struct SHChallengeReply {
    _SHHeader header;
    _UINT8 reserve[RESE_LEN];
    _UINT8 status[STATS_LEN];
    _UINT8 length[LEN_LEN];
    _UINT8 content[0];
} _SHChallengeReply;

/**
 *  Device control packet
 */
typedef struct SHChallenge _SHControl;

/**
 *  Device control relay packet
 */
typedef struct SHChallengeReply _SHControlRely;

#pragma pack()



#endif
