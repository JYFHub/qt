/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the plugins of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions
** contained in the Technology Preview License Agreement accompanying
** this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
**
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "quikitscreen.h"

#include <QtGui/QApplication>

#include <QtDebug>

QT_BEGIN_NAMESPACE

QUIKitScreen::QUIKitScreen(int screenIndex)
    : QPlatformScreen(),
      m_index(screenIndex)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIScreen *screen = [[UIScreen screens] objectAtIndex:screenIndex];
    UIScreenMode *mode = [screen currentMode];
    CGSize size = [mode size];
    m_geometry = QRect(0, 0, size.width, size.height);
    CGRect bounds = [screen bounds]; // in 'points', 1p == 1/160in

//    qreal xDpi = size.width * 160. / bounds.size.width;
//    qreal yDpi = size.height * 160. / bounds.size.height;
//    qDebug() << xDpi << yDpi;

    m_format = QImage::Format_ARGB32;

    m_depth = 24;

    const qreal inch = 25.4;
    const qreal dpi = 160.;
    m_physicalSize = QSize(qRound(bounds.size.width * inch / dpi), qRound(bounds.size.height * inch / dpi));
    if (m_index == 0)
        qApp->setStartDragDistance(12);
    [pool release];
}

QUIKitScreen::~QUIKitScreen()
{
}

UIScreen *QUIKitScreen::uiScreen() const
{
    return [[UIScreen screens] objectAtIndex:m_index];
}

QT_END_NAMESPACE