{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ansible
    ansible-lint
    bash-language-server
    coursier
    go
    gopls
    jdk
    jdk17
    jdk23
    jre8
    luajit_openresty
    lua-language-server
    maven
    scala
    scalafmt
    scalafix
    stylua
  ];
}
