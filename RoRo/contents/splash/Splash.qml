/*
    SPDX-FileCopyrightText: 2014 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import org.kde.kirigami 2 as Kirigami

Rectangle {
    id: root
    color: "#070000"

    property int stage

    onStageChanged: {
        if (stage == 2) {
            introAnimation.running = true;
        } else if (stage == 5) {
            introAnimation.target = busyIndicator;
            introAnimation.from = 1;
            introAnimation.to = 0;
            introAnimation.running = true;
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        width: 400
        height: 400
        Image {
            id: logo
            //match SDDM/lockscreen avatar positioning
            readonly property real size: Kirigami.Units.gridUnit * 8

            anchors.centerIn: parent

            asynchronous: true
            source: "images/RoRo.svg"

            sourceSize.width: 500
            sourceSize.height: 500
            RotationAnimator on rotation {
                running: true
                loops: Animation.Infinite
                from: 0
                to: 360
                duration: 1500
            }
        }

        // TODO: port to PlasmaComponents3.BusyIndicator
            Image {
                id: busyIndicator
                //in the middle of the remaining space
                y: parent.height - (parent.height - logo.y) / 2 - height/2
                anchors.horizontalCenter: parent.horizontalCenter
                asynchronous: true
                source: "images/busy_arm.svg"
                sourceSize.height: Kirigami.Units.gridUnit * 2
                sourceSize.width: Kirigami.Units.gridUnit * 2
                RotationAnimator on rotation {
                    id: rotationAnimator
                    from: 0
                    to: 360
                    // Not using a standard duration value because we don't want the
                    // animation to spin faster or slower based on the user's animation
                    // scaling preferences; it doesn't make sense in this context
                    duration: 2000
                    loops: Animation.Infinite
                    // Don't want it to animate at all if the user has disabled animations
                    running: Kirigami.Units.longDuration > 1
                }

        }
        Text {
            text: "「リミターカット！ フルドライブ！」"
            font.pointSize: 24
            color: "#ffffff"
            opacity:0.85
            font { family: "OpenSans Dark"; weight: Font.Dark}
            anchors.horizontalCenter: parent.horizontalCenter
            y: (parent.height - height) / 1.1
        }
        Row {
            spacing: Kirigami.Units.largeSpacing
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: Kirigami.Units.gridUnit
            }

        }
    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: Kirigami.Units.veryLongDuration * 2
        easing.type: Easing.InOutQuad
    }
}
