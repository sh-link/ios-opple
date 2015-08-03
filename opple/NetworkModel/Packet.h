//
//  Packet.h
//  SHLink
//
//  Created by 钱凯 on 15/1/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#ifndef SHLink_Packet_h
#define SHLink_Packet_h

#define _UINT8          unsigned char
 //请求及响应头部想着字段
#define VERSION_LEN     4
#define TYPE_LEN        4
#define MAC_LEN         8
#define IP_LEN          4
#define MASK_LEN        4
#define DESC_LEN        32
#define RESE_LEN        4
#define USER_ID_LEN     16
#define CHALLENGE_LEN   8
#define LEN_LEN         4
#define STATS_LEN       4

#define SHPacketType_Detect         0x00000100
#define SHPacketType_DetectReply    0x00000101
#define SHPacketType_Challenge      0x00000200
#define SHPacketType_ChallengeReply 0x00000201
#define SHPacketType_Control        0x00000300
#define SHPacketType_ControlReply   0x00000301
//请求类型
#define SHRequestType_GetClientList         501
#define SHRequestType_SetSsid               502
#define SHRequestType_SetWan                503
#define SHRequestType_SetLan                504
#define SHRequestType_GetNetworkInfo        505
#define SHRequestType_SetAccount            506
#define SHRequestType_CheckFirmwareUpdate   507
#define SHRequestType_UpdateFirmware        508
#define SHRequestType_GetFirmwareLog        509
#define SHRequestType_SetWlanSchedule       510
#define SHRequestType_GetWifiClockInfo      511
#define SHRequestType_PowerOff              512
#define SHRequestType_GetSlaveList          513
#define SHRequestType_GetTerminalWithMac    514
#define SHRequestType_GetWanInfo            515
#define SHRequestType_SetClientName         516
#define SHRequestType_SetPanrentControlInfo 517
#define SHRequestType_getParentControlInfo 518
#define SHRequestType_AddOrDeleteParentControl 519
//获取上网方式
#define SHRequestType_GetOnlineWay 520
//获取工作模式信息
#define SHRequestType_GetWorkMode 521
//备份的恢复
#define SHRequestType_BackupOrRestore 522
//获取无线信息列表
#define SHRequestType_GetWifiList 523
//恢复出厂设置
#define SHRequestType_GoToFactory 524
//关闭wifi
#define SHRequestType_CloseWifi 525

//返回的status字段
#define SHControlStatus_Success  0
#define SHControlStatus_UserNotExist  3
#define SHControlStatus_WrongPsw  4
#define SHControlStatus_Failed  5


#define PACKET_CHECK_VERSION(_version, _packet) (*(int *)(((_SHHeader *)(_packet))->version) == htonl(_version))
#define PACKET_CHECK_TYPE(_type, _packet) (*(int *)(((_SHHeader *)(_packet))->type) == htonl(_type))

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
    _UINT8 mask[4];
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
