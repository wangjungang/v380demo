#ifndef _DEFINES_
#define _DEFINES_

//#define DEBUG
//
//#ifdef DEBUG

////调试状态
//#define Log(...) NSLog(__VA_ARGS__)
//
//
////发布状态
//#else
//    #define Log(...)
//#endif

typedef char* PCHAR;

#ifndef bool
#define bool int
#endif

#ifndef true
#define true 0x0001
#endif

#ifndef false
#define false 0x0000
#endif
//#define bool int
//#define true 0x0001
//#define false 0x0000

#define TAB_DEVICE_INDEX 1001
#define TAB_REMOTE_CONFIG_INDEX 1002
#define TAB_PLAYBACK_INDEX 1003
#define TAB_MORE_INDEX 1004

#define RESULT_ERROR -1

#define NUMPERFRM 505
//
#define CNN_STAT_CONNENTING 0x1001
#define CNN_STAT_LOADING 0x1002
#define CNN_STAT_STOP 0x1003
#define CNN_STAT_CONNECT_FAILED 0x1004
#define CNN_STAT_RECV_BAD 0x1005
#define CNN_STAT_RESTART 0x1006//¡¨Ω”∂œø™–Ë“™÷ÿ∆Ù

#define MAX_FRAME_SIZE 9437184/2//gaihui
#define NEW_VERSION 2
#define EACH_GETFRAME_COUNT 100
//
#define CMD_READY 0x1001
#define CMD_GET_IMAGE 0x2001
#define PARAM_NONE 0x3000
#define PARAM_IFRAME 0x3001
#define PARAM_PFRAME 0x3002



#define EDIT_MODE_NORMAL 0
#define EDIT_MODE_EDIT 1
#define EDIT_MODE_DEMO 2


#define REC_FILE_GET_DATA_ACK  156
#define REC_FILE_GET_DATA_END  257

#define REC_FILE_PLAYBACK_GET_DATA   158
#define REC_FILE_PLAYBACK_FINISH   159


#define MEDIA_PACKET_HEADER_SIZE 8   // ¸∑–°
#define MEDIA_PACKET_SIZE 412   // –°
#define MEDIA_BLOCK_SIZE 404     // ¸µƒ ˝æ›◊Ó≥§∂»
#define PACKET_HEADER_FLAG     0x7F  // ¸∑±Í ∂

#define FRAME_BUF_MAX_SIZE 704*576*3

#define DATA_BUF_LENGTH 512
#define PACKET_BUF_LENGTH 520 //512+4+4
#define MAX_SENDSPEED 10*1000*1000 //


//
#define NUMPERFRM 505
//
#define CNN_STAT_CONNENTING 0x1001
#define CNN_STAT_LOADING 0x1002
#define CNN_STAT_STOP 0x1003
#define CNN_STAT_CONNECT_FAILED 0x1004
#define CNN_STAT_RECV_BAD 0x1005
#define CNN_STAT_RESTART 0x1006//连接断开需要重启



//
#define CMD_READY 0x1001
#define CMD_GET_IMAGE 0x2001
#define PARAM_NONE 0x3000
#define PARAM_IFRAME 0x3001
#define PARAM_PFRAME 0x3002


#define MEDIA_PACKET_HEADER_SIZE 8   //媒体数据包包头大小
#define MEDIA_PACKET_SIZE 412   //媒体数据包包大小
#define MEDIA_BLOCK_SIZE 404     //媒体数据包的媒体数据最大长度
#define PACKET_HEADER_FLAG     0x7F  //媒体数据包包头标识


#define MEDIA_PACKET_HEADER_SIZE_V3 12   //媒体数据包包头大小
#define MEDIA_PACKET_SIZE_V3 512   //媒体数据包包大小
#define MEDIA_BLOCK_SIZE_V3 500     //媒体数据包的媒体数据最大长度

#define LONG_PACKET_MODE 30
#define SHORT_PACKET_MODE 20

#define FRAME_BUF_MAX_SIZE 704*576*3

#define QUALITY_MAX 100
#define QUALITY_MIN 20
#define QUALITY_STEP 10

