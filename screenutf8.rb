class Screenutf8 < Formula
  homepage "https://www.gnu.org/software/screen"

  stable do
    url "http://ftpmirror.gnu.org/screen/screen-4.5.0.tar.gz"
    mirror "https://ftp.gnu.org/gnu/screen/screen-4.5.0.tar.gz"
    sha256 "01c3a7c362185f35d6a95dff52d64337076496acd034d717de3c263500cfefb0"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end

    # These patches are to fix character corruptions on UTF-8
    if build.include? "utf8"
      patch :p2 do
        #url "https://gist.github.com/raw/626040/be6a04f0e64c56185ba5850415ac59dad4cd62a0/screen-utf8-nfd.patch"
        url "https://gist.githubusercontent.com/rcmdnk/5e72a6fd14bf106f9d410ea68adf0644/raw/be75f51d16e5a24bcee9d357f785e95b008814df/screen-utf8-nfd.patch"
        sha256 "ce62334111561c5b45a48fd0caddf1aaafe7ccdd4dd94223288bf3d53e72fbe7"
      end
      patch :p2 do
        #url "http://zuse.jp/misc/screen-utf8-osc.diff"
        url "https://gist.githubusercontent.com/rcmdnk/1bbd244db301d9628816aad5fedd35a5/raw/71b09a37dff88c74098e4ebf584b06c889d7a3fb/screen-utf8-osc.diff"
        sha256 "91ca39e8dd2e2168f468eb4ccb63d47ea1d8df9dc9be9de0d655a65881ab1744"
      end
    end
  end

  head do
    url "git://git.savannah.gnu.org/screen.git"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end

    # These patches are to fix character corruptions on UTF-8
    if build.include? "utf8"
      patch do
        #url "https://gist.github.com/raw/626040/be6a04f0e64c56185ba5850415ac59dad4cd62a0/screen-utf8-nfd.patch"
        url "https://gist.githubusercontent.com/rcmdnk/5e72a6fd14bf106f9d410ea68adf0644/raw/be75f51d16e5a24bcee9d357f785e95b008814df/screen-utf8-nfd.patch"
        sha256 "ce62334111561c5b45a48fd0caddf1aaafe7ccdd4dd94223288bf3d53e72fbe7"
      end
      patch do
        #url "http://zuse.jp/misc/screen-utf8-osc.diff"
        url "https://gist.githubusercontent.com/rcmdnk/1bbd244db301d9628816aad5fedd35a5/raw/71b09a37dff88c74098e4ebf584b06c889d7a3fb/screen-utf8-osc.diff"
        sha256 "91ca39e8dd2e2168f468eb4ccb63d47ea1d8df9dc9be9de0d655a65881ab1744"
      end
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  option "utf8", "Apply patches for utf8"

  def install
    if build.head?
      cd "src"
    end

    # With parallel build, it fails
    # because of trying to compile files which depend osdef.h
    # before osdef.sh script generates it.
    ENV.deparallelize

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-colors256"
    system "make"
    system "make install"
  end
end
