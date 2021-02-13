class Postfix < Formula
  desc "Fast and robust mail transfer agent, Custom version for FLOYD Interactive"
  homepage "http://www.postfix.org"
  # Should only be updated if the new version is announced on the homepage, http://www.postfix.org
  url "https://de.postfix.org/ftpmirror/official/postfix-3.5.9.tar.gz"
  mirror "ftp://ftp.pca.dfn.de/pub/tools/net/postfix/official/postfix-3.5.9.tar.gz"
  sha256 "51ced5a3165a415beba812b6c9ead0496b7172ac6c3beb654d2ccd9a1b00762b"
  license "IBMPL-1 EPL-2"

  depends_on "openssl@1.1"
  depends_on "mariadb@10.4"
  depends_on "pcre"
  depends_on "icu4c"


  def install

    inreplace "postfix-install" do |s|
      s.gsub! "$install_root$queue_directory", "$queue_directory"
      s.gsub! "$install_root$meta_directory", "$meta_directory"
      s.gsub! "$install_root$config_directory", "$config_directory"
      #s.gsub! "$install_root$daemon_directory", "$daemon_directory"
    end

    ccargs = %W[
      CCARGS='-DUSE_SASL_AUTH
      -DDEF_SERVER_SASL_TYPE=\\\"dovecot\\\"
      -DDEF_COMMAND_DIR=\\\"/usr/local/sbin\\\"
      -DDEF_CONFIG_DIR=\\\"/usr/local/Server/Mail/Config/postfix\\\"
      -DDEF_DAEMON_DIR=\\\"/usr/local/libexec/postfix\\\"
      -DUSE_TLS
      -DHAS_PCRE -I/usr/local/include
      -DHAS_SSL -I#{Formula["openssl@1.1"].opt_prefix}
      -DHAS_MYSQL -I#{Formula["mariadb@10.4"].opt_prefix}/include/mysql'
    ]

    auxlibspcre =%W[
      AUXLIBS_PCRE='-L/usr/local/lib
      -lpcre'
    ]

    auxlibsmysql =%W[
      AUXLIBS_MYSQL='-L#{Formula["mariadb@10.4"].opt_prefix}/lib
      -R#{Formula["mariadb@10.4"].opt_prefix}/lib
      -lmysqlclient
      -lz
      -lm'    ]

    args2 = %W[
        -non-interactive
        install_root=/
        tempdir=#{buildpath}
        data_directory=#{var}/lib/postfix
        mail_owner=_postfix
        mailq_path=#{bin}/mailq
        newaliases_path=#{bin}/newaliases
        queue_directory=#{var}/spool/postfix
        sendmail_path=#{sbin}/sendmail
        setgid_group=_postdrop
        shlib_directory=#{lib}/postfix
        daemon_directory=/libexec/postfix
        command_directory=#{sbin}
        manpage_directory=#{man}
        config_directory=#{etc}/postfix
        meta_directory=#{etc}/postfix
    ]

    args3 = %W[
      install_root=/
      tempdir=#{buildpath}
      data_directory=#{var}/lib/postfix
      mail_owner=_postfix
      mailq_path=#{bin}/mailq
      newaliases_path=#{bin}/newaliases
      queue_directory=#{var}/spool/postfix
      sendmail_path=#{sbin}/sendmail
      setgid_group=_postdrop
      shlib_directory=#{lib}/postfix
      daemon_directory=#{libexec}/postfix
      command_directory=#{sbin}
      manpage_directory=#{man}
      config_directory=#{etc}/postfix
      meta_directory=#{etc}/postfix
    ]

    args4 = %W[
        install_root=#{prefix}
        tempdir=#{buildpath}
        data_directory=/usr/local/Server/Mail/Data/mta
        mail_owner=_postfix
        mailq_path=/bin/mailq
        newaliases_path=/bin/newaliases
        queue_directory=#{var}/spool/postfix
        sendmail_path=/sbin/sendmail
        setgid_group=_postdrop
        shlib_directory=/lib/postfix
        daemon_directory=/libexec/postfix
        command_directory=/sbin
        manpage_directory=/man
        meta_directory=/usr/local/Server/Mail/Config/postfix
    ]

    args5 = %W[
        -non-interactive
        install_root=#{prefix}
        tempdir=#{buildpath}
        data_directory=/usr/local/Server/Mail/Data/mta
        mail_owner=_postfix
        mailq_path=#{bin}/mailq
        newaliases_path=#{bin}/newaliases
        queue_directory=/usr/local/Server/Mail/Data/spool
        sendmail_path=#{sbin}/sendmail
        setgid_group=_postdrop
        shlib_directory=#{lib}/postfix
        daemon_directory=#{libexec}/postfix
        command_directory=#{sbin}
        manpage_directory=/share/man
        meta_directory=#{etc}/postfix
        config_directory=#{etc}/postfix
    ]

    system "make",
    "-f",
    "Makefile.init",
    "makefiles",
    *ccargs,
    *auxlibspcre,
    *auxlibsmysql
#    "CCARGS=\"-DUSE_SASL_AUTH -DDEF_SERVER_SASL_TYPE=dovecot -DDEF_COMMAND_DIR=/usr/local/sbin -DDEF_CONFIG_DIR=/usr/local/etc/postfix -DDEF_DAEMON_DIR=/usr/local/libexec/postfix -DUSE_TLS -DHAS_PCRE -I/usr/local/include -DHAS_SSL -I/usr/local/Cellar/openssl@1.1/1.1.1i/include -DHAS_MYSQL -I/usr/local/Cellar/mariadb@10.4/10.4.17/include/mysql\"",
#    "AUXLIBS_PCRE=-L/usr/local/lib -lpcre",
#    "AUXLIBS_MYSQL=-L/usr/local/opt/mariadb@10.4/lib -R/usr/local/opt/mariadb@10.4/lib -lmysqlclient -lz -lm"

    system "make"

    system "/bin/sh", "postfix-install", *args5
    #system "make", "install", *args3

  end


  def caveats
    <<~EOS
      For Postfix to work you may have to create a postfix user
      and group depending on your configuration file options.
    EOS
  end
end
