# Home Manager module. Links every skill directory and instruction file into the paths
# each harness reads, which is what install.sh does on a machine without Nix. The two
# are interchangeable; pick one per machine rather than running both, because install.sh
# replaces a home-manager symlink it finds in the way.
self:
{ config, lib, ... }:
let
  cfg = config.dotagents;

  skillNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir "${cfg.src}/skills")
  );

  # One link per skill rather than one link for the whole directory, so a harness
  # directory can still hold entries this repo does not own. Claude Code writes
  # ~/.claude/skills/synced itself, and a single link over the parent would hide it.
  linkSkills =
    dir:
    lib.listToAttrs (
      map (name: lib.nameValuePair "${dir}/${name}" { source = "${cfg.src}/skills/${name}"; }) cfg.skills
    );
in
{
  options.dotagents = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Link the skills and instruction files. Defaults to true, so importing the
        module is the whole opt-in.
      '';
    };

    src = lib.mkOption {
      type = lib.types.path;
      default = self;
      defaultText = lib.literalExpression "inputs.dotagents";
      description = ''
        The repo to link from. Point it at a working tree to test an edit without
        committing and re-locking.
      '';
    };

    skills = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = skillNames;
      defaultText = lib.literalExpression "every directory under skills/";
      description = ''
        Which skills to link. Set it to a subset to leave one out, or use
        lib.subtractLists to drop a few from the default.
      '';
    };

    claude.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Link skills into ~/.claude/skills and the instruction files into ~/.claude.";
    };

    codex.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Link skills into ~/.codex/skills and AGENTS.md into ~/.codex.";
    };

    opencode.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Link skills into ~/.config/opencode/skill and AGENTS.md into
        ~/.config/opencode. Off by default, because turning it on creates the
        directory whether or not opencode is installed.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # ~/.claude and ~/.codex are not XDG directories, so they go through home.file.
    home.file = lib.mkMerge [
      (lib.mkIf cfg.claude.enable (
        linkSkills ".claude/skills"
        // {
          ".claude/CLAUDE.md".source = "${cfg.src}/claude/CLAUDE.md";
          ".claude/RTK.md".source = "${cfg.src}/claude/RTK.md";
          # CLAUDE.md pulls this in with @unslop.md, so it has to sit beside it.
          ".claude/unslop.md".source = "${cfg.src}/skills/unslop/SKILL.md";
        }
      ))

      (lib.mkIf cfg.codex.enable (
        linkSkills ".codex/skills"
        // {
          ".codex/AGENTS.md".source = "${cfg.src}/AGENTS.md";
        }
      ))
    ];

    xdg.configFile = lib.mkIf cfg.opencode.enable (
      linkSkills "opencode/skill"
      // {
        "opencode/AGENTS.md".source = "${cfg.src}/AGENTS.md";
      }
    );
  };
}
