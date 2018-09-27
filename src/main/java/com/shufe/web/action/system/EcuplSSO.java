package com.shufe.web.action.system;

import java.io.FileInputStream;
import java.net.URLEncoder;
import java.security.PublicKey;
import java.security.cert.CertificateFactory;

import javax.crypto.Cipher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.shufe.web.action.common.CalendarRestrictionSupportAction;

//加密类
public class EcuplSSO extends CalendarRestrictionSupportAction {

  public ActionForward index(ActionMapping mapping, ActionForm form, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    addSingleParameter(request, "bh", URLEncoder.encode(en(getUser(request).getName())));
    return forward(request);
  }

  public String en(String bh) throws Exception {
    CertificateFactory cff = CertificateFactory.getInstance("X.509");
    // /opt/apache-tomcat-7.0.22/webapps/eams/HDZF.cer
    FileInputStream fis1 = new FileInputStream("/opt/apache-tomcat-7.0.22/webapps/eams/HDZF.cer"); // 证书文件
    java.security.cert.Certificate cf = cff.generateCertificate(fis1);
    PublicKey pk1 = cf.getPublicKey(); // 得到证书文件携带的公钥
    Cipher c1 = Cipher.getInstance("RSA/ECB/PKCS1Padding"); // 定义算法：RSA
    c1.init(Cipher.ENCRYPT_MODE, pk1);
    byte[] enbh = c1.doFinal(bh.getBytes());
    StringBuffer buffer = new StringBuffer();
    for (byte b : enbh) {
      buffer.append(b);
      buffer.append("#");
    }
    if (buffer.length() > 0) {
      buffer.deleteCharAt(buffer.length() - 1);
    }
    return buffer.toString();
    // 把这个值用URLEncoder.encode处理后放到http://202.121.166.174/bysj/sso.htm?bh=URLEncoder.encode(buffer.toString())中
  }
}
