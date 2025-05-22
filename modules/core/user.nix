{
  pkgs,
  inputs,
  username,
  host,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username host; };
    users.${username} = {
      imports =
        if (host == "desktop") then
          [ ./../home/default.desktop.nix ]
        else
          [ ./../home ];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJ4m7tXLr9v+zLzTEv+AX738I9LGkPGhvjvbeuq0/bOZkqKIm+u/JxL5N5dZd5dF16tBISu8OwZFRiEX91BATQPq4mAp3klVyMv+PN7S5ryeACxLwmqXmeQ3OYe1mp9Na7glVGi29wokcDg/xcKi0KdJ5Q+hVyB4x2qrSI8PfrB6Go4hp9Ii94hMuPVtDvt6X39FEjew5+ljByLghAwtfXMtF+Gc2XfElYTYzlrkCug+/lBI0tvFJEq1yxBIzCldG9h7e2c1DIrV13IHTG9GLlZDuYeZL3OQV8UDzSGhyPVA+u7rFQfNDB4rVYk57songF55vEZbnpccx1WqZIEFiUYCh1ZSlF3cBi82YmYz1BlqVF2AHwwISZvuHwM3QR/YLWW7P3uR/yMGMPisReMyaGE1GYtbabobqfHJ9+LaERsJQNMnwVPTtgIwzKKX49aXnTfAtWUIEK7lOU7SOpdTIjW+mT3p+cUQXB//E4T0+njPECE3a0ZOv2vWVDhZJOpwGt+mwoU8wsldqu9sTMXbK6RH85RfRMnwXNwq5pWzp89HyJppznSHmQ7ODzTV/xgvRsm4yeKVB3E4BGnS3AQMjmDHZCyjyAXAyC8ibXKD8+t1VT3MeQcBuohsd0qs81vY33jMailYwn/GpdPhGqF0RIRHq4kK/nvXGYmc2fV6BKkw== debian"
    ];
  };
  nix.settings.allowed-users = [ "${username}" ];
}
