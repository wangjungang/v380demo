//
//  OpenGLView.h
//  Tutorial01
//
//  Created by  on 12-11-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import<GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/EAGL.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface HYFisheyePanoView : UIView{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;//渲染对象
    GLuint _frameBuffer;//缓冲区对象
}


- (void)InitFisheyeParam:(int)iFixType andCenterX:(int) xCenter andCenterY:(int)yCenter andRadius:(int)radius ;
//RGBorYUV420=0，传入的图像数据为RGB格式，RGBorYUV=1,传入的数据格式是YUV420格式。
- (void)SetImageYUV:(int)RGBorYUV420 andImageBuffer:(Byte *) pData andWidth:(int) width andHeight:(int) height;
- (void)SetMode:(int) iMode;
- (void)Clearsurface;//RGB图片预览下一张加载过程的清屏工作
- (void)SetActive: (BOOL) bActive;
@end

