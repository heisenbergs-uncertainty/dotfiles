{ pkgs, ... }:
{
  homebrew = {
    brews = [
      "composer"
      "docker"
      "docker-completion"
      # "kubernetes-cli"
      "lazydocker"
      "neovim"
      "node"
      "nowplaying-cli"
      "newman"
      "nvm"
      "pre-commit"
      "pyenv"
      "pyenv-virtualenv"
      "python3"
      "switchaudio-osx"
    ];

    casks = [
      "sf-symbols"
      "ghostty"
      "julia"
      "postman"
      "insomnia"
      "jetbrains-toolbox"
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
    tenv
    terraformer
    terraform-ls
  ];
}
