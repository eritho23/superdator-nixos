# {config}:
# {
#   services.caddy = {
#     enable = true;
#     email = "eric.thorburn@hitachigymnasiet.se";

#     virtualHosts = {
#       ":80, :443"= {
#         extraConfig = ''
#           respond "Hello, World!"
#           tls internal
#         '';
#         logFormat = ''
#           output file ${config.services.caddy.logDir}-access-https.log
#         '';
#       };
#     };
#   };
# }
