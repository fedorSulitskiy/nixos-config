{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hunspell
    hunspellDicts.en-gb-ise
    hunspellDicts.en-gb-large
  ];
}
