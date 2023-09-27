/*==={ GlowingBlue }===*/

import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import QtMultimedia 5.5
import SddmComponents 2.0
import QtGraphicalEffects 1.12

Rectangle {
    id  : login_form
	color: "#191919"
    property string access: ""
    property string sd: ""
    property date valueDT: new Date()
    property int delay: 5
    property bool find: false

/*===[ BGN Timer ]===*/
    Timer {
        interval : 1000
        running : true
        repeat : true

        onTriggered : {
            /*===( Update Time )===*/
            login_form.valueDT = new Date()

            /*===( Authentication Message )===*/
            if (errorMessage.visible | gl_errorMessage.visible) {
                if (delay == 0) {
                    errorMessage.visible = false
                    gl_errorMessage.visible = false
                    delay = 6
                }
                delay--
            }

            /*===( CapsLock Tracking )===*/
            if (keyboard.capsLock & password.visible) {
                caps.visible = true
                gl_caps.visible = true
                capslock.play()
            } else {
                caps.visible = false
                gl_caps.visible = false
            }

            /*===( Greeting Depending On The Time Of Day )===*/
            sd = Qt.formatDateTime(login_form.valueDT, "HH")

            if (sd >= 0 && sd <= 5) {
                greeting.text = config.GoodNightText + "!"
                greeting.color = "#f00"
            } else
            if (sd >= 6 && sd <= 11) {
                greeting.text = config.GoodMorningText + "!"
                greeting.color = "#fff"
            } else
            if (sd >= 12 && sd <= 17) {
                greeting.text = config.GoodDayText + "!"
                greeting.color = "#ff0"
            } else
            if (sd >= 18 && sd <= 23) {
                greeting.text = config.GoodEveningText + "!"
                greeting.color = "#f70"
            }
        }
    }
/*===[ END Timer ]===*/

/*===[ BGN FindUser ]===*/
    // model - userModel ( QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) );
    // role:
    //      1 - QString name;
    //      2 - QString realName;
    //      3 - QString homeDir;
    //      4 - QString icon;
    //      5 - bool needsPassword { false };
    //      6 - int gid { 0 };
    function findUsr(model, usr, role) {
        for (var i = 0; i < model.count; i++) {
            if (model.data(model.index(i, 0), Qt.UserRole + 1) == usr) {
                return model.data(model.index(i, 0), Qt.UserRole + role)
                find = true
            }
        }

        if (!find) { return "./img" }
    }
/*===[ END FindUser ]===*/

/*===[ BGN PassDisplayMode ]===*/
    signal pwdShowHide()

    onPwdShowHide : {
        if (password.echoMode == TextInput.Password) {
            password.echoMode = TextInput.Normal
            echoModeBtn.source = "img/show_pwd.png"
            gl_echoModeBtn.color = "green"
        } else {
            password.echoMode = TextInput.Password
            echoModeBtn.source = "img/hight_pwd.png"
            gl_echoModeBtn.color = "#f00"
        }
    }
/*===[ END PassDisplayMode ]===*/

/*===[ BGN ProcLogin ]===*/
    signal tryLogin()

    onTryLogin : {
        processing.visible = true
        gl_processing.visible = true
        processing_anim.start()
    }
/*===[ END ProcLogin ]===*/

/*===[ BGN Connection ]===*/
	Connections {
		target: sddm

		onLoginSucceeded: {
            allowed.play()
            errorMessage.color = "#0f0"
            gl_errorMessage.color = "#0f0"
            access = config.AccessAllowedText + "!"
            errorMessage.visible = true
            gl_errorMessage.visible = true

            processing.visible = false
            gl_processing.visible = false
            processing_anim.stop()
		}

		onLoginFailed: {
			denied.play()
            errorMessage.color = "#f00"
            gl_errorMessage.color = "#f00"
            access = config.AccessDeniedText + "!"
            errorMessage.visible = true
            gl_errorMessage.visible = true

            processing.visible = false
            gl_processing.visible = false
            processing_anim.stop()
		}
	}
/*===[ END Connection ]===*/
/////////////////////////////////////////////////////////////////
	AnimatedImage {
        id: bg
        y: 0
		x: -((Window.width/2)-(self.width/2))
		fillMode: Image.Pad
		source: "img/bg.png"
	}
/////////////////////////////////////////////////////////////////
/*===[ BGN Greeting ]===*/
    Text {
        id: greeting
        x: (Window.width - width)/2
        y: host.y + 50
        text: config.WelcomeText + "!"
        font.pixelSize: 48
        font.bold: true
		color: "#fff"
    }

    Glow {
        id: gl_greeting
        anchors.fill: greeting
        spread: 0.1
        radius: 20
        samples: 30
        color: greeting.color
        source: greeting
    }
/*===[ END Greeting ]===*/

/*===[ BGN Host ]===*/
    AnimatedImage {
		id: img_host
		y: 30
		x: (Window.width - width)/2 - (host.width/2 + 20)
        height: 30
        width: 30
		source: "img/computer.png"
		fillMode: Image.Stretch
	}

    Text {
        id: host
        y: 35
        x: (Window.width - width)/2 + 5
        height: 30
        text: config.HostNameText + ": " + sddm.hostName
        font.pixelSize: 20
        font.bold: true
		color: "#08f"
    }

    Glow {
        id: gl_img_host
        anchors.fill: img_host
        spread: 0.1
        radius: 10
        samples: 30
        color: "#08f"
        source: img_host
    }

    Glow {
        id: gl_host
        anchors.fill: host
        spread: 0.1
        radius: 10
        samples: 20
        color: "#08f"
        source: host
    }
/*===[ END Host ]===*/

/*===[ BGN DateTime ]===*/
    Text {
        id: datetime
        x: 10
        y: 10
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: Qt.formatDateTime(login_form.valueDT, "dddd\ndd MMMM yyyy\nHH:mm:ss")
        font.pixelSize: 28
        font.capitalization: Font.Capitalize
        font.bold: true
		color: "#08f"
    }

    Glow {
        id: gl_datetime
        anchors.fill: datetime
        spread: 0.1
        radius: 20
        samples: 20
        color: "#08f"
        source: datetime
    }
/*===[ END DateTime ]===*/

/*===[ BGN Avatar ]===*/
	ListView {
		id: icoUser
        x: (Window.width - width)/2 - 250
        y: Window.height - 170
        //z: 1

        model: userModel

		delegate: Image {
            id: avatar
			width: 100
			height: 100
			clip: true
			smooth: true
			asynchronous: true

            property var usrName: username.text
            property var iconSuffix: ".icon"

            source: findUsr(userModel, usrName, 3) + "/.face" + iconSuffix
		}
	}

    AnimatedImage{
        id: frame
        x: (Window.width - width)/2 - 200
        y: Window.height - 173
		width: self
		height: self
		source: "img/frame.png"
	}

    Glow {
        id: gl_frame
        anchors.fill: frame
        spread: 0.3
        radius: 20
        samples: 50
        color: "#000"
        source: frame
    }
/*===[ END Avatar ]===*/

/*===[ BGN Logos ]===*/
    AnimatedImage{
        y: 10
		x: Window.width - width - 10
		width: self
		height: self
		source: "img/logo.png"
	}

    AnimatedImage{
        id: logon
        y: (Window.height - height)/2
		x: (Window.width - width)/2
		width: self
		height: self
		source: "img/logon.gif"
	}

    Glow {
        id: gl_logon
        anchors.fill: logon
        spread: 0.1
        radius: 10
        samples: 10
        color: "#f90"
        source: logon
    }
/*===[ END Logos ]===*/

/*===[ BGN Language ]===*/
    AnimatedImage {
		id: img_kbd
		y: Window.height - height - 115
		x: language.x - width - 5
        height: 30
        width: 30
		source: "img/keyboard.png"
		fillMode: Image.Stretch
	}

    Label {
        id: lng_lbl
        y: Window.height - height - 140
		x: 10 + img_kbd.width + 5
        height: 25
        width: 200
        text: config.LanguageText + ":"
        color: "#c1b492"
        font.pixelSize: 16
    }

    ComboBox {
        id: language

        x: 45
        y: Window.height - height - 115
        width: 200
        height: 25

        color: "#111"
        borderColor: "#f0f"
        focusColor: "#f0f"
        hoverColor: "#08f"
        textColor: "#fff"
        menuColor: "#111"

        model: keyboard.layouts
        index: keyboard.currentLayout

        Connections {
            target: keyboard
            onCurrentLayoutChanged: combo.index = keyboard.currentLayout
        }

        onValueChanged: keyboard.currentLayout = id

        rowDelegate: Rectangle {
            color: "transparent"

            Image {
                width: 25
                height: 18

                anchors.margins: 3
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                verticalAlignment: Text.AlignVCenter

                source: "/usr/share/sddm/flags/%1.png".arg(modelItem ? modelItem.modelData.shortName : "zz")
            }

            Text {
                anchors.margins: 35
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                verticalAlignment: Text.AlignVCenter

                text: modelItem ? modelItem.modelData.longName : "? ? ?"

                font.pixelSize: 14
                font.bold: true

                color: "#fff"
            }
        }

        arrowIcon: "img/angle_down.png"
        arrowColor: "#111"

        KeyNavigation.tab: "%1".arg(!password.visible ? username : password)
    }

    Glow {
        id: gl_img_kbd
        anchors.fill: img_kbd
        spread: 0.1
        radius: 10
        samples: 30
        color: "#f0f"
        source: img_kbd
    }

    Glow {
        id: gl_language
        anchors.fill: language
        spread: 0.1
        radius: 10
        samples: 17
        color: "#f0f"
        source: language
    }
/*===[ END Language ]===*/

/*===[ BGN UserName ]===*/
    AnimatedImage {
		id: img_usr
		y: Window.height - height - 120
		x: (Window.width - width)/2 - (username.width/2 + 20)
        height: 30
        width: 30
		source: "img/usr.png"
		fillMode: Image.Stretch
	}

    Label {
        id: usr_lbl
        y: Window.height - height - 145
		x: (Window.width - width)/2
        height: 25
        width: 200
        text: config.UserText + ":"
        color: "#c1b492"
        font.pixelSize: 16
    }

    TextField {
        id: username
        y: Window.height - height - 120
		x: (Window.width - width)/2
        height: 25
        //text: userModel.lastUser

        style: TextFieldStyle {
            textColor: "#ff0"
            background: Rectangle {
                color: "#111"
                implicitWidth: 200
                border.color: "#08f"
                radius: 5
                border.width: 1
            }
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                event.accepted = true

                if (username.text == "") {
                    username.focus = true
                } else {
                    img_usr.visible = false
                    img_pwd.visible = true
                    echoModeBtn.visible = true
                    gl_img_usr.visible = false
                    gl_img_pwd.visible = true
                    gl_echoModeBtn.visible = true
                    gl_password.visible = true
                    gl_username.visible = false
                    password.visible = true
                    password.focus = true
                    username.visible = false
                    username.focus = false
                    pwd_lbl.visible = true
                    usr_lbl.visible = false
                }
            }
        }

        KeyNavigation.tab: "%1".arg(!password.visible ? username : password)
    }

    Glow {
        id: gl_img_usr
        anchors.fill: img_usr
        spread: 0.1
        radius: 10
        samples: 25
        color: "#08f"
        source: img_usr
    }

    Glow {
        id: gl_username
        anchors.fill: username
        spread: 0.1
        radius: 10
        samples: 17
        color: "#08f"
        source: username
    }
