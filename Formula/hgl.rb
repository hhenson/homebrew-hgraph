# frozen_string_literal: true

# Installs the published HGL bundle with its SDK.
class Hgl < Formula
  desc "Compiler for the HGL language"
  homepage "https://github.com/hhenson/hgl-compiler"
  url "https://github.com/hhenson/hgl-compiler/releases/download/0.2.4/hgl-0.2.4-macos-arm64.tar.gz"
  sha256 "2de9a801aad59d546d1cd5ee8c04f849b37f3b56fa3fb2fabed31b6b97de3c81"
  license "MIT"

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
