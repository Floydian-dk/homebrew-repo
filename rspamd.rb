class Rspamd < Formula
  desc "Rspamd mail filtering system."
  homepage "https://rspamd.com"
  url "https://github.com/rspamd/rspamd/archive/2.6.tar.gz"
  sha256 "8ca3b2ec812adf4b6f3f8354f64520b54e04f509eb62443cd10819c51dc5cc69"
  license "Apache-2"

  depends_on "openssl@1.1"
  depends_on "icu4c"
  depends_on "glib"
  depends_on "ragel"
  depends_on "lua"
  depends_on "luajit"
  depends_on "sqlite"
  depends_on "libmagic"
  depends_on "pcre"
  depends_on "hyperscan"
  depends_on "zlib"
  depends_on "hiredis"
  depends_on "redis"
  depends_on "perl"

  def install
    args = %W[
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCONFDIR=/usr/local/Server/Mail/Config/rspamd
      -DDBDIR=#{var}/lib/rspamd
      -DENABLE_FANN=ON
      -DENABLE_GD=ON
      -DENABLE_HYPERSCAN=ON
      -DENABLE_LIBUNWIND=ON
      -DENABLE_LUAJIT=ON
      -DENABLE_SNOWBALL=ON
      -DENABLE_TORCH=ON
      -DINSTALL_EXAMPLES=ON
      -DLIBDIR=${prefix}/lib
      -DLOGDIR=/var/log/rspamd
      -DMANDIR=#{man}
      -DNO_SHARED=ON
      -DPCRE_ROOT_DIR=/usr/lib
      -DRSPAMD_USER=_rspamd
      -DRUNDIR=${prefix}/var/run/${name}
    ]

    system "mkdir rspamd.build"
    system "cd rspamd.build"
    system "cmake ../rspamd", *args
    system "make"
    system "make install"
  end

  def caveats
    <<~EOS
      For Rspamd to work you may have to create a rspamd user
      and group depending on your configuration file options.
    EOS
  end
end
