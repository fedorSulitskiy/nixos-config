{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withRabbitMQ.enable =
      lib.mkEnableOption "enables Rabbit MQ on this machine";
  };

  config = lib.mkIf config.withRabbitMQ.enable {
    services.rabbitmq = {
      enable = true;
      managementPlugin.enable = true;
    };

    environment.systemPackages = with pkgs; [
      rabbitmq-server
    ];
  };
}
