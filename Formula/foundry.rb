class Foundry < Formula
  desc "CLI for managing AI agent workspaces using git worktrees and terminal automation"
  homepage "https://github.com/xiphux/foundry"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.1.0/foundry-aarch64-apple-darwin.tar.xz"
      sha256 "3576ac976ddc3977b476ec381254b33e7c4dfec78dc6b3e52cbad0e8d077066a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.1.0/foundry-x86_64-apple-darwin.tar.xz"
      sha256 "cf590e8789a9bfde95a34abd33fed71a5c1f9caf636d07a9750cc51d5728daf8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.1.0/foundry-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "910cc950d976bd1a80bc03fb1f8c26c178e7561db96952eeb56404486a5c94b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.1.0/foundry-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dffd43b3990bee942653258f9fb53d75c5c0f5915e1e9c92fb5565718d0da5d5"
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
