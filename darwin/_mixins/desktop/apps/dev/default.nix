{ pkgs, ... }:
{
  homebrew = {
    brews = [
      "composer"
      "docker"
      "docker-completion"
      "jupyter"
      "jupyterlab"
      "lazydocker"
      "neovim"
      "nowplaying-cli"
      "mono-libgdiplus"
      "newman"
      "pre-commit"
      "switchaudio-osx"
    ];

    casks = [
      "git-credential-manager"
      "sf-symbols"
      "ghostty"
      "julia"
      "postman"
      "insomnia"
    ];

  };

  environment.systemPackages = with pkgs; [
    kubernetes-helm
    kubectl
    helm-ls
    hugo
    helmfile
    helmsman
    helm-docs
    jq
    minikube
    prettierd
    prettier-plugin-go-template
    tenv
    terraformer
    terraform-ls
  ];
}
