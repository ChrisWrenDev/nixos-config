{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  cfg = config.programs.vscode-custom;
in
{
  options.programs.vscode-custom = {
    enable = lib.mkEnableOption "VS Code configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    userSettings = {
      # Visuals
      "window.zoomLevel" = 0.25;
      "workbench.colorTheme" = "GitHub Dark Default";
      "editor.fontFamily" = "Input Mono, monospace";
      "terminal.integrated.fontFamily" = "MesloLGS NF";
      "editor.fontSize" = 18;
      "workbench.fontAliasing" = "antialiased";
      "editor.fontLigatures" = true;
      "editor.wordWrap" = "wordWrapColumn";
      "editor.lineHeight" = 1.5;
      "editor.cursorStyle" = "line";
      "editor.cursorBlinking" = "solid";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.tabSize" = 4;
      "editor.detectIndentation" = false;
      "editor.scrollbar.horizontal" = "hidden";
      "editor.scrollbar.vertical" = "hidden";
      "editor.overviewRulerBorder" = false;
      "workbench.list.smoothScrolling" = true;
      "editor.minimap.enabled" = false;
      "breadcrumbs.enabled" = false;
      "workbench.layoutControl.enabled" = false;
      "workbench.tips.enabled" = false;
      "editor.renderWhitespace" = "none";
      "update.showReleaseNotes" = false;
      "workbench.activityBar.location" = "hidden";
      "workbench.startupEditor" = "none";
      "window.customTitleBarVisibility" = "never";

      # Editor
      "workbench.editor.enablePreview" = true;
      "workbench.editor.enablePreviewFromQuickOpen" = false;
      "workbench.editor.enablePreviewFromCodeNavigation" = false;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "editor.scrollBeyondLastLine" = false;
      "editor.lightbulb.enabled" = "off";
      "editor.suggest.insertMode" = "replace";
      "files.insertFinalNewline" = true;
      "editor.accessibilitySupport" = "off";

      # Auto Close Tag
      "editor.linkedEditing" = true;
      "html.autoClosingTags" = true;
      "javascript.autoClosingTags" = true;
      "typescript.autoClosingTags" = true;
      "javascript.preferences.renameMatchingJsxTags" = true;
      "typescript.preferences.renameMatchingJsxTags" = true;

      # Bracket Pairs
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = true;
      "editor.guides.highlightActiveIndentation" = true;
      "editor.guides.bracketPairsHorizontal" = "active";

      # File Tree
      "workbench.tree.expandMode" = "singleClick";
      "workbench.tree.indent" = 10;
      "workbench.tree.renderIndentGuides" = "none";

      # Auto Imports
      "javascript.suggest.autoImports" = true;
      "typescript.suggest.autoImports" = true;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "typescript.preferences.quoteStyle" = "double";
      "javascript.preferences.quoteStyle" = "double";
      "javascript.format.semicolons" = "insert";
      "typescript.format.semicolons" = "insert";
      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "always";
      };

      # Formatting
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      # Go
      "gopls" = {
        "ui.semanticTokens" = true;
        "formatting.gofumpt" = true;
      };
      "go.toolsManagement.autoUpdate" = true;

      # Zig
      "zig.path" = "${pkgs.zig}/bin/zig";
      "zig.initialSetupDone" = true;

      # Terminal
      "terminal.integrated.cursorBlinking" = false;
      "terminal.integrated.cursorStyle" = "line";
      "terminal.integrated.fontSize" = 18;
      "terminal.integrated.fontWeight" = "300";
      "terminal.integrated.persistentSessionReviveProcess" = "never";
      "terminal.integrated.tabs.enabled" = false;

      # Search
      "search.mode" = "reuseEditor";
      "search.exclude" = {
        "**/*.snap" = true;
        "**/*.svg" = true;
        "**/.git" = true;
        "**/.github" = false;
        "**/.nuxt" = true;
        "**/.output" = true;
        "**/.pnpm" = true;
        "**/.vscode" = true;
        "**/.yarn" = true;
        "**/assets" = true;
        "**/bower_components" = true;
        "**/dist/**" = true;
        "**/logs" = true;
        "**/node_modules" = true;
        "**/out/**" = true;
        "**/package-lock.json" = true;
        "**/pnpm-lock.yaml" = true;
        "**/public" = true;
        "**/temp" = true;
        "**/yarn.lock" = true;
        "**/CHANGELOG*" = true;
        "**/LICENSE*" = true;
      };

      # Vim
      "vim.leader" = "<space>";
      "editor.lineNumbers" = "relative";
      "vim.easymotion" = true;
      "vim.incsearch" = true;
      "vim.useSystemClipboard" = true;
      "vim.useCtrlKeys" = true;
      "vim.hlsearch" = true;

      "vim.normalModeKeyBindingsNonRecursive" = [
        { "before" = [ "leader" "p" "v" ]; "commands" = [ "workbench.explorer.fileView.focus" ]; }
        { "before" = [ "leader" "n" ]; "commands" = [ ":tabn" ]; }
        { "before" = [ "leader" "p" ]; "commands" = [ ":tabp" ]; }
        { "before" = [ "ctrl" "0" ]; "commands" = [ ":tabm 0" ]; }
        { "before" = [ "ctrl" "1" ]; "commands" = [ ":tabm 1" ]; }
        { "before" = [ "ctrl" "2" ]; "commands" = [ ":tabm 2" ]; }
        { "before" = [ "ctrl" "3" ]; "commands" = [ ":tabm 3" ]; }
        { "before" = [ "ctrl" "4" ]; "commands" = [ ":tabm 4" ]; }
        { "before" = [ "ctrl" "5" ]; "commands" = [ ":tabm 5" ]; }
        { "before" = [ "ctrl" "6" ]; "commands" = [ ":tabm 6" ]; }
        { "before" = [ "ctrl" "7" ]; "commands" = [ ":tabm 7" ]; }
        { "before" = [ "ctrl" "8" ]; "commands" = [ ":tabm 8" ]; }
        { "before" = [ "ctrl" "9" ]; "commands" = [ ":tabm 9" ]; }
        { "before" = [ "leader" "s" "v" ]; "commands" = [ ":vsplit" ]; }
        { "before" = [ "leader" "s" "h" ]; "commands" = [ ":split" ]; }
        { "before" = [ "leader" "s" "x" ]; "commands" = [ ":close" ]; }
        { "before" = [ "leader" "h" ]; "commands" = [ "workbench.action.focusLeftGroup" ]; }
        { "before" = [ "leader" "j" ]; "commands" = [ "workbench.action.focusBelowGroup" ]; }
        { "before" = [ "leader" "k" ]; "commands" = [ "workbench.action.focusAboveGroup" ]; }
        { "before" = [ "leader" "l" ]; "commands" = [ "workbench.action.focusRightGroup" ]; }
        { "before" = [ "[" "d" ]; "commands" = [ "editor.action.marker.prev" ]; }
        { "before" = [ "]" "d" ]; "commands" = [ "editor.action.marker.next" ]; }
      ];

      "vim.visualModeKeyBindings" = [
        { "before" = [ "<" ]; "commands" = [ "editor.action.outdentLines" ]; }
        { "before" = [ ">" ]; "commands" = [ "editor.action.indentLines" ]; }
        { "before" = [ "J" ]; "commands" = [ "editor.action.moveLinesDownAction" ]; }
        { "before" = [ "K" ]; "commands" = [ "editor.action.moveLinesUpAction" ]; }
        { "before" = [ "leader" "c" ]; "commands" = [ "editor.action.commentLine" ]; }
      ];

      # Extensions
      "extensions.ignoreRecommendations" = true;
      "extensions.autoUpdate" = "onlyEnabledExtensions";

      # Emmet
      "emmet.showSuggestionsAsSnippets" = true;
      "emmet.triggerExpansionOnTab" = false;

      # Error Lens
      "errorLens.enabledDiagnosticLevels" = [ "warning" "error" ];
      "errorLens.excludeBySource" = [ "cSpell" "Grammarly" "eslint" ];

      # ESLint
      "eslint.codeAction.showDocumentation" = {
        "enable" = true;
      };
      "eslint.quiet" = true;
      "css.lint.hexColorLength" = "ignore";
      "eslint.rules.customizations" = [
        { "rule" = "style/*"; "severity" = "off"; }
        { "rule" = "format/*"; "severity" = "off"; }
        { "rule" = "*-indent"; "severity" = "off"; }
        { "rule" = "*-spacing"; "severity" = "off"; }
        { "rule" = "*-spaces"; "severity" = "off"; }
        { "rule" = "*-order"; "severity" = "off"; }
        { "rule" = "*-dangle"; "severity" = "off"; }
        { "rule" = "*-newline"; "severity" = "off"; }
        { "rule" = "*quotes"; "severity" = "off"; }
        { "rule" = "*semi"; "severity" = "off"; }
      ];
      "eslint.validate" = [
        "javascript"
        "javascriptreact"
        "typescript"
        "typescriptreact"
        "react"
        "html"
        "markdown"
        "json"
        "jsonc"
        "yaml"
        "toml"
      ];

      # GitLens
      "gitlens.codeLens.authors.enabled" = false;
      "gitlens.codeLens.enabled" = false;
      "gitlens.codeLens.recentChange.enabled" = false;
      "diffEditor.codeLens" = true;
      "gitlens.menus" = {
        "editor" = {
          "blame" = false;
          "clipboard" = true;
          "compare" = true;
          "history" = false;
          "remote" = false;
        };
        "editorGroup" = {
          "blame" = true;
          "compare" = false;
        };
        "editorTab" = {
          "clipboard" = true;
          "compare" = true;
          "history" = true;
          "remote" = true;
        };
        "explorer" = {
          "clipboard" = true;
          "compare" = true;
          "history" = true;
          "remote" = true;
        };
        "scm" = {
          "authors" = true;
        };
        "scmGroup" = {
          "compare" = true;
          "openClose" = true;
          "stash" = true;
        };
        "scmGroupInline" = {
          "stash" = true;
        };
        "scmItem" = {
          "clipboard" = true;
          "compare" = true;
          "history" = true;
          "remote" = false;
          "stash" = true;
        };
      };
    };

    keybindings = [
      { "key" = "ctrl+t"; "command" = "workbench.action.togglePanel"; }
      { "key" = "ctrl+j"; "command" = "workbench.action.terminal.focusNext"; "when" = "terminalFocus"; }
      { "key" = "ctrl+k"; "command" = "workbench.action.terminal.focusPrevious"; "when" = "terminalFocus"; }
      { "key" = "ctrl+n"; "command" = "workbench.action.terminal.new"; "when" = "terminalFocus"; }
      { "key" = "ctrl+q"; "command" = "workbench.action.terminal.kill"; "when" = "terminalFocus"; }
      { "key" = "ctrl+e"; "command" = "workbench.action.toggleSidebarVisibility"; }
      { "key" = "ctrl+e"; "command" = "workbench.files.action.focusFilesExplorer"; "when" = "editorTextFocus"; }
      { "key" = "n"; "command" = "explorer.newFile"; "when" = "filesExplorerFocus && !inputFocus"; }
      { "key" = "r"; "command" = "renameFile"; "when" = "filesExplorerFocus && !inputFocus"; }
      { "key" = "d"; "command" = "deleteFile"; "when" = "filesExplorerFocus && !inputFocus"; }
      { "key" = "shift+n"; "command" = "explorer.newFolder"; "when" = "explorerViewletFocus"; }
    ];

    extensions =
      (with pkgs.vscode-extensions; [
        ms-dotnettools.csharp
        naumovs.color-highlight
        ms-vscode-remote.remote-containers
        ms-azuretools.vscode-docker
        mikestead.dotenv
        golang.go
        wix.vscode-import-cost
        sumneko.lua
        yzhang.markdown-all-in-one
        jnoortheen.nix-ide
        esbenp.prettier-vscode
        prisma.prisma
        ms-python.python
        ms-vscode-remote.remote-ssh
        humao.rest-client
        bradlc.vscode-tailwindcss
        gruntfuggly.todo-tree
      ])
      ++ (with pkgs.vscode-marketplace; [
        amazonwebservices.aws-toolkit-vscode
        christian-kohler.path-intellisense
        continue.continue
        dbaeumer.vscode-eslint
        deque-systems.vscode-axe-linter
        eamodio.gitlens
        github.github-vscode-theme
        graphql.vscode-graphql
        graphql.vscode-graphql-syntax
        jinliming2.vscode-go-template
        ms-vscode.makefile-tools
        redhat.fabric8-analytics
        redhat.vscode-xml
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        sonarsource.sonarlint-vscode
        syler.sass-indented
        usernamehw.errorlens
        vscodevim.vim
        yoavbls.pretty-ts-errors
        danielpriestley.poimandres-alternate
        pufferbommy.pretty-poimandres
        formulahendry.auto-rename-tag
        chakrounanas.turbo-console-log
        streetsidesoftware.code-spell-checker
        ziglang.vscode-zig
      ]);
  };
  };
}
