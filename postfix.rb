class Postfix < Formula
  desc "Fast and robust mail transfer agent, Custom version for FLOYD Interactive"
  homepage "http://www.postfix.org"
  # Should only be updated if the new version is announced on the homepage, http://www.postfix.org
  url "https://de.postfix.org/ftpmirror/official/postfix-3.6.5.tar.gz"
  mirror "ftp://ftp.pca.dfn.de/pub/tools/net/postfix/official/postfix-3.6.5.tar.gz"
  sha256 "300fa8811cea20d01d25c619d359bffab82656e704daa719e0c9afc4ecff4808"
  license "IBMPL-1 EPL-2"

  depends_on "openssl@1.1"
  depends_on "mariadb@10.6"
  depends_on "pcre2" => :build
  depends_on "icu4c"
  depends_on "berkeley-db@4" => :build


  def install

    inreplace "postfix-install" do |s|
      s.gsub! "$install_root$queue_directory", "$queue_directory"
      s.gsub! "$install_root$meta_directory", "$meta_directory"
      s.gsub! "$install_root$config_directory", "$config_directory"
      s.gsub! "$install_root$command_directory", "$command_directory"
      s.gsub! "$install_root$shlib_directory", "$shlib_directory"
      #s.gsub! "$install_root$daemon_directory", "$daemon_directory"
    end

    ccargs = %w[
      CCARGS='-DUSE_SASL_AUTH
      -DDEF_SERVER_SASL_TYPE=\\\"dovecot\\\"
      -DDEF_COMMAND_DIR=\\\"/usr/local/sbin\\\"
      -DDEF_CONFIG_DIR=\\\"/usr/local/Server/Mail/Config/postfix\\\"
      -DDEF_DAEMON_DIR=\\\"/usr/local/libexec/postfix\\\"
      -DUSE_TLS
      -DHAS_PCRE=2
      -DHAS_SSL -I#{Formula["openssl@1.1"].opt_prefix}
      -DHAS_MYSQL -I#{Formula["mariadb@10.6"].opt_prefix}/include/mysql'
    ]

    auxlibspcre =%W[
      AUXLIBS_PCRE='-L#{Formula["pcre2"].opt_prefix}/lib
      -lpcre2-8'
    ]

    auxlibsmysql =%W[
      AUXLIBS_MYSQL='-L#{Formula["mariadb@10.6"].opt_prefix}/lib
      -R#{Formula["mariadb@10.6"].opt_prefix}/lib
      -lmysqlclient
      -lz
      -lm'
    ]

    args5 = %W[
        -non-interactive
        install_root=#{prefix}
        tempdir=#{buildpath}
        data_directory=/usr/local/Server/Mail/Data/mta
        mail_owner=_postfix
        mailq_path=/bin/mailq
        newaliases_path=/bin/newaliases
        queue_directory=/usr/local/Server/Mail/Data/spool
        sendmail_path=/sbin/sendmail
        setgid_group=_postdrop
        shlib_directory=#{lib}/postfix
        daemon_directory=/libexec/postfix
        command_directory=\"#{sbin}\"
        manpage_directory=/share/man
        meta_directory=#{etc}/postfix
        config_directory=\"#{etc}/postfix\"
    ]

    system "make",
#    "-f",
#    "Makefile.init",
    "makefiles",
    "CC=#{ENV.cc}",
    "CCARGS=-DDEF_CONFIG_DIR=\\\"/usr/local/Server/Mail/Config/postfix\\\" -DUSE_SASL_AUTH -DDEF_SERVER_SASL_TYPE=\\\"dovecot\\\" -DDEF_COMMAND_DIR=\\\"/usr/local/sbin\\\" -DDEF_DAEMON_DIR=\\\"/usr/local/libexec/postfix\\\" -DUSE_TLS -DHAS_PCRE=2 -DHAS_SSL -I#{Formula["openssl@1.1"].opt_prefix} -DHAS_MYSQL -I#{Formula["mariadb@10.6"].opt_prefix}/include/mysql -I/usr/local/include",
    "AUXLIBS=-ldb",
    "AUXLIBS_MYSQL=-L#{Formula["mariadb@10.6"].opt_prefix}/lib -R#{Formula["mariadb@10.6"].opt_prefix}/lib -lmysqlclient -lz -lm"
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