//audio
#define BYTES_PER_SAMPLE 1
#define SAMPLE_PATE  8000
//typedef unsigned short sampleFrame;
#define FRAME_COUNT SAMPLE_PATE/60
#define QUEUE_BUFFER_SIZE 3

#define MAX_BUFFERSIZE 16*1024


//add by luo 20170809
#define MEDIA_PACKET_LONGSIZE_V20  8012
#define MEDIA_BLOCK_LONGSIZE_V20  8000
#define MEDIA_PACKET_MAX_SIZE_EX 8013 //1024


#define MEDIA_PACKET_LONGSIZE_LAN 4096   //
#define MEDIA_BLOCK_LONGSIZE_LAN 4084     //
//end add by luo 20170809


typedef enum{ // µƒ¿‘SourceID
    SOURCE_PC_CARD=0,//PC ”∆µ≤…ºØø®
    SOURCE_NET_DVR=1,///”≤≈¬ºœÒª˙
    SOURCE_IP_CAMERA=3///…„œÒª˙
}SOURCE_ID;

typedef enum{//Ω‚¬Î∆˜±‡∫≈
    NV_CODEC_ID_H264 = 1001,
    NV_CODEC_ID_MPEG4 = 1002,
    NV_CODEC_ID_MJPEG = 1003,
    NV_CODEC_ID_H265 = 1004,
}NV_CODEC_ID;

#define QUALITY_MAX 100
#define QUALITY_MIN 20
#define QUALITY_STEP 10

//audio
#define BYTES_PER_SAMPLE 1
#define SAMPLE_PATE  8000
typedef unsigned short sampleFrame;
#define FRAME_COUNT SAMPLE_PATE/60
#define QUEUE_BUFFER_SIZE 3

#define MAX_BUFFERSIZE 16*1024


#define SERVER_TYPE_DOMAIN 1001
#define SERVER_TYPE_IP 1002

//
#define PLAY_RESULT_OK 100
#define PLAY_RESULT_CONN_FAIL -101
#define PLAY_RESULT_PLAY_FAIL -103

#define PLAY_RESULT_OK 100


//#define LOGIN_RESULT_OK 100
//#define LOGIN_RESULT_SERVER_OFFLINE -100
//#define LOGIN_RESULT_CONN_FAIL -101
//#define LOGIN_RESULT_LOGIN_FAIL -103
//#define LOGIN_RESULT_LOGIN_FAIL_USER_NOT_EXIST -104
//#define LOGIN_RESULT_LOGIN_FAIL_PWD_ERR -105
//#define LOGIN_RESULT_LOGIN_FAIL_NO_PRI -106
#define LOGIN_RESULT_SUCCESS 1001
#define LOGIN_RESULT_UNSUPPORT -100 // add by lusongbin 20161012

#define OP_OK 100
#define OP_CONN_SERVER_FAIL -101
#define OP_CONN_MR_FAIL -103
#define OP_FAIL_USER_NOT_EXIST -104
#define OP_FAIL_PWD_ERR -105
#define OP_FAIL_NO_PRI -106
#define OP_FAIL_TIME_OUT -107





//控制定义：
#define NV_ENABLE 1000 //开启
#define NV_DISABLE 1001 // 关闭

#define NV_LANGUAGE_CN 1000 //中文
#define NV_LANGUAGE_EN 1100 //英文
//
#define EXALARMMODE_EXTERNAL        10    //外部报警系统(expand detector)
#define EXALARMMODE_INTERNAL        11    //内部报警系统(current detector)
#define EXALARMMODE_MANUALOFF        12    //手动控制关闭输出(manually control)
#define EXALARMMODE_MANUALON        13    //手动控制开启输出(manually control)

#define ALARM_MODEL_WIRELESS        315    //
#define ALARM_MODEL_DIGT        533    //

//录像状态
#define RECORD_STAT_UNKNOW 0//未知
#define RECORD_STAT_RUN_OK 10//运行正常
#define RECORD_STAT_NO_SDCARD  -11//没有插入sdcard
#define RECORD_STAT_SDCARD_WRITE_ERR  -12//sdcard写入异常


