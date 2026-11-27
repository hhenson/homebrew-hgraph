# frozen_string_literal: true

# Installs the published HGL bundle with its SDK.
class Hgl < Formula
  desc "Compiler for the HGL language"
  homepage "https://github.com/hhenson/hgl-compiler"
  if OS.linux?
    url "https://github.com/hhenson/hgl-compiler/releases/download/0.2.12/hgl-0.2.12-linux-x86_64.tar.gz"
    sha256 "79df73d10f9e807b191e46648a40ae7b561ea5af0dcefb833c56dbfdb70c4d4c"
  else
    url "https://github.com/hhenson/hgl-compiler/releases/download/0.2.12/hgl-0.2.12-macos-arm64.tar.gz"
    sha256 "57996676dcf69f385fec023076be3a6b9a6405d37a49116701b6370eccd89672"
  end
  license "MIT"

  bottle do
    root_url "https://github.com/hhenson/hgl-compiler/releases/download/0.2.12"
    sha256 cellar: :any, arm64_tahoe: "e14fa4f10c6286176dd6fe221515e15cb5668ca10a2ab0359338f15d1035e2f3"
  end

  depends_on "cmake"
  depends_on "ninja"

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :tahoe
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    if OS.linux? && OS::Linux::Glibc.system_version < Version.new("2.43")
      odie "The Linux HGL release requires system glibc 2.43 or later. Use Ubuntu 26.04 LTS."
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/hgl"
    return unless OS.mac?

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
    if OS.linux?
      <<~EOS
        This release supports x86-64 Ubuntu 26.04 LTS with system glibc 2.43 and libstdc++.
        Running HGL programs on the C++ target requires Ubuntu's g++-15.
      EOS
    else
      <<~EOS
        This release requires macOS 26 or later on Apple silicon.
        Running HGL programs on the C++ target requires Apple Clang 21 or later.
      EOS
    end
  end

  test do
    ENV.delete("HGL_HGRAPH_SDK")
    ENV.delete("HGL_HGRAPH_DEPS")
    ENV["HGL_NATIVE_CACHE"] = (testpath/"native-cache").to_s
    ENV["CXX"] = "/usr/bin/g++-15" if OS.linux?

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
