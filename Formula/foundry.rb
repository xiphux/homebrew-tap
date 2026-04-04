class Foundry < Formula
  desc "CLI for managing AI agent workspaces using git worktrees and terminal automation"
  homepage "https://github.com/xiphux/foundry"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.3.1/foundry-aarch64-apple-darwin.tar.xz"
      sha256 "f24aaccbfb7a953754fdb9fe0f6bf23f1c4147b8368d3cb3e0f74a24745efc56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.3.1/foundry-x86_64-apple-darwin.tar.xz"
      sha256 "3f5cf9a57ef303fbcfeb1a10edf31a27b646c97c7431171ac296a4966529a221"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.3.1/foundry-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "feb1e5f0477e34d5941ea320d7388e9e97ac8dfaa26acf6c55e0c37710215246"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.3.1/foundry-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "50c074ec54df5bbc5842d44be3c999563b0767301b69d420d986241e318675bf"
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
