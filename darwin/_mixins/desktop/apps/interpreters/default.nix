{ pkgs, ... }:
{
  homebrew = {
    brews = [
      "go"
      "gopls"
    ];
  };
  environment.systemPackages = with pkgs; [
    ansible
    ansible-lint
    bash-language-server
    coursier
    jdk
    jdk17
    jdk23
    jre8
    luajit_openresty
    luajitPackages.luarocks
    lua-language-server
    maven
    scala
    scalafmt
    scalafix
    stylua
    texliveTeTeX
  ];
}