/*===[ END UserName ]===*/

/*===[ BGN Password ]===*/
    AnimatedImage {
		id: img_pwd
        visible: false
		y: Window.height - height - 120
		x: (Window.width - width)/2 - (password.width/2 + 20)
        height: 30
        width: 30
		source: "img/pwd.png"
		fillMode: Image.Stretch
	}

    Label {
        id: pwd_lbl
        y: Window.height - height - 145
		x: (Window.width - width)/2
        height: 25
        width: 200
        visible: false
        text: config.PasswordText + ":"
        color: "#c1b492"
        font.pixelSize: 16
    }

    TextField {
        id: password
        y: Window.height - height - 120
		x: (Window.width - width)/2
        height: 25
        visible: false
        echoMode: TextInput.Password

        style: TextFieldStyle {
            textColor: "#0f0"
            background: Rectangle {
                color: "#111"
                implicitWidth: 200
                border.color: "#0ff"
                radius: 5
                border.width: 1
            }
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                login_form.tryLogin()

                sddm.login(username.text, password.text, session.index)

                event.accepted = true
            }

            if (event.key === Qt.Key_Escape) {
                img_usr.visible = true
                img_pwd.visible = false
                gl_img_usr.visible = true
                    gl_img_pwd.visible = false
                echoModeBtn.visible = false
                gl_echoModeBtn.visible = false
                gl_password.visible = false
                gl_username.visible = true
                password.visible = false
                password.focus = false
                username.visible = true
                username.focus = true
                pwd_lbl.visible = false
                usr_lbl.visible = true
            }
        }

        KeyNavigation.tab: "%1".arg(!password.visible ? username : password)
    }

    AnimatedImage {
        id: echoModeBtn
        y: Window.height - height - 120
        x: ((Window.width - width)/2) + (password.width/2) + 20
        smooth: true
        width: 30
        height: 30
        source: "img/hight_pwd.png"
        fillMode: Image.Stretch
        visible: false

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onClicked: login_form.pwdShowHide()
        }
    }

    Glow {
        id: gl_img_pwd
        visible: false
        anchors.fill: img_pwd
        spread: 0.1
        radius: 10
        samples: 25
        color: "#0ff"
        source: img_pwd
    }

    Glow {
        id: gl_password
        visible: false
        anchors.fill: password
        spread: 0.1
        radius: 10
        samples: 17
        color: "#0ff"
        source: password
    }

    Glow {
        id: gl_echoModeBtn
        anchors.fill: echoModeBtn
        visible: false
        spread: 0.1
        radius: 10
        samples: 17
        color: "#f00"
        source: echoModeBtn
    }
