{
  description = "Skills and global instructions shared across every coding agent";

  # No inputs on purpose. The Home Manager module reads lib and pkgs from the host
  # config, so a consumer gains no second nixpkgs to follow and no lock churn.
  outputs =
    { self }:
    {
      homeModules.default = import ./nix/home-manager.nix self;

      # Alias, so an import reads as what it is at the call site.
      homeModules.dotagents = self.homeModules.default;
    };
}