//‘∆®øÿ÷∆
#define NV_IPC_PTZ_REQUEST 170//‘∆Ã(ptz)øÿ÷∆÷∏¡Ó



//ptz∂Ø◊˜
#define NV_IPC_PTZ_ACTION_LEFT 1001 //
#define NV_IPC_PTZ_ACTION_RIGHT 1002 //
#define NV_IPC_PTZ_ACTION_UP 1003 //
#define NV_IPC_PTZ_ACTION_DOWN 1004 //
#define NV_IPC_PTZ_ACTION_AUTO_HORIZONTAL 1005 //
#define NV_IPC_PTZ_ACTION_AUTO_VERTICAL 1006 //
#define NV_IPC_PTZ_ACTION_AUTO_ALL 1007 //

//ptz÷µ
#define NV_IPC_PTZ_VALUE_START 1100
#define NV_IPC_PTZ_VALUE_STOP 1101

//…˘“Ùøÿ÷∆
#define CMD_SOUND_CTRL 0x2101//…˘“Ùø™πÿøÿ÷∆
#define SOUND_CTRL_CLOSE 0x1000//£÷πΩ” ’…˘“Ù
#define SOUND_CTRL_OPEN 0x1001//ø™∆ÙΩ” ’…˘“Ù


#define NV_CODEC_ID_H264    1001
#define NV_CODEC_ID_MPEG4    1002
#define NV_CODEC_ID_MJPEG    1003
#define NV_CODEC_ID_H265    1004
#define MAX_W                 1280
#define MAX_H                 1280
#define NUMPERFRM             505

//record file type defines
#define FILE_TYPE_ALL       0
#define FILE_TYPE_NORMAL    1
#define FILE_TYPE_MOTTON    2
#define FILE_TYPE_ALARM     3

#define MEDIA_BUF_SIZE 412   //媒体数据包包大小

#define MEDIA_BUF_SIZE_MR 256   //媒体数据包包大小

#define NV_IPC_REMOTE_GET_REQUEST 880 //
#define NV_IPC_REMOTE_SET_REQUEST 881 //

#define NV_IPC_NO_SUPORT -100 //

#define NV_IPC_WIFI_SEARCH_REQUEST 110 //
#define NV_IPC_WIFI_SEARCH_RESPONSE 210 //±æµÿwifiÀ—À˜œÏ”¶÷∏¡Ó◊÷
#define NV_IPC_WIFI_SEARCH_RESPONSE_WAIT 310 //±æµÿwifiÀ—À˜œÏ”¶÷∏¡Ó◊÷

#define NV_IPC_WIFI_GET_CONFIG_REQUEST 111// wifi≈‰÷√ªÒ»°–≠“È«Î«÷∏¡Ó◊÷
#define NV_IPC_WIFI_GET_CONFIG_RESPONSE 211//wifi≈‰÷√ªÒ»°–≠“ÈœÏ”¶÷∏¡Ó◊÷

#define NV_IPC_WIFI_SET_CONFIG_REQUEST 112//wifi…Ë÷√–≠“È«Î«÷∏¡Ó◊÷
#define NV_IPC_WIFI_SET_CONFIG_RESPONSE 212//wifi…Ë÷√–≠“ÈœÏ”¶÷∏¡Ó◊÷

#define NV_IPC_RECORD_CONFIG_GET_REQUEST 113//¬ºœÒ≈‰÷√ªÒ»°–≠“È«Î«÷∏¡Ó◊÷
#define NV_IPC_RECORD_CONFIG_GET_RESPONSE 213//¬ºœÒ≈‰÷√ªÒ»°–≠“ÈœÏ”¶÷∏¡Ó◊÷

#define NV_IPC_RECORD_CONFIG_SET_REQUEST 114//¬ºœÒ≈‰÷√…Ë÷√–≠“È«Î«÷∏¡Ó◊÷
#define NV_IPC_RECORD_CONFIG_SET_RESPONSE 214//¬ºœÒ≈‰÷√…Ë÷√–≠“ÈœÏ”¶÷∏¡Ó◊÷

