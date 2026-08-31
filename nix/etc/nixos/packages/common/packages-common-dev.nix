{ config, pkgs, ... }:

{

	environment.systemPackages = with pkgs; [

		### PROGRAMMING ###
		gdb                         # GNU Project debugger
		git                         # Distributed version control system
		git-filter-repo             # Quickly rewrite git repository history
		gitmoji-cli                 # Gitmoji client for using emojis on commit messages
		neocities                   # CLI and library for interacting with the Neocities API
			### ASSEMBLY ###
		cutter                      # Free and Open Source Reverse Engineering Platform powered by rizin
		# ida-free                  # Freeware version of the world's smartest and most feature-full disassembler
		                            # NB: Can't be downloaded automatically because of licensing
		nasm                        # 80x86 and x86-64 assembler designed for portability and modularity
			### C ###
		clang                       # C language family frontend for LLVM (wrapper script)
		gcc                         # GNU Compiler Collection, version 14.3.0 (wrapper script)
		codeblocksFull              # Open source, cross platform, free C, C++ and Fortran IDE
		clang-tools                 # Standalone command line tools for C++ development
			### HASKELL ###
		cabal-install               # The command-line interface for Cabal and Hackage
		haskell-language-server     # LSP server for GHC
		# ghc                       # Glasgow Haskell Compiler
		(haskellPackages.ghcWithPackages (ps: with ps; [
			aeson                   # Fast JSON parsing and encoding
			brick                   # A declarative terminal user interface library
			bytestring              # 
			cassava                 # A CSV parsing and encoding library
			Decimal                 # Decimal numbers with variable precision
			dhall                   # A configuration language guaranteed to terminate
			hoogle                  # Haskell API Search
			pretty-simple           # pretty printer for data types with a 'Show' instance
			random                  # Pseudo-random number generation
			texts                   # None
			yaml                    # Support for parsing and rendering YAML documents
			pandoc                  # Conversion between markup formats
		]))
			### HTML ###
			html-tidy               # HTML validator and `tidier'
			### JAVASCRIPT ###
		# deno                        # Secure runtime for JavaScript and TypeScript
			### JSON ###
		jq                          # Lightweight and flexible command-line JSON processor
			### OCAML ###
		ocaml                       # OCaml is an industrial-strength programming language supporting functional, imperative and object-oriented styles
		ocamlPackages.ocaml-lsp     # OCaml Language Server Protocol implementation
		ocamlPackages.utop          # Universal toplevel for OCaml
		ocamlPackages.ocamlformat   # Auto-formatter for OCaml code
			### PASCAL ###
		lazarus                     # Graphical IDE for the FreePascal language
			### PYTHON ###
		(python3.withPackages (ps: [
			ps.colorama             # Cross-platform colored terminal text
			ps.curl-cffi            #
			ps.pandas               # Powerful data structures for data analysis, time series, and statistics
			ps.pyqt5                # Python bindings for Qt5
			ps.pyqt6                # Python bindings for Qt6
			ps.pyyaml               # Next generation YAML parser and emitter for Python
			ps.requests             # HTTP library for Python
			ps.bgutil-ytdlp-pot-provider   # Proof-of-origin token provider plugin for yt-dlp
			]))
			### SQL ###
		# sqlite                    # Self-contained, serverless, zero-configuration, transactional SQL database engine
		sqlite-interactive          # Self-contained, serverless, zero-configuration, transactional SQL database engine
		sqlitebrowser               # DB Browser for SQLite
			### TCL ###
		tcl                         # Tcl scripting language
		tk                          # Widget toolkit that provides a library of basic elements for building a GUI in many different programming languages

			(vscode-with-extensions.override {
				vscodeExtensions = with vscode-extensions; [
					### LANGUAGES ###
					bbenoist.nix                                   # — Nix language support
					bodil.blueprint-gtk                            # Gtk Blueprint language support.
					dhall.dhall-lang                               #
					golang.go                                      # Go extension for Visual Studio Code
					haskell.haskell                                #
					justusadam.language-haskell                    #
					ms-python.python                               # Visual Studio Code extension with rich support for the Python language
					ms-vscode.cpptools                             # C/C++ extension adds language support for C/C++ to Visual Studio Code, including features such as IntelliSense and debugging
					ms-vscode.makefile-tools                       # — Makefile language support
					ms-python.vscode-pylance                       # Performant, feature-rich language server for Python in VS Code
					                                               # NB: Not working
					mechatroner.rainbow-csv                        # Rainbow syntax higlighting for CSV and TSV files in Visual Studio Code
					thenuprojectcontributors.vscode-nushell-lang   #
					ocamllabs.ocaml-platform                       # Official OCaml Support from OCamlLabs
					tamasfe.even-better-toml                       # — TOML language support
					theangryepicbanana.language-pascal             # VSCode extension for high-quality Pascal highlighting
					# bierner.github-markdown-preview                # VSCode extension that changes the markdown preview to support GitHub markdown features
					# shd101wyy.markdown-preview-enhanced            # Provides a live preview of markdown using either markdown-it or pandoc
					### OTHER ###
					naumovs.color-highlight                        # Highlight web colors in your editor
					ms-azuretools.vscode-docker                    # Docker Extension for Visual Studio Code
					donjayamanne.githistory                        # View git log, file history, compare branches or commits
					seatonjiang.gitmoji-vscode                     # Gitmoji tool for git commit messages in VSCode
					ms-vscode-remote.remote-ssh                    # Use any remote machine with a SSH server as your development environment
					streetsidesoftware.code-spell-checker          # Spelling checker for source code
					streetsidesoftware.code-spell-checker-french   # French dictionary extension for VS Code
					github.copilot-chat                            # GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor
					                                               # NB: Not working
					### COLOR THEMES ###
					carrie999.cyberpunk-2020                       # Cyberpunk-inspired colour theme to satisfy your neon dreams
					dhedgecock.radical-vscode                      # Dark theme for radical hacking inspired by retro futuristic design
					nonylene.dark-molokai-theme                    # Theme inspired by VSCode default dark theme, monokai theme and Vim Molokai theme
					nur.just-black                                 # Dark theme designed specifically for syntax highlighting
					viktorqvarfordt.vscode-pitch-black-theme       #
					zhuangtongfa.material-theme                    #
					### ICON THEMES ###
					teabyii.ayu                                    # Simple theme with bright colors and comes in three versions — dark, light and mirage for all day long comfortable work
					vscode-icons-team.vscode-icons                 # Bring real icons to your Visual Studio Code
					# pkief.material-icon-theme                    # Material Design Icons for Visual Studio Code
				];
			})

	];


}
