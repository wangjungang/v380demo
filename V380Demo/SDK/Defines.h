//
//  Defines.h
//  iCamSee
//
//  Created by macrovideo on 15/10/19.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#ifndef Defines_h
#define Defines_h
enum{
    VERIFY_DEVICE_ID_ERR=-2,	//设备ID错误
    VERIFY_FAILED=-1,	//校验失败
    USER_NOT_EXIST=0,	//用户不存在
    PWD_ERROR=1,		//密码错误
    NO_PRI=2,			//权限不足
    AUDIO_PRI=4,			//权限不足
    CTRL_PRI=8,			//云台控制
    PLAYBACK_PRI=16,	//录像回放
    RECEIVE_PRI=32,		//远程接收
    SPEAK_PRI=64//远程对讲
};


typedef enum//÷°¿‡–ÕFrameType
{
    FRAMETYPE_I 		= 0,		//I÷°
    FRAMETYPE_P 		= 1,		//P÷°
    SUBFRAMETYPE_I 		= 2,		//SubStream I÷° ◊¢“‚ Frametype ∂®“Â”Î NV7000SDK.dll÷–µƒ∂®“Â≤ªÕ¨
    SUBFRAMETYPE_P 		= 3,		//SubStream P÷°
    FRAMETYPE_MP2		= 4,		//MPEG-1 Layer2“Ù∆µ÷°
    FRAMETYPE_ULAWPCM 	= 5,		//u-LAW PCM“Ù∆µ÷°
    FRAMETYPE_B			= 6,
    SUBFRAMETYPE_B		= 7,
    FRAMETYPE_MD		= 8,		//“∆∂Ø’Ï≤‚÷°
    FRAMETYPE_JPEG      = 9,     //¿©’π÷ß≥÷MotionJPEG FrameType
    FRAMETYPE_SYSHEADER = 16,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_PCM = 21,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_ADPCM = 22,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_MP3 = 23,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_AAC = 24,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_MPEG4_I = 36,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_MPEG4_P = 37,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_H265_I = 40,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_H265_P = 41,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_H264_TIME_I = 50,		//œµÕ≥–≈œ¢÷°
    FRAMETYPE_H264_TIME_P = 51,		//œµÕ≥–≈œ¢÷°
} PACKET_TYPE;


enum//
{
    DOWNREQUEST=100,
    STOPDOWN=101,
    UPLOADQUEST=102,
    STOPUPLOAD=103,
    FILESTART=110,
    FILEDATAEND=111,
    FILEDATA=112,
    FILEERROR=113,
    USERVERIFY=167,
    USERVERIFYRESULT=168,
    USERVERIFYRESULTMR=169,
    TESTCONNECTION=222,
    DISCONNECT=253,
    CUSTOMBUF=254
};

//add by lusongbin
#define USERVERIFY_EX 1167
#define USERVERIFYRESULTE_X 1168
//end add by lusongbin

#define DATA_BUF_LENGTH 512
#define PACKET_BUF_LENGTH 520 //512+4+4
#define PACKET_BUF_SEND_LENGTH 256 //512+4+4

#define MAX_RECV_BUF_LEN 2048
#define CMDSIZE 128

#define REFRESH_HEADER_HEIGHT 70.0f
#define BROCAST_PORT_SEND 10008
#define BROCAST_PORT_RECV 10009
#define UDP_PORT 4000



//add by luo 20150106
#define CAM_IMAGE_REVERSE_PRI 1
//#define CAM__PRI 2
#define CAM_SPEAK_PRI 4
#define CAM_PTZ_PRI 8
//#define CAM__PRI 16
//#define CAM__PRI 32
//end add by luo 20150106
#endif /* Defines_h */

#define VALUE_DISBLE 0
#define VALUE_ENABLE 1

//µ«¬Ω∫ÕΩ” ’◊™∑¢∑˛ŒÒ∆˜µƒ÷∏¡Ó
#define CMD_MR_LOGIN 1001
#define CMD_MR_LOGIN_RESPONSE 2001
#define CMD_MR_PLAY 1002
#define CMD_MR_PLAY_RESPONSE 2002
#define CMD_MR_GET_IMAGE 1003