#define NV_IPC_TIME_GET_REQUEST 115// ±º‰ªÒ»°–≠“È«Î«÷∏¡Ó◊÷
#define NV_IPC_TIME_GET_RESPONSE 215// ±º‰ªÒ»°–≠“ÈœÏ”¶÷∏¡Ó◊÷

#define NV_IPC_TIME_SET_REQUEST 116// ±º‰…Ë÷√–≠“È«Î«÷∏¡Ó◊÷
#define NV_IPC_TIME_SET_RESPONSE 216// ±º‰…Ë÷√–≠“ÈœÏ”¶÷∏¡Ó◊÷


#define NV_IPC_USERINFO_GET_REQUEST 117//ªÒ»°”√ªß–≈œ¢«Î«÷∏¡Ó◊÷
#define NV_IPC_USERINFO_GET_RESPONSE 217//ªÒ»°”√ªß–≈œ¢œÏ”¶÷∏¡Ó◊÷

#define NV_IPC_USERINFO_SET_REQUEST 118//…Ë÷√”√ªß–≈œ¢«Î«÷∏¡Ó◊÷
#define NV_IPC_USERINFO_SET_RESPONSE 218//…Ë÷√”√ªß–≈œ¢œÏ”¶÷∏¡Ó◊÷

#define NV_IPC_VERSION_INFO_GET_REQUEST 119//…Ë÷√”√ªß–≈œ¢«Î«÷∏¡Ó◊÷
#define NV_IPC_VERSION_INFO_GET_RESPONSE 219//…Ë÷√”√ªß–≈œ¢œÏ”¶÷∏¡Ó◊÷

#define NV_IPC_WIFI_SELECT_SET_REQUEST 120
#define NV_IPC_WIFI_SELECT_SET_RESPONSE 220


#define NV_IP_SWITCH_GET_REQUEST 121//获取开关指令字
#define NV_IP_SWITCH_GET_RESPONSE 221 //获取开关响应指令字

#define NV_IP_SWITCH_SET_REQUEST 122//设置开关指令字
#define NV_IP_SWITCH_SET_RESPONSE 222 //设置开关响应指令字

#define NV_IPC_USERINFO_GET_RESPONSE_NEW 317//

#define NV_IP_ADD_USER_REQUEST  123
#define NV_IP_ADD_USER_RESPONSE 223

#define NV_IP_DELETE_USER_REQUEST  124
#define NV_IP_DELETE_USER_RESPONSE 224

#define NV_IP_MODIFY_USER_REQUEST  125
#define NV_IP_MODIFY_USER_RESPONSE 225

#define NV_IP_MODIFY_PWD_REQUEST  126
#define NV_IP_MODIFY_PWD_RESPONSE 226

#define NV_IP_UPDATE_CHECK_REQUEST  127
#define NV_IP_UPDATE_CHECK_RESPONSE 227

#define NV_IP_UPDATE_START_REQUEST  128
#define NV_IP_UPDATE_START_RESPONSE 228

#define NV_IP_PTZX_REQUEST  129
#define NV_IP_PTZX_RESPONSE 229
#define NV_IP_PTZX_REQUEST_EX 329
#define NV_IP_PTZX_RESPONSE_EX 429

#define NV_IP_ALARM_DEVICE_LIST_REQUEST  130
#define NV_IP_ALARM_DEVICE_LIST_RESPONSE 230

#define NV_IP_ALARM_DEVICE_SEARCH_REQUEST  131
#define NV_IP_ALARM_DEVICE_SEARCH_RESPONSE 231

#define NV_IP_ALARM_DEVICE_ADD_REQUEST  132
#define NV_IP_ALARM_DEVICE_ADD_RESPONSE 232

#define NV_IP_ALARM_DEVICE_MODIFY_REQUEST  133
#define NV_IP_ALARM_DEVICE_MODIFY_RESPONSE 233

#define NV_IP_ALARM_DEVICE_DELETE_REQUEST  134
#define NV_IP_ALARM_DEVICE_DELETE_RESPONSE 234

#define NV_IP_WAIITING_RESPONSE 235


#define NV_IP_FORMAT_SDCARD_REQUEST  141
#define NV_IP_FORMAT_SDCARD_RESPONSE 241

