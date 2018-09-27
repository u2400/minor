//计算字符串的字节数长度
function getStringLength(str) {
	if (str == null || str == "") {
		return 0;
	}
	var strLen = 0;
	for (var i = 0; i < str.length; i ++) {
		if (Math.abs(str.charCodeAt(i)) <= 255) {
			strLen ++;
		} else {
			strLen += 2;
		}
	}
	return strLen;
}

// 获取截取的字符串
function getSubtString(str, fromPoint, pointLength) {
	if (str == null || str == "" || fromPoint + "" == null || fromPoint + "" == "" || pointLength + "" == null || pointLength + "" == "") {
		return null;
	}
	var strLen = 0;
	var i = fromPoint;
	for (; i < str.length; i ++) {
		if (Math.abs(str.charCodeAt(i)) <= 255) {
			strLen ++;
		} else {
			strLen += 2;
		}
		if (strLen == pointLength) {
			return str.substring(fromPoint, i);
		} else if (strLen > pointLength) {
		    return str.substring(fromPoint, i - 1);
		}
	}
	return str.substring(fromPoint);
}

// 去除字符串的所有空格
function cleanSpaces(str) {
	if (str == null || str == "") {
		return str;
	}
	
	return str.replace(" ", "");
}

// 检查字符串是否为A-Z和0-9组成的字符串
function isStringAZ09(str) {
	if (str == null || str == "") {
		return false;
	}
	
	for (var i = 0; i < str.length; i++) {
		if ((str.charCodeAt(i) >= "0".charCodeAt(0) && str.charCodeAt(i) <= "9".charCodeAt(0) || str.charCodeAt(i) >= "A".charCodeAt(0) && str.charCodeAt(i) <= "Z" || str.charCodeAt(i) >= "a".charCodeAt(0) && str.charCodeAt(i) <= "z".charCodeAt(0)) == false) {
			return false;
		}
	}
	return true;
}

// 查询TextArea字符长度，长度可自定义,默认200
function checkTextLength(textAreaContent, displayTitle, maxLength) {
	if (maxLength == null || maxLength == "") {
		maxLength = 200;
	}
    if (getStringLength(textAreaContent, maxLength) > maxLength) {
    	alert(displayTitle + "不能超过" + maxLength + "个字符！");
    	return false;
    }
    return true;
}

function autoWardString(textAreaContent, wardLength) {
    var wLength = wardLength;
    var wardString = "";
    if (null == wLength || "" == wLength) {
        wLength = 20;
    }
    var i = 0;
    for (; i < textAreaContent.length; ) {
        var value = getSubtString(textAreaContent, i, wLength)
        wardString += value;
        if (i + value.length < textAreaContent.length) {
            wardString += "\n";
        }
        i += value.length
    }
    if (null != wardString && "" != wardString) {
        wardString += textAreaContent.substring(i);
    }
    return wardString;
}
