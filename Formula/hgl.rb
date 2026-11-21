# frozen_string_literal: true

# Installs the published HGL bundle with its SDK.
class Hgl < Formula
  desc "Compiler for the HGL language"
  homepage "https://github.com/hhenson/hgl-compiler"
  url "https://github.com/hhenson/hgl-compiler/releases/download/0.2.0/hgl-0.2.0-macos-arm64.tar.gz"
  sha256 "559854840c55ae47f616032634da3dcd24418b742acce05b795349ff49de36db"
  license "MIT"

  bottle do
    root_url "https://github.com/hhenson/hgl-compiler/releases/download/0.2.0"
    sha256 cellar: :any, arm64_tahoe: "b3a1d2fbaf06dc2eadac6769823da65a82979a88306a53df662f5cd3fbd047b3"
  end

  depends_on arch: :arm64
  depends_on "cmake"
  depends_on macos: :tahoe
  depends_on "ninja"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/hgl"
  end

  def caveats
    <<~EOS
      This release requires macOS 26 or later on Apple silicon.
      Running HGL programs on the C++ target requires Apple Clang 21 or later.
    EOS
  end

  test do
    ENV.delete("HGL_HGRAPH_SDK")
    ENV.delete("HGL_HGRAPH_DEPS")
    ENV["HGL_NATIVE_CACHE"] = (testpath/"native-cache").to_s

    assert_match "hgl #{version}", shell_output("#{bin}/hgl --version")
    (testpath/"smoke.hgl").write <<~HGL
      module smoke.formula

      const fn add_one(value: i64) -> i64 => value + 1

      test bundled_sdk {
          assert add_one(2) == 3
      }
    HGL
    system bin/"hgl", "check", "smoke.hgl"
    assert_match "passed   executable  smoke.formula::bundled_sdk",
                 shell_output("#{bin}/hgl test --target cpp smoke.hgl")
  end
end