//add by luo 20160321
#define NV_IPC_IP_CONFIG_GET_REQUEST  142
#define NV_IPC_IP_CONFIG_GET_RESPONSE 242

#define NV_IPC_IP_CONFIG_SET_REQUEST  143
#define NV_IPC_IP_CONFIG_SET_RESPONSE 243

#define NV_IPC_ALARM_SET_REQUEST  144
#define NV_IPC_ALARM_SET_RESPONSE 244
#define NV_IPC_ALARM_SET_REQUEST_20  344   //布撤防20
#define NV_IPC_ALARM_SET_RESPONSE_20 444   //布撤防20
//end add by luo 20160321

#define  ALARM_DEVICE_SEARCH_ON 100
#define  ALARM_DEVICE_SEARCH_OFF 101


//add by luo 20150824
#define DEVICE_OTHER 0 //其他
#define DEVICE_ACCESS_CTRL 1  //门禁
#define DEVICE_SMOKE_FEELING 2  //烟感
#define DEVICE_GAS 3  //煤气
#define DEVICE_WARM_FEELING 4  //温感

/*
 //报警类型
 #define UNDIFINE_ALARM 111        // 报警
 #define SMOG_ALARM 100        //烟雾报警
 #define MOTION_ALARM 200    //移动报警
 #define PIR_ALARM 300        //PIR 人体感应报警
 #define ACCESS_CTRL_ALARM 400        //门禁报警
 #define GAS_ALARM 500        //煤气报警
 #define WARM_ALARM 600        //温度报警
 
 //报警级别
 #define ALARM_LEVEL_L 1        //低
 #define ALARM_LEVEL_M 2    //中
 #define ALARM_LEVEL_H 3        //高
 //end add by luo 20150824
 */


//报警类型
#define ALARM_TYPE_UNDIFINED 0       //普通报警
#define ALARM_TYPE_SMOG 1            //烟感报警
#define ALARM_TYPE_MOTION 2          //移动报警报警
#define ALARM_TYPE_PIR 3             //人体感应报警
#define ALARM_TYPE_ACCESS_CTRL 4     //访问控制报警
#define ALARM_TYPE_GAS 5             //煤气报警
#define ALARM_TYPE_WARM 6            //温感报警
#define ALARM_TYPE_PWD_CHANGE 7      //设备密码修改报警
#define ALARM_TYPE_HUMAN 8           //发现人型报警

//报警级别
#define MVS_AML_NOTICE 0             //消息提示
#define MVS_AML_NORMAL 1             //普通
#define MVS_AML_WARNING 2            //警告
#define MVS_AML_CRITICAL 4           //紧急


#define NV_RESULT_SUCCEED 1001//≤Ÿ◊˜Ω·π˚Œ™≥…π¶
#define NV_RESULT_FAILED 2001 //≤Ÿ◊˜Ω·π˚Œ™ ß∞‹
#define NV_RESULT_FAILED_EX 2002 //≤Ÿ◊˜Ω·π˚Œ™ ß∞‹
#define NV_RESULT_SUCCEED_REFRESH 3001//≤Ÿ◊˜Ω·π˚Œ™≥…π¶

#define NV_RESULT_DESC_NO_USER 1011//”√ªß≤ªÊ‘⁄
#define NV_RESULT_DESC_PWD_ERR 1012 //√‹¬ÎÌŒ
#define NV_RESULT_DESC_NO_PRI 1013//»®œﬁ≤ª◊„
#define NV_RESULT_DESC_TIME_ERR 1014// ±º‰∏Ò Ω≤ª∂‘
#define NV_RESULT_DESC_PWD_FMT_ERR_AP 1015//ap√‹¬Î∏Ò Ω≤ª∂‘
#define NV_RESULT_DESC_PWD_FMT_ERR_STATION  1016//station√‹¬Î∏Ò Ω≤ª∂‘
#define NV_RESULT_DESC_PWD_FMT_ERR 1017//√‹¬Î∏Ò Ω≤ª∂‘

