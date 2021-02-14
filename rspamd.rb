class Rspamd < Formula
  desc "Rspamd mail filtering system."
  homepage "https://rspamd.com"
  url "https://github.com/rspamd/rspamd/archive/2.6.tar.gz"
  sha256 "002aee47dc4d6f8c6c0572b58ccb0cbcbb9bb7689442c33a5a5cf893e72506db"
  license "Apache-2"

  depends_on "pkg-config"
  depends_on "libunwind-headers"
  depends_on "llvm"
  depends_on "libsodium"

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
  depends_on "cmake" => :build

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
      -DLIBDIR=#{lib}
      -DLOGDIR=/var/log/rspamd
      -DMANDIR=#{man}
      -DNO_SHARED=ON
      -DPCRE_ROOT_DIR=/usr/lib
      -DRSPAMD_USER=_rspamd
      -DRUNDIR=#{var}/run/rspamd
    ]

    #system "mkdir rspamd.build"
    #system "cd rspamd.build"
    system "cmake", *args
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
