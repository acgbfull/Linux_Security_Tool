#!/bin/bash
#设置屏幕大小
resize -cu -s 40 90 > /dev/null
#函数定义
httpd_restart(){
    service httpd restart
}

sshd_restart(){
    service sshd restart
}

smb_restart(){
    /etc/init.d/smb restart
}

#主循环
while true
do
    clear
    #PS1=${debian_chroot:+($debian_chroot)}\u@\h:\w\$
    #PS1='\[\e[32;1;5m\]\u@\h \w\t\$\[\e[1m\]'
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m------------------Linux部分常见漏洞修复工具------------------\033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m       1：隐藏php版本                                        \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m       2：隐藏appache版本                                    \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m       3：不显示Samba版本                                    \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m       4：远端WWW服务支持TRACE请求漏洞修复                   \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m       5：SSH 服务支持弱加密算法漏洞修复                     \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m       6：SSL 3.0 POODLE攻击信息泄露漏洞                     \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m       7：SSL/TLS 受诫礼(BAR-MITZVAH)攻击漏洞修复            \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m       q: 退出                                               \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m                                          By acgbfull        \033[0m"
    echo -e "\033[32;1m                                https://github.com/acgbfull/ \033[0m"
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m--------------------------------------------------------------\033[0m"
    read -p "请输入所需执行的功能(1 2 3 4 5 6 7 q):" -n 1 num
    echo
    time=$(date "+%Y%m%d-%H%M%S")
    case $num in
      1)#1：隐藏php版本
        cp -n /etc/php.ini /etc/php.ini.${time}.bak
        sed -i 's/expose_php = On/expose_php = Off/g' /etc/php.ini
        httpd_restart
        ;;
      2)#2：隐藏appache版本
        cp -n /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.${time}.bak
        sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/httpd/conf/httpd.conf
        sed -i 's/ServerTokens Full/ServerTokens Prod/g' /etc/httpd/conf/httpd.conf
        sed -i 's/ServerTokens OS/ServerTokens Prod/g' /etc/httpd/conf/httpd.conf
        httpd_restart
        ;;
      3)#3：不显示Samba版本
        cp -n /etc/samba/smb.conf /etc/samba/smb.conf.${time}.bak
        sed -i 's/Samba Server Version %v/Samba Server Version/g' /etc/samba/smb.conf
        smb_restart
        ;;
      4)#4：远端WWW服务支持TRACE请求漏洞修复
        cp -n /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.${time}.bak
        echo "TraceEnable Off" >> /etc/httpd/conf/httpd.conf
        httpd_restart
        ;;
      5)#5：SSH 服务支持弱加密算法漏洞修复
        cp -n /etc/ssh/sshd_config /etc/ssh/sshd_config.${time}.bak
        echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc" >> /etc/ssh/sshd_config
        sshd_restart
        ;;
      6)#6：SSL 3.0 POODLE攻击信息泄露漏洞
        cp -n /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.${time}.bak
        sed -i 's/SSLProtocol All -SSLv2/SSLProtocol All -SSLv2 -SSLv3/g' /etc/httpd/conf.d/ssl.conf
        sed -i 's/SSLProtocol all -SSLv2/SSLProtocol All -SSLv2 -SSLv3/g' /etc/httpd/conf.d/ssl.conf
        sshd_restart
        ;;
      7)#7：SSL/TLS 受诫礼(BAR-MITZVAH)攻击漏洞修复
        cp -n /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.${time}.bak
        sed -i 's/SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5/SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5:!RC4/g' /etc/httpd/conf.d/ssl.conf
        sshd_restart
        ;;
      q)#q：退出
        exit 0
        ;;
      *)
        ;;
    esac
    echo -e "\033[32;1m                                                             \033[0m"
    echo -e "\033[32;1m漏洞修复完毕                                                  \033[0m"
    echo -e "\033[32;1m--------------------------------------------------------------\033[0m"
    read -p "按任意键继续" -n 1 num
done