#define NV_WIFI_MODE_AP 1001//APƒ£ Ω
#define NV_WIFI_MODE_STATION 1002 // STATION ƒ£ Ω

#define NV_RECORD_ENABLE 1100 //ø™∆Ù¬ºœÒ
#define NV_RECORD_DISABLE 1200 // πÿ±’¬ºœÒ

#define NV_RECORD_OP_RECORVER 1300 //¬˙≈∏≤∏«æ…Œƒº˛
#define NV_RECORD_OP_STOP 1400 // ¬˙≈Ã£÷π¬ºœÒ


#define NV_WIFI_SET_NO 1000 //∑Ò
#define NV_WIFI_SET_YES 1001 // «


#define OPEN_WIFI_SETTING_ALERT 101

#define REC_FILE_SEARCH 150
#define REC_FILE_SEARCH_RESP 250
#define REC_FILE_DOWNLOAD 151
#define REC_FILE_DOWNLOAD_RESP 251
#define REC_FILE_PLAYBACK 152
#define REC_FILE_PLAYBACK_RESP 252
#define REC_FILE_SEARCH_EX 153
#define REC_FILE_SEARCH_EX_RESP  253
#define CMD_LOGIN_EX 154
#define CMD_LOGIN_EX_RESP  254

#define REC_FILE_GET_DATA 155
#define REC_FILE_GET_DATA_RESP 255

#define REC_FILE_GET_DATA_ACK 156
#define REC_FILE_GET_DATA_END 257

#define REC_FILE_PLAYBACK_GET_DATA 158
#define REC_FILE_PLAYBACK_FINISH 159

#define CMD_WAIT_FOR_DATA 260
//音频对讲
#define NV_IPC_AUDIO_SPEAK 180//音频对讲
#define NV_IPC_ALIVE 188//心跳包


//对焦
#define NV_IPC_FOCUSING 195//
#define NV_IPC_FOCUSIN 1000
#define NV_IPC_FOCUSOUT 1001

//云台控制

#define NV_IPC_PTZ_REQUEST 170//云台(ptz)控制指令
#define NV_IPC_PRESET_REQUEST 171//云台(ptz)控制指令

#define NV_PRESET_ACTION_ADD 100//
#define NV_PRESET_ACTION_DEL 101//
#define NV_PRESET_ACTION_RESET 102//
#define NV_PRESET_ACTION_LOCATION 103//

#define NV_IPC_CTRL_CONNECT_REQUEST 177
#define NV_IPC_CTRL_CONNECT_RESPONE 277

//add by luo 20170626
#define NV_IPC_CTRL_CONNECT_REQUEST_V20 377
#define NV_IPC_CTRL_CONNECT_RESPONE_V20 477
//end add by luo 20170626

//¬ºœÒŒƒº˛¿‡–
#define FILE_TYPE_ALL 0 //»´≤ø
#define FILE_TYPE_NORMAL 1 //∆’®
#define FILE_TYPE_MOTION 2//∂ØºÏ
#define FILE_TYPE_ALARM 3//±®æØ

//add by luo 20150106
#define NV_IPC_CAM_ORENTATION 190//镜头图像方向设置

//灯光
#define NV_IPC_LIGHT_SET_REQUEST 196  //灯光控制

//灯光动作
#define NV_IPC_ACTION_LIGHT_ON 1001
#define NV_IPC_ACTION_LIGHT_OFF 1002
#define NV_IPC_ACTION_LIGHT_AUTO 1003

//镜头图像方向
#define NV_IPC_CAM_REVERSE 1000
#define NV_IPC_CAM_UP 1001 //
#define NV_IPC_CAM_DOWN 1002 //
#define NV_IPC_CAM_LEFT 1003 //
#define NV_IPC_CAM_RIGHT 1004 //
//end add by luo 20150106

//ptz动作
#define NV_IPC_PTZ_ACTION_NONE 1000
#define NV_IPC_PTZ_ACTION_LEFT 1001 //
#define NV_IPC_PTZ_ACTION_RIGHT 1002 //
#define NV_IPC_PTZ_ACTION_UP 1003 //
#define NV_IPC_PTZ_ACTION_DOWN 1004 //
#define NV_IPC_PTZ_ACTION_AUTO_HORIZONTAL 1005 //
#define NV_IPC_PTZ_ACTION_AUTO_VERTICAL 1006 //
#define NV_IPC_PTZ_ACTION_AUTO_ALL 1007 //

