require_relative 'handler'

module OptimusPrimer
  class BlacklistingHandler
    FEATURE_PATH = %i[nvidia blacklisting]

    include Handler
  end
end