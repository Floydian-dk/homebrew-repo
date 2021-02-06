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



  def install
    ccargs = %W[
      CCARGS='-DNO_PCRE
      -DUSE_TLS
      -DHAS_SSL
      -DHAS_PCRE
      -DUSE_SASL_AUTH
      -DDEF_SERVER_SASL_TYPE=dovecot
      -DHAS_MYSQL -I/usr/local/include/mysql'
    ]

    auxlibs =%W[
      AUXLIBS='-lpcre
      -lssl
      -lcrypto
      -L/usr/local/lib -lmysqlclient -lz -lm'
    ]

    args2 = %W[
        -non-interactive
        install_root=#{prefix}
        config_directory=#{etc}/postfix
        queue_directory=#{var}/spool/postfix
        command_directory=#{sbin}
        daemon_directory=#{libexec}/postfix
        data_directory=#{lib}/postfix
        sendmail_path=#{sbin}/sendmail
        newaliases_path=#{bin}/newaliases
        mailq_path=#{bin}/mailq
        etc_directory=#{etc}/postfix
        share_directory=#{share}/postfix
        manpage_directory=#{share}/man
        sample_directory=#{share}/postfix/sample
        readme_directory=#{share}/postfix/readme
        mail_owner=_postfix
        setgid_group=_postdrop
    ]

    system "make", "makefiles", *ccargs, *auxlibs
    system "/bin/sh", "postfix-install", *args2

  end


  def caveats
    <<~EOS
      For Postfix to work you may have to create a postfix user
      and group depending on your configuration file options.
    EOS
  end
end