/*===[ END Password ]===*/

/*===[ BGN Session ]===*/
    AnimatedImage {
		id: img_dm
		y: Window.height - height - 50
		x: (Window.width - width)/2 - (session.width/2 + 20)
        height: 30
        width: 30
		source: "img/dm.png"
		fillMode: Image.Stretch
	}

    Label {
        id: ses_lbl
        y: Window.height - height - 75
        x: (Window.width - width)/2
        height: 25
        width: 200
        text: config.SessionText + ":"
        color: "#c1b492"
        font.pixelSize: 16
    }

    ComboBox {
        id: session

        y: Window.height - height - 50
        x: (Window.width - width)/2
        height: 25
        width: 200

        Layout.alignment: Qt.AlignCenter

        model: sessionModel
        index: sessionModel.lastIndex

        color: "#111"
        borderColor: "#ff0"
        focusColor: "#ff0"
        hoverColor: "#08f"
        textColor: "#fff"
        menuColor   : "#111"

        font.pixelSize: 14
        font.bold: true

        arrowIcon: "img/angle_down.png"
        arrowColor: "#111"

        KeyNavigation.tab: "%1".arg(!password.visible ? username : password)
    }

    Glow {
        id: gl_img_dm
        anchors.fill: img_dm
        spread: 0.1
        radius: 10
        samples: 30
        color: "#ff0"
        source: img_dm
    }

    Glow {
        id: gl_session
        anchors.fill: session
        spread: 0.1
        radius: 10
        samples: 30
        color: "#ff0"
        source: session
    }
