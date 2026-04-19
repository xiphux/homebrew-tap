class Foundry < Formula
  desc "CLI for managing AI agent workspaces using git worktrees and terminal automation"
  homepage "https://github.com/xiphux/foundry"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.4.0/foundry-aarch64-apple-darwin.tar.xz"
      sha256 "56e63a397784045a8497c1a202cd3a44728aac8db088c5c52234a4f586c8437d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.4.0/foundry-x86_64-apple-darwin.tar.xz"
      sha256 "e861d524c7c6f8dbd66bb9f848a5ad3d515fada0cbd6ee0f938fda6998675795"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.4.0/foundry-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "577846b300d0f2ec0af59c31e5543f9a1938de67c5994656f50802bd12c7d5a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.4.0/foundry-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d9710f37fbf6a03ca4809b5dd5e123afffb33e3a946d456697e81f3e4aff620"
    end
  end
  license "GPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "foundry" if OS.mac? && Hardware::CPU.arm?
    bin.install "foundry" if OS.mac? && Hardware::CPU.intel?
    bin.install "foundry" if OS.linux? && Hardware::CPU.arm?
    bin.install "foundry" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
