require "nhl/version"

module NHL
  BASE = "https://statsapi.web.nhl.com/api/v1/"
  MAIN_CDN = "https://nhl.bamcontent.com/images/"
  LOGO_CDN = "https://www-league.nhlstatic.com/builds/site-core/86d4b76cc03a4d111ee0e20f9f62eb054eef3b74_1502985652/images/logos/team/current/"
end

require "nhl/conference"
require "nhl/division"
require "nhl/team"
require "nhl/player"
require "nhl/game"