class Foundry < Formula
  desc "CLI for managing AI agent workspaces using git worktrees and terminal automation"
  homepage "https://github.com/xiphux/foundry"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.3.0/foundry-aarch64-apple-darwin.tar.xz"
      sha256 "4a7dd6c74c9767b2b667a4f7b04fa3ba2118309dfbb9dcd5bb03a50d16a34665"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.3.0/foundry-x86_64-apple-darwin.tar.xz"
      sha256 "0301fb856d28de72889244945074c62cd8a3cb06a75e52165a1c9be720c520cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xiphux/foundry/releases/download/v0.3.0/foundry-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4da1bb7f613ef2ffc3761d6ce39ff8a44e1fd155317d842470758b70b864789d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xiphux/foundry/releases/download/v0.3.0/foundry-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "78dd8c000ccc2217f3ed8ed5722528e68b2ee7e3bd63ba4cd7e1a27926d5870b"
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