/*===[ END Session ]===*/

/*===[ BGN ErrMessage ]===*/
    Text {
        id: errorMessage
        visible: false
        x: (Window.width - width)/2
        y: Window.height - height - 200
        text: access
        font.pixelSize: 16
        font.bold: true
		color: "#fff"
    }

    Glow {
        id: gl_errorMessage
        visible: false
        anchors.fill: errorMessage
        spread: 0.2
        radius: 15
        samples: 20
        color: errorMessage.color
        source: errorMessage
    }

    AnimatedImage {
        id: caps
        y: Window.height - height - 120
        x: ((Window.width - width)/2) + (password.width/2) + width + 20
        smooth: true
        //width: 30
        //height: 30
        source: "img/caps.png"
        fillMode: Image.Pad
        visible: false
    }

    Glow {
        id: gl_caps
        anchors.fill: caps
        visible: false
        spread: 0.3
        radius: 15
        samples: 20
        color: "#f00"
        source: caps
    }
/*===[ END ErrMessage ]===*/

/*===[ BGN SysButton ]===*/
	AnimatedImage {
		id: shutdownBtn
		y: Window.height - height - 10
		x: Window.width - width - 10
		source: "img/shutdown.png"
		fillMode: Image.Pad
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true

			onClicked: sddm.powerOff()

			onEntered: {
                gl_shutdownBtn.color = "#ff0"
			}

            onExited: {
                gl_shutdownBtn.color = "#f00"
            }
		}
	}

    Glow {
        id: gl_shutdownBtn
        anchors.fill: shutdownBtn
        spread: 0.1
        radius: 10
        samples: 17
        color: "#f00"
        source: shutdownBtn
    }

	AnimatedImage {
		id: rebootBtn
		y: Window.height - height - 10
		x: Window.width - (shutdownBtn.width + width + 10) - 10
		source: "img/restart.png"
		fillMode: Image.Pad
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true

			onClicked: sddm.reboot()

			onEntered: {
                gl_rebootBtn.color = "#ff0"
			}

            onExited: {
                gl_rebootBtn.color = "green"
            }
		}
	}

    Glow {
        id: gl_rebootBtn
        anchors.fill: rebootBtn
        spread: 0.1
        radius: 10
        samples: 17
        color: "green"
        source: rebootBtn
    }
