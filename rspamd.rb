class Rspamd < Formula
  desc "Rspamd mail filtering system."
  homepage "https://rspamd.com"
  url "https://github.com/rspamd/rspamd/archive/2.6.tar.gz"
  sha256 "002aee47dc4d6f8c6c0572b58ccb0cbcbb9bb7689442c33a5a5cf893e72506db"
  license "Apache-2"

  depends_on "pkg-config"
  #depends_on "libunwind-headers" <- Be sure to install the MacPorts version.
  #depends_on "llvm" <- Cause issues when building
  depends_on "libsodium"

  depends_on "openssl@1.1"
  #depends_on "icu4c" <- Disabled. Cause x86 issues for some reason.
  depends_on "glib"
  depends_on "ragel"
  depends_on "lua"
  depends_on "luajit"
  depends_on "sqlite"
  depends_on "libmagic"
  #depends_on "pcre"
  depends_on "hyperscan"
  depends_on "zlib"
  depends_on "hiredis"
  depends_on "redis"
  depends_on "perl"
  depends_on "cmake" => :build

  def install
    #ENV["CMAKE_GENERATOR"] = "CodeBlocks - Unix Makefiles"
    #ENV["PATH"] = "/usr/local/Homebrew/Library/Homebrew/shims/mac/super:/usr/local/opt/cmake/bin:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
    ENV["CC"] = "/usr/bin/clang"
    ENV["CXX"] = "/usr/bin/clang++"
    #ENV["CC_PRINT_OPTIONS_FILE"] = "'#{buildpath}/.CC_PRINT_OPTIONS'"
    ENV["CFLAGS"] = "-pipe -Os -DNDEBUG -I/usr/local/include -isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk"
    ENV["CPATH"] = "/usr/local/include"
    ENV["CPPFLAGS"] = "-isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk"
    ENV["CXXFLAGS"] = "-pipe -Os -DNDEBUG -I/usr/local/include -stdlib=libc++ -isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk"
    ENV["DEVELOPER_DIR"] = "/Library/Developer/CommandLineTools"
    ENV["F90FLAGS"] = "-pipe -Os -m64"
    ENV["FCFLAGS"] = "-pipe -Os -m64"
    ENV["FFLAGS"] = "-pipe -Os -m64"
    ENV["INSTALL"] = "/usr/bin/install -c"
    ENV["LDFLAGS"] = "-L/usr/local/lib -Wl,-headerpad_max_install_names -Wl,-syslibroot,/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk"
    ENV["LIBRARY_PATH"] = "/usr/local/lib"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "10.15"
    ENV["OBJC"] = "/usr/bin/clang"
    ENV["OBJCFLAGS"] = "-pipe -Os -I/usr/local/include -isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk"
    ENV["OBJCXX"] = "/usr/bin/clang++"
    ENV["OBJCXXFLAGS"] = "-pipe -Os -DNDEBUG -I/usr/local/include -I/opt/local/include -stdlib=libc++ -isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk"
    ENV["SDKROOT"] = "/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk"

    args = %W[
      -GCodeBlocks\ \-\ Unix\ Makefiles
      -DCMAKE_BUILD_TYPE=RelWithDebuginfo
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DCMAKE_SYSTEM_PREFIX_PATH=/usr/local;/usr
      -DCMAKE_C_COMPILER=/usr/bin/clang
      -DCMAKE_CXX_COMPILER=/usr/bin/clang++
      -DCMAKE_POLICY_DEFAULT_CMP0025=NEW
      -DCMAKE_POLICY_DEFAULT_CMP0060=NEW
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -DCMAKE_COLOR_MAKEFILE=ON
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
      -DCMAKE_MAKE_PROGRAM=/usr/bin/make
      -DCMAKE_MODULE_PATH=/usr/local/share/cmake/Modules
      -DCMAKE_PREFIX_PATH=/usr/local/share/cmake/Modules
      -DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
      -Wno-dev
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
      -DCONFDIR=#{etc}/rspamd
      -DDBDIR=/usr/local/Server/Mail/Data/rspamd
      -DENABLE_LUAJIT=ON
      -DNO_SHARED=ON
      -DENABLE_SNOWBALL=ON
      -DENABLE_LIBUNWIND=ON
      -DENABLE_HYPERSCAN=ON
      -DENABLE_FANN=ON
      -DLIBDIR=#{lib}
      -DLOGDIR=#{var}/log/rspamd
      -DMANDIR=#{man}
      -DPCRE_ROOT_DIR=/usr/lib
      -DRSPAMD_USER=_rspamd
      -DRUNDIR=#{var}/run/rspamd
      -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15
      -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk
      -DENABLE_FULL_DEBUG=ON
      -DCMAKE_SET_OSX_ARCHITECTURES=NO
    ]
#    -DENABLE_LIBUNWIND=ON
#    -DENABLE_LUA_REPL=ON


    #system "mkdir rspamd.build"
    #system "cd rspamd.build"
    #system "cmake", ""
    #system "/opt/local/bin/cmake", *args2
    #system "printenv"
    system "/usr/local/bin/cmake", *args, "#{buildpath}"
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