//ptz值
#define NV_IPC_PTZ_VALUE_START 1100
#define NV_IPC_PTZ_VALUE_STOP 1101

//声音控制
#define CMD_SOUND_CTRL 0x2101//声音开关控制
#define SOUND_CTRL_CLOSE 0x1000//停止接收声音
#define SOUND_CTRL_OPEN 0x1001//开启接收声音

//登陆和接收转发服务器的指令
#define CMD_MR_LOGIN 1001
#define CMD_MR_LOGIN_RESPONSE 2001
#define CMD_MR_PLAY 1002
#define CMD_MR_PLAY_RESPONSE 2002
#define CMD_MR_GET_IMAGE 1003


#define CMD_CONTROL_CONNECT_REQUEST_MR 1011
#define CMD_CONTROL_CONNECT_RESPONSE_MR 2011
#define CMD_AUDIO_CONTROL_MR 1012
#define CMD_SPEAK_CONTROL_MR 1013
#define CMD_PTZ_CONTROL_MR 1014

#define CMD_REC_FILE_SEARCH_MR 1015
#define CMD_REC_FILE_SEARCH_RESULT_MR 2015

#define CMD_REC_FILE_PLAYBACK_MR 1016
#define CMD_REC_FILE_PLAYBACK_RESPONSE_MR 2016

#define CMD_LOGIN_EX_MR 1017
#define CMD_LOGIN_EX_RESULT_MR  2017



#define REC_FILE_PLAYBACK_GET_DATA_MR 1018
#define REC_FILE_PLAYBACK_FINISH_MR 2018


#define NV_IPC_ONLINE_CHECK_REQUEST 172
#define NV_IPC_ONLINE_CHECK_RESPONSE  272

#define STAT_SERVER_FAIL -1
#define STAT_ONLINE 1
#define STAT_OFFLINE 0
#define STAT_UNKNOW 10

#define ALARM_UNKNOW 0
#define ALARM_OFF 1
#define ALARM_ON 2

//remote setting cmd
#define CMD_MR_WAIT 2000

//values define
//操作结果值定义：
#define CONFIG_RESULT_OK_MR 1001
#define CONFIG_RESULT_FAIL_MR 2001

//结果描述定义：（都是对NV_RESULT_FAILED的描述）
#define NV_RESULT_DESC_NO_USER 1011//用户不存在
#define NV_RESULT_DESC_PWD_ERR 1012 //密码错误
#define NV_RESULT_DESC_NO_PRI 1013//权限不足
#define NV_RESULT_DESC_TIME_ERR 1014//时间格式不对
#define NV_RESULT_DESC_PWD_FMT_ERR_AP 1015//ap密码格式不对
#define NV_RESULT_DESC_PWD_FMT_ERR_STATION  1016//station密码格式不对
#define NV_RESULT_DESC_PWD_FMT_ERR 1017//密码格式不对
#define NV_RESULT_ID_ERR 1018//ID号不对
#define NV_RESULT_NO_NEW_VERSION  1019//
#define NV_RESULT_NET_NO_SUPORT  1020//

//结果值
#define CMD_MR_OK 100
#define CMD_MR_FAIL 101

//手机类型定义
#define PHONE_TYPE_IOS 1001
#define PHONE_TYPE_ANDROID 1002
#define PHONE_TYPE_WP8 1003


// 运营商+网络类型
#define CHINA_MOBILE_WIFI 20
#define CHINA_MOBILE_MOBILE 21
#define CHINA_MOBILE_4G 22
#define CHINA_MOBILE_3G 23
#define CHINA_MOBILE_2G 24
#define CHINA_MOBILE_NO_CONNECT 25
#define CHINA_MOBILE_MOBILE_UNKNOWN 26

