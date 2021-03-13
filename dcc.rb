class Bind < Formula
  desc "FLOYD Custom Implementation The Distributed Checksum Clearinghouses or DCC"
  homepage "https://www.dcc-servers.net/dcc/"
  url "https://www.dcc-servers.net/dcc/source/dcc.tar.Z"
  sha256  "e5da87aca80ddc8bc52fa93869576a2afaf0c1e563e3f97dee6e6531690fbad5"
  license "Free only to organizations that participate in the global DCC network"

  depends_on "pkg-config" => :build

  def install

    args = %W[
      --homedir=#{etc}/dcc
      --bindir=#{bin}
      --libexecdir=#{libexec}
      --mandir=#{man}
      --with-rundir=#{var}/run/dcc
      --enable-64-bits
      --disable-dccm
      --with-uid=_rspamd
      --with-installroot=#{HOMEBREW_PREFIX}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

end
