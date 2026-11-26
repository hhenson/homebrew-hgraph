# frozen_string_literal: true

# Installs the published HGL release's debug libraries and symbol files.
class HglDebug < Formula
  desc "Debugging libraries and symbol files for the HGL compiler's hgraph SDK"
  homepage "https://github.com/hhenson/hgl-compiler"
  url "https://github.com/hhenson/hgl-compiler/releases/download/0.2.11/hgl-debug-0.2.11-macos-arm64.tar.gz"
  sha256 "189a40412d761fdb0c50167468c4505e28b4863bd5fb8dc7a69a47e8d4da88e6"
  license all_of: ["MIT", "Apache-2.0"]

  depends_on arch: :arm64
  depends_on "hhenson/hgraph/hgl"
  depends_on macos: :tahoe

  def install
    # The symbol files belong to one build of hgl's libraries.
    hgl = Formula["hhenson/hgraph/hgl"].any_installed_version
    installed = hgl || "none"
    odie "hgl-debug #{version} needs hgl #{version}; installed hgl: #{installed}" if hgl&.version != version

    libexec.install Dir["*"]
  end

  test do
    ENV.delete("HGL_HGRAPH_SDK")
    ENV.delete("HGL_HGRAPH_DEPS")
    ENV.delete("HGL_HGRAPH_DEBUG")
    ENV["HGL_NATIVE_CACHE"] = (testpath/"native-cache").to_s

    (testpath/"smoke.hgl").write <<~HGL
      module smoke

      fn ticks(const values: list<i64>, const every: duration = 1s) -> i64 {
          for value in values {
              yield every: value
          }
      }

      export fn counted(const values: list<i64>) -> i64 {
          return ticks(values)
      }
    HGL
    (testpath/"smoke.backtest.hgl").write <<~HGL
      application smoke.backtest

      use smoke::{counted}

      eval counted(values: [1, 2])
    HGL
    hgl = formula_opt_bin("hhenson/hgraph/hgl")/"hgl"
    described = shell_output("#{hgl} run . --debug-build #{testpath}/debug 2>#{testpath}/said")
    assert_match(/^hgl: a debug build, with hgraph's debug libraries in .*, installed beside hgl$/,
                 (testpath/"said").read)
    assert_equal "debug", JSON.parse(described)["hgraph"]["libraries"]
  end
end
