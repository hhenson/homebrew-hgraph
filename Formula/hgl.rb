# frozen_string_literal: true

# Installs the published HGL bundle with its SDK.
class Hgl < Formula
  desc "Compiler for the HGL language"
  homepage "https://github.com/hhenson/hgl-compiler"
  url "https://github.com/hhenson/hgl-compiler/releases/download/0.2.7/hgl-0.2.7-macos-arm64.tar.gz"
  sha256 "541d17e40fc2732449e61f32f38e70062d3dfdec57d8a1d1e647b2e6cdf0bda5"
  license "MIT"

  depends_on arch: :arm64
  depends_on "cmake"
  depends_on macos: :tahoe
  depends_on "ninja"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/hgl"

    # hgl-debug installs into a keg of its own. Link its debug libraries, and the
    # symbol file of each library here, through its opt path, which follows its
    # upgrades. The links lead nowhere until it is installed. They are made with
    # ln_sf: install_symlink resolves the opt path to a versioned keg when
    # hgl-debug is already installed.
    debug = HOMEBREW_PREFIX/"opt/hgl-debug/libexec/libexec"
    links = { libexec/"libexec" => [debug/"hgraph-debug"] }
    %w[hgraph-sdk hgraph-deps].each do |prefix|
      lib = libexec/"libexec"/prefix/"lib"
      links[lib] = lib.glob("*.dylib").reject(&:symlink?).map do |dylib|
        debug/prefix/"lib/#{File.basename(dylib.dylib_id)}.dSYM"
      end
    end
    links.each do |dir, targets|
      targets.each { |target| ln_sf target.relative_path_from(dir), dir/target.basename }
    end
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