//Ω·π˚÷µ
#define CMD_MR_OK 100
#define CMD_MR_FAIL 101

// ÷ª˙¿‡–Õ∂®“Â
#define PHONE_TYPE_IOS 1001
#define PHONE_TYPE_ANDROID 1002
#define PHONE_TYPE_WP8 1003


//add by luo 20151204
#define ZONE_AUTO 0  //自动
#define ZONE_CHINA 1 //中国大陆
#define ZONE_AS1 2   //亚洲1区
#define ZONE_AS2 3  //亚洲2区
#define ZONE_AS3 4  //亚洲3区
#define ZONE_AS4 5  //亚洲4区
#define ZONE_NA1 6  //北美
#define ZONE_SA1 7  //南美
#define ZONE_EU1 8  //欧洲1区
#define ZONE_EU2 9  //欧洲2区
#define ZONE_OA1 10 //大洋洲
#define ZONE_AF1 11 //非洲1区
#define ZONE_AF2 12 //非洲2区

typedef struct _tagDomainIPMAP{
    bool isInitRS1;
    char pIPRS1[20];
    bool isInitRS2;
    char pIPRS2[20];
    bool isInitRS3;
    char pIPRS3[20];
    
    //
    bool isInitENRS1;
    char pIPENRS1[20];
    bool isInitENRS2;
    char pIPENRS2[20];
    bool isInitENRS3;
    char pIPENRS3[20];
    
    //
    bool isInitAS1;
    char pIPAS1[20];
    bool isInitAS2;
    char pIPAS2[20];
    bool isInitAS3;
    char pIPAS3[20];
    bool isInitAS4;
    char pIPAS4[20];
    
    bool isInitNA1;
    char pIPNA1[20];
    bool isInitSA1;
    char pIPSA1[20];
    
    bool isInitEU1;
    char pIPEU1[20];
    bool isInitEU2;
    char pIPEU2[20];
    
    bool isInitOA1;
    char pIPOA1[20];
    
    bool isInitAF1;
    char pIPAF1[20];
    bool isInitAF2;
    char pIPAF2[20];
    
}DOMAIN_IP_MAP, *PDOMAIN_IP_MAP;

#define MR_SERVER_AS105 "vri1.av380.net"
#define MR_SERVER_AS30 "vri2.av380.net"
#define MR_SERVER_AS34 "vri3.av380.net"

//
#define MR_SERVER_IP105 "42.96.171.222"
#define MR_SERVER_IP30 "120.26.209.166"
#define MR_SERVER_IP34 "121.42.39.129"


#define MR_SERVER_RS1 "is581.nvcam.net"
#define MR_SERVER_RS2 "is582.nvcam.net"
#define MR_SERVER_RS3 "is583.nvcam.net"

//
#define MR_SERVER_IP1 "120.26.209.166"//modify 20161122 as30
#define MR_SERVER_IP2 "121.42.39.129"//modify 20161122 as34
#define MR_SERVER_IP3 "115.28.131.189"


#define EN_MR_SERVER_RS1 "hk1.nvcam.net"
#define EN_MR_SERVER_RS2 "hk2.nvcam.net"
#define EN_MR_SERVER_RS3 "hk3.nvcam.net"

#define EN_MR_SERVER_IP1 "47.90.0.159"
#define EN_MR_SERVER_IP2 "47.88.0.218"
#define EN_MR_SERVER_IP3 "47.90.0.159"

#define MR_SERVER_AS1 "zoneas1.nvcam.net"//亚洲1 (日本，韩国，台湾，香港，泰国，越南)
#define MR_SERVER_AS2 "zoneas2.nvcam.net"//亚洲2 (马来西亚,新加坡)
#define MR_SERVER_AS3 "zoneas3.nvcam.net"//亚洲3 (西亚)
#define MR_SERVER_AS4 "zoneas4.nvcam.net"//亚洲4 (日本，韩国，台湾，香港，泰国，越南)

#define MR_SERVER_NA1 "zonena1.nvcam.net"//北美
#define MR_SERVER_SA1 "zonesa1.nvcam.net"//南美

