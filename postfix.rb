# Postfix formula by FLOYD Interactive
class Postfix < Formula
  desc "Fast and robust mail transfer agent, Custom version for FLOYD Interactive"
  homepage "https://www.postfix.org"
  # Should only be updated if the new version is announced on the homepage, http://www.postfix.org
  url "https://de.postfix.org/ftpmirror/official/postfix-3.7.3.tar.gz"
  mirror "ftp://ftp.pca.dfn.de/pub/tools/net/postfix/official/postfix-3.7.3.tar.gz"
  sha256 "d22f3d37ef75613d5d573b56fc51ef097f2c0d0b0e407923711f71c1fb72911b"
  license any_of: ["IPL-1.0", "EPL-2.0"]

  depends_on "openssl@1.1"
  depends_on "floydian-dk/repo/mariadb@10.6"
  depends_on "pcre2"
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
      -DHAS_PCRE -I/usr/local/include
      -DHAS_SSL -I#{Formula["openssl@1.1"].opt_prefix}
      -DHAS_MYSQL -I#{Formula["mariadb@10.6"].opt_prefix}/include/mysql'
    ]

    auxlibspcre =%W[
      AUXLIBS_PCRE='-L/usr/local/lib
      -lpcre'
    ]

    auxlibsmysql =%W[
      AUXLIBS_MYSQL='-L#{Formula["mariadb@10.6"].opt_prefix}/lib
      -R#{Formula["mariadb@10.6"].opt_prefix}/lib
      -lmysqlclient
      -lz
      -lm'
    ]

    postargs = %W[
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
    "CCARGS=-DDEF_CONFIG_DIR=\\\"/usr/local/Server/Mail/Config/postfix\\\" -DUSE_SASL_AUTH -DDEF_SERVER_SASL_TYPE=\\\"dovecot\\\" -DDEF_COMMAND_DIR=\\\"/usr/local/sbin\\\" -DDEF_DAEMON_DIR=\\\"/usr/local/libexec/postfix\\\" -DUSE_TLS -DHAS_PCRE -I/usr/local/include -DHAS_SSL -I/usr/local/opt/openssl@1.1 -DHAS_MYSQL -I#{Formula["mariadb@10.6"].opt_prefix}/include/mysql -I/usr/local/include",
    "AUXLIBS=-ldb",
    "AUXLIBS_PCRE=-L/usr/local/lib -lpcre",
    "AUXLIBS_MYSQL=-L#{Formula["mariadb@10.6"].opt_prefix}/lib -R#{Formula["mariadb@10.6"].opt_prefix}/lib -lmysqlclient -lz -lm"
    system "make"

    system "/bin/sh", "postfix-install", *postargs
    #system "make", "install", *args3

  end


  def caveats
    <<~EOS
      For Postfix to work you may have to create a postfix user
      and group depending on your configuration file options.
    EOS
  end
end
