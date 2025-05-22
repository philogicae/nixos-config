{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];
  
  # QEMU guest agent
  services.qemuGuest.enable = true;

  # allow local remote access to make it easier to toy around with the system
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      AllowUsers = null;
      PermitRootLogin = "prohibit-password";
    };
  };
}