#define CHINA_UNICOM_WIFI 27
#define CHINA_UNICOM_MOBILE 28
#define CHINA_UNICOM_4G 29
#define CHINA_UNICOM_3G 30
#define CHINA_UNICOM_2G 31
#define CHINA_UNICOM_NO_CONNECT 32
#define CHINA_UNICOM_MOBILE_UNKNOWN 33

#define CHINA_TELECOM_WIFI 34
#define CHINA_TELECOM_MOBILE 35
#define CHINA_TELECOM_4G 36
#define CHINA_TELECOM_3G 37
#define CHINA_TELECOM_2G 38
#define CHINA_TELECOM_NO_CONNECT 39
#define CHINA_TELECOM_MOBILE_UNKNOWN 40

#define UNKNOWN_OPERATOR_WIFI 41
#define UNKNOWN_OPERATOR_MOBILE 42
#define UNKNOWN_OPERATOR_4G 43
#define UNKNOWN_OPERATOR_3G 44
#define UNKNOWN_OPERATOR_2G 45
#define UNKNOWN_OPERATOR_NO_CONNECT 46
#define UNKNOWN_OPERATOR_MOBILE_UNKNOWN 47






//÷µµƒ∂®“Â£¨
#define OP_RESULT_OK 1000
#define OP_RESULT_USER_ERR -1001
#define OP_RESULT_PWD_ERR -1002
#define OP_RESULT_NO_PRI -1003
#define OP_RESULT_FILE_NOT_EXIST -1004

#define STREAM_TYPE_SMOOTH 0
#define STREAM_TYPE_HD 1

//¬ºœÒ¿‡–∂®“Â
#define VIDEO_TYPE_1080P 1000 //
#define VIDEO_TYPE_720P 1001 //
#define VIDEO_TYPE_D1 1002 //
#define VIDEO_TYPE_VGA 1003 //
#define VIDEO_TYPE_CIF 1004 //
#define VIDEO_TYPE_QVGA 1005//
#define VIDEO_TYPE_QCIF 1006//
#define VIDEO_TYPE_960P 1007 //

// ¬ºœÒ“Ù∆µø™πÿ∂®“Â
#define AUDIO_ENABLE_ON 1000//
#define AUDIO_ENABLE_OFF 1001//

#define SMOKE_ALARM 100//
#define MOTION_ALARM 200//
#define PIR_ALARM 300//

#define TAB_ADD_INDEX 1001
#define TAB_SEARCH_INDEX 1002
#define TAB_DELETE_INDEX 1003
#define TAB_QR_ADD_INDEX 1004
#define TAB_QIUICK_WIFI_INDEX 1005

#define MANU_HD 1001
#define MANU_SMOOTH 1002

//add by luo 20150516 推送相关
#define T_MSG_ALARM 1//推送消息类型 报警信息
#define T_MSG_AD 2//推送消息类型 广告信息
#define T_MSG_STAT 3//推送消息类型 设备状态信息

#define  CMD_ALARM_MSG 8001  //握手校验指令
#define  CMD_ALARM_MSG_READY 8002 //就绪指令
#define  CMD_ALARM_MSG_FINISH 8003 //完成指令

#define  CMD_ALARM_PIC_GET 8004  //握手校验指令
#define  CMD_ALARM_PIC_GET_RESPONSE 8005 //就绪指令
#define  CMD_ALARM_PIC_RECV_READY 8006 //就绪指令
#define  CMD_ALARM_PIC_FINISH 8007 //完成指令


#define  PACKET_FLAG_END 0xA0 //数据发送接收包
#define  PACKET_FLAG_PICTURE 0xA1 //图片数据包
#define  PACKET_FLAG_POSITION 0xA2 //坐标数据包

#define  VALUE_RESULT_OK 1000       //成功
#define  VALUE_RESULT_FAIL -1001     //失败

#define  VALUE_DESC_DEVID_ERR  -1000 //设备号无效
#define  VALUE_DESC_USER_ERR  -1001 //用户不存在
#define  VALUE_DESC_PWD_ERR  -1002 //密码错误
#define  VALUE_DESC_DATA_ERR  -1003 //数据传输失败

#define ALARM_VERSION_OSS_20 20//

#endif