/*===[ END SysButton ]===*/

/*===[ BGN SysSound ]===*/
	Audio {
		id: bgMusic
		source: "snd/snd_bg.wav"
		autoPlay: true
		loops: Audio.Infinite
	}
	Audio {
		id: welcome
		source: "snd/snd_welcome.wav"
		autoPlay: true
	}

	Audio {
		id: denied
		source: "snd/snd_denied.wav"
	}

    Audio {
		id: allowed
		source: "snd/snd_allowed.wav"
	}

    Audio {
		id: capslock
		source: "snd/snd_caps.wav"
	}
/*===[ END SysSound ]===*/

/*===[ BGN ProcAnimation ]===*/

    Rectangle {
        id: processing

        x: (Window.width - width)/2//(parent.width  - (6 * 64)) / 2
        y: Window.height - height - 200//(parent.height - (1.5 * 64))
        width: (6 * 64)
        height: (64 / 4)

        visible: false

        color: "transparent"

        border.color: "#0f0"
        border.width: 1

        radius: 5

        Rectangle {
            id: processing_indicator

            x: 2
            y: 2
            width: (64 / 4) - 4
            height: parent.height - 4

            color: "#9500ff"

            radius: 5
        }

        SequentialAnimation {
            id: processing_anim

            running: false
            loops: Animation.Infinite

            NumberAnimation {
                target: processing_indicator
                property: "x"
                from: 0
                to: (6 * 64) - (64 / 4)
                duration: 2500
            }

            NumberAnimation {
                target: processing_indicator
                property: "x"
                to: 0
                duration: 2500
            }
        }

        Glow {
            id: gl_processing_indicator
            anchors.fill: processing_indicator
            //visible: false
            spread: 0.1
            radius: 10
            samples: 50
            color: gl_processing.color
            source: processing_indicator
        }
    }

    Glow {
        id: gl_processing
        anchors.fill: processing
        visible: false
        spread: 0.2
        radius: 20
        samples: 50
        color: "#0fd"
        source: processing
        }
/*===[ END ProcAnimation ]===*/

/////////////////////////////////////
	Component.onCompleted: {
        username.focus = true
        keyboard.numLock = true
	}
}
