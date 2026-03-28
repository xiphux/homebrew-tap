class Foundry < Formula
  desc "CLI for managing AI agent workspaces using git worktrees and terminal automation"
  homepage "https://github.com/xiphux/foundry"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.2.0/foundry-aarch64-apple-darwin.tar.xz"
      sha256 "17a6c874e08e3a72efc5f94bafa91e659ce3e0e4921cbb6d78602e1f9f70b2a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.2.0/foundry-x86_64-apple-darwin.tar.xz"
      sha256 "11f5843048a7bdb73398b73790b6e3a8b999a322fc6e97b18c9a9c3dde88ac1d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.2.0/foundry-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "66ea9bc3575b9413d4dbbd4631cb7637d315cbfc1ce0249e46febf4ce3d11110"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.2.0/foundry-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ec9070a82e69acfa2640be6c0ef183df4ed598cdf2f3143155e32b2508fc04a4"
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