#define MR_SERVER_EU1 "zoneeu1.nvcam.net"//欧洲1
#define MR_SERVER_EU2 "zoneeu2.nvcam.net"//欧洲2

#define MR_SERVER_OA1 "zoneOa1.nvcam.net"//澳大利亚,新西兰

#define MR_SERVER_AF1 "zoneaf1.nvcam.net"//非洲1
#define MR_SERVER_AF2 "zoneaf2.nvcam.net"//非洲2

#define EN_MR_SERVER_IPSGP "47.90.0.159"
#define EN_MR_SERVER_IPHK "47.88.0.218"
#define EN_MR_SERVER_IPAM "47.90.0.159"

//#define MR_SERVER_RS1 "115.28.54.85"
//#define MR_SERVER_RS2 "115.28.54.85"
//#define MR_SERVER_RS3 "115.28.54.85"
//
//#define MR_SERVER_IP1 "115.28.54.85"
//#define MR_SERVER_IP2 "115.28.54.85"
//#define MR_SERVER_IP3 "115.28.54.85"

//#define EN_MR_SERVER_RS1 "hk1.nvcam.net"
//#define EN_MR_SERVER_RS2 "hk2.nvcam.net"
//#define EN_MR_SERVER_RS3 "hk3.nvcam.net"
//
//#define EN_MR_SERVER_IP1 "47.90.0.159"
//#define EN_MR_SERVER_IP2 "47.88.0.218"
//#define EN_MR_SERVER_IP3 "47.90.0.159"



#define VERIFY_RESULT_OK 1001
#define VERIFY_RESULT_FAIL 1002

#define VERIFY_DES_OLD_VERSION -11
#define VERIFY_DES_ERROR -1
#define VERIFY_DES_UDPMAKEHOLESUCCEED_NOREPLY -2
#define VERIFY_DES_SOCK5CONNECTSUCCEED_NOREPLY -3
#define VERIFY_DES_TCPCONNECTSUCCEED_NOREPLY -4
#define VERIFY_DES_SOCK5CONNECTFAIL -5
#define VERIFY_DES_TCPCONNECTFAIL -6
#define VERIFY_DES_MAKEHOLEFIAL -7
#define VERIFY_DES_MAKEHOLE_VNNSERVERNOCONNECT -8
#define VERIFY_DES_MAKEHOLE_TIMEOUT -9
#define VERIFY_DES_MAKEHOLE_INTERNOCONNECT -10

//////////////temp
 

#define OP_OK 100
#define OP_CONN_SERVER_FAIL -101
#define OP_CONN_MR_FAIL -103
#define OP_FAIL_USER_NOT_EXIST -104
#define OP_FAIL_PWD_ERR -105
#define OP_FAIL_NO_PRI -106
#define OP_FAIL_TIME_OUT -107

enum{
    LOGIN_RESULT_CODE_SUCCESS=0x0001,//登录成功
    LOGIN_RESULT_CODE_FAIL_NET_DOWN=0x1001,//登录失败-网络不通
    LOGIN_RESULT_CODE_FAIL_NET_POOL=0x1002,//登录成功-网络差，连接超时
    LOGIN_RESULT_CODE_FAIL_SERVER_OFFLINE=0x1003,//登录失败-服务器不在线
    LOGIN_RESULT_CODE_FAIL_VERIFY_FAILED=0x1004,//登录失败-验证错误
    LOGIN_RESULT_CODE_FAIL_USER_NOEXIST=0x1005,//登录失败-用户名不存在
    LOGIN_RESULT_CODE_FAIL_PWD_ERROR=0x1006,//登录失败-密码错误
    LOGIN_RESULT_CODE_FAIL_OLD_VERSON=0x1007,//登录失败-前端版本不支持
};
#define DEVICE_NOT_UPLOAD -1
#define DEVICE_UPLOADED 0

#define DEVICE_HAS_SOFTWARE_UPDATE_UNKNOW 0
#define DEVICE_HAS_SOFTWARE_UPDATE_UNUPDATE 1
#define DEVICE_HAS_SOFTWARE_UPDATE 2

#define PANO_CAM_180 1
#define PANO_CAM_360 2
///end temp
