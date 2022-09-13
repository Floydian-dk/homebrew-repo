# Postfix formula by FLOYD Interactive
class Postfix < Formula
  desc "Fast and robust mail transfer agent, Custom version for FLOYD Interactive"
  homepage "https://www.postfix.org"
  # Should only be updated if the new version is announced on the homepage, http://www.postfix.org
  url "https://de.postfix.org/ftpmirror/official/postfix-3.7.2.tar.gz"
  mirror "ftp://ftp.pca.dfn.de/pub/tools/net/postfix/official/postfix-3.7.2.tar.gz"
  sha256 "3785f76c2924a02873c0be0f0cd124a9166fc1aaf77ea2a06bd4ad795a6ed416"
  license any_of: ["IPL-1.0", "EPL-2.0"]
  revision 1

  depends_on "berkeley-db@4" => :build
  depends_on "icu4c"
  depends_on "mariadb@10.6"
  depends_on "openssl@1.1"
  depends_on "pcre2"

  def install

    inreplace "postfix-install" do |s|
      s.gsub! "$install_root$queue_directory", "$queue_directory"
      s.gsub! "$install_root$meta_directory", "$meta_directory"
      s.gsub! "$install_root$config_directory", "$config_directory"
      s.gsub! "$install_root$command_directory", "$command_directory"
      s.gsub! "$install_root$shlib_directory", "$shlib_directory"
      # s.gsub! "$install_root$daemon_directory", "$daemon_directory"
    end

    ccargs = %W[
      CCARGS=-DUSE_SASL_AUTH
      -DDEF_SERVER_SASL_TYPE=dovecot
      -DDEF_COMMAND_DIR=/usr/local/sbin
      -DDEF_CONFIG_DIR=/usr/local/Server/Mail/Config/postfix
      -DDEF_DAEMON_DIR=/usr/local/libexec/postfix
      -DHAS_PCRE -I/usr/local/include
      -DUSE_TLS
      -DHAS_SSL -I#{Formula["openssl@1.1"].opt_prefix}
      -DHAS_MYSQL -I#{Formula["mariadb@10.6"].opt_prefix}/include/mysql
    ]

    auxlibspcre =%W[
      AUXLIBS_PCRE=-L/usr/local/lib
      -lpcre
    ]

    auxlibsmysql =%W[
      AUXLIBS_MYSQL=-L#{Formula["mariadb@10.6"].opt_prefix}/lib
      -R#{Formula["mariadb@10.6"].opt_prefix}/lib
      -lmysqlclient
      -lz
      -lm
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

    system "make", "makefiles", "CC=#{ENV.cc}", ccargs, auxlibspcre, auxlibsmysql
    system "make"

    system "/bin/sh", "postfix-install", *postargs
    # system "make", "install", *args3
  end

  def caveats
    <<~EOS
      For Postfix to work you may have to create a postfix user
      and group depending on your configuration file options.
    EOS
  end

  test do
  end
end
