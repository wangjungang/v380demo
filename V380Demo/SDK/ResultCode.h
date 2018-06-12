//
//  ResultCode.h
//  iCamSee
//
//  Created by macrovideo on 15/10/19.
//  Copyright © 2015年 macrovideo. All rights reserved.
//

#ifndef ResultCode_h
#define ResultCode_h

//操作返回码
#define RESULT_CODE_SUCCESS_REFRESH  0x104 //刷新，并没有真正请求
#define RESULT_CODE_SUCCESS  0x100 //成功
#define RESULT_CODE_PROCESSING  0x102 //处理中，还没有成功，针对录像文件搜索，表示没有搜索完全
#define RESULT_CODE_SERVERCONNECT  0x103 //连接上了服务器，但是没有得到响应数据
#define RESULT_CODE_FAIL_SERVER_CONNECT_FAIL  -0x101 //
#define RESULT_CODE_FAIL_COMMUNICAT_FAIL  -0x102 //
#define RESULT_CODE_FAIL_VERIFY_FAIL  -0x103 //
#define RESULT_CODE_FAIL_USER_NOEXIST  -0x104 //
#define RESULT_CODE_FAIL_PWD_ERR  -0x105 //密码错误
#define RESULT_CODE_FAIL_OLD_VERSION  -0x106 //
#define RESULT_CODE_FAIL_ID_ERR  -0x107 //
#define RESULT_CODE_FAIL_PWD_ERR_AP  -0x108 //
#define RESULT_CODE_FAIL_PWD_ERR_STATION  -0x109 //
#define RESULT_CODE_FAIL_PWD_FMT_ERR  -0x110 //
#define RESULT_CODE_FAIL_USERNAME_NULL  -0x111 //
#define RESULT_CODE_FAIL_PARAM_ERROR  -0x112 //传入参数有误
#define RESULT_CODE_FAIL_TIME_FMT_ERROR  -0x113 //时间格式错误


//获取报警图片列表返回码
#define RESULT_CODE_SUCCESS_NEWMESSAGE 100            //成功，并且有新的报警信息
#define RESULT_CODE_SUCCESS_NOTNEWMESSAGE 0           //成功，但是没有新的报警信息
#define RESULT_CODE_FAIL_CONNECT_SERVER_FAIL -100     //失败，连接数据库失败
#define RESULT_CODE_FAIL_USERNAME_NOEXIST -101        //失败，用户名不存在
#define RESULT_CODE_FAIL_PASSWORD_ERROR -102          //失败，密码不正确
#define RESULT_CODE_FAIL_PARM_ERROR -103              //失败，请求参数不正确

#endif /* ResultCode_h */
